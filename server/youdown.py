from flask import Flask
from flask import json
import ujson
from flask import request, redirect, url_for
from tinydb import TinyDB, Query
import re
import base64
from twilio.rest import Client
import time
from apns import APNs, Frame, Payload

app = Flask(__name__)

class activityObject:
    def __init__(self, name, creator, pending, attending, messages, actId):
        self.id = actId
        self.name = name
        self.creator = creator
        self.pending = pending
        if len(attending) < 1:
            self.attending = []
            x = 0
            while x < len(pending):
                self.attending.append(False)
                x+=1
        else:
            self.attending = attending
        if len(messages) < 1:
            self.messages = []
        else:
            self.messages = messages

    def sendMessage(self, message, notifMessage):
        fileLocation = "files/activity_" + self.id[0] + ".json"
        db = TinyDB(fileLocation)
        Activity = Query()
        self.messages.append(message)
        db.update({'messages': self.messages}, Activity.id == self.id)
        arrayOfTokens = []
        arrayofPhones = self.pending
        for i in arrayofPhones:
            tempPerson = openPerson(i)
            if tempPerson:
                if tempPerson.name is self.creator:
                    print "dont send to self"
                else:
                    arrayOfTokens.append(tempPerson.notifToken)
            else:
                print "no account for: " + i
        if len(arrayOfTokens) > 0:
            massNotification(arrayOfTokens,notifMessage)
        db.close()

    def amAttending(self, phone):
        x = 0
        while x < len(self.pending):
            if self.pending[x] == phone:
                self.attending[x] = True
                break
            x = x + 1
        fileLocation = "files/activity_" + self.id[0] + ".json"
        db = TinyDB(fileLocation)
        Activity = Query()
        db.update({'attending': self.attending}, Activity.id == self.id)

    def saveActivity(self):
        fileLocation = "files/activity_" + self.id[0] + ".json"
        db = TinyDB(fileLocation)
        db.insert({'id': self.id, 'name': self.name, 'creator': self.creator, 'pending': self.pending, 'attending': self.attending, 'messages': self.messages})
        db.close()

    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)

def openActivity(actId):
    fileLocation = "files/activity_" + actId[0] + ".json"
    db = TinyDB(fileLocation)
    Activity = Query()
    data = db.get(Activity.id == actId)
    newActivityObject = activityObject(data['name'],data['creator'],data['pending'],data['attending'],data['messages'],data['id'])
    return newActivityObject

def openPerson(phone):
    fileLocation = "files/person_" + phone[0] + ".json"
    db = TinyDB(fileLocation)
    Person = Query()
    data = db.get(Person.phone == phone)
    if data:
        newPersonObject = personObject(data['name'],data['phone'],data['token'],data['activities'],data['invites'],data['friendNumbers'],data['friendNames'],data['groups'],0)
        db.close()
        return newPersonObject
    else:
        return

class personObject:
    def __init__(self, name, phone, notifToken, tempActivities, tempInvites, friendNumbers, friendNames, groups, isFirstSignUp):
        self.name = name
        self.phone = phone
        self.notifToken = notifToken
        self.activities = tempActivities
        self.invites = tempInvites
        if isFirstSignUp == 1:
            self.friendNumbers = []
            self.friendNames = []
            x = 0
            while x < len(friendNumbers):
                number = friendNumbers[x]
                fileLocation = "files/person_" + number[0] + ".json"
                db = TinyDB(fileLocation)
                User = Query()
                if db.search(User.phone == friendNumbers[x]):
                    self.friendNumbers.append(friendNumbers[x])
                    self.friendNames.append(friendNames[x])
                x = x + 1
                db.close()
        else:
            self.friendNames = friendNames
            self.friendNumbers = friendNumbers
        self.activationCode = ""
        self.groups = groups

    def savePerson(self):
        fileLocation = "files/person_" + self.phone[0] + ".json"
        db = TinyDB(fileLocation)
        db.insert({'name': self.name, 'phone': self.phone, 'activationCode': self.activationCode,'token': self.notifToken, 'activities': self.activities, 'invites': self.invites, 'friendNumbers' : self.friendNumbers, 'friendNames' : self.friendNames, 'groups' : self.groups})
        db.close()

    def addFriend(self, name, phone):
        fileLocation = "files/person_" + self.phone[0] + ".json"
        db = TinyDB(fileLocation)
        Person = Query()
        self.friendNames.append(name)
        self.friendNumbers.append(phone)
        db.update({'friendNames': self.friendNames, 'friendNumbers': self.friendNumbers}, Person.phone == self.phone)
        db.close()

    def updateToken(self, token):
        fileLocation = "files/person_" + self.phone[0] + ".json"
        db = TinyDB(fileLocation)
        Person = Query()
        self.notifToken = token
        db.update({'token': self.notifToken}, Person.phone == self.phone)
        db.close()

    def modifyGroup(self, group, groupName):
        fileLocation = "files/person_" + self.phone[0] + ".json"
        db = TinyDB(fileLocation)
        Person = Query()
        didFindGroup = False
        x = 0
        while x < len(self.groups):
            tGroup = self.groups[x]
            if groupName in tGroup:
                self.groups[x] = group
                didFindGroup = True
                x = len(self.groups)
            else:
                x = x + 1
        if didFindGroup == False:
            self.groups.append(group)
        db.update({'groups': self.groups}, Person.phone == self.phone)
        db.close()

    def deleteGroup(self, groupName):
        fileLocation = "files/person_" + self.phone[0] + ".json"
        db = TinyDB(fileLocation)
        Person = Query()
        x = 0
        while x < len(self.groups):
            tGroup = self.groups[x]
            if groupName in tGroup:
                del self.groups[x]
                didFindGroup = True
                x = len(self.groups)
            else:
                x = x + 1
        db.update({'groups': self.groups}, Person.phone == self.phone)
        db.close()

    def addActivity(self, actId):
        fileLocation = "files/person_" + self.phone[0] + ".json"
        db = TinyDB(fileLocation)
        Person = Query()
        self.activities.append(actId)
        db.update({'activities': self.activities}, Person.phone == self.phone)
        db.close()

    def addInvite(self, actId):
        fileLocation = "files/person_" + self.phone[0] + ".json"
        db = TinyDB(fileLocation)
        Person = Query()
        self.invites.append(actId)
        db.update({'invites': self.invites}, Person.phone == self.phone)
        db.close()

    def sendVerification(self, codeToReturn):
        account_sid = "ACeb656f3045c4b3b9fb551014a47e5ca0"
        auth_token = "cf7384b792c2d1541f246a50e384521c"
        client = Client(account_sid, auth_token)
        number = "+1" + self.phone
        messageText = "hey " + self.name + " ,your 'are you down' verification code is: " + codeToReturn
        message = client.api.account.messages.create(to=number,
                                                     from_="+15109013162",
                                                     body=messageText)
        fileLocation = "files/person_" + self.phone[0] + ".json"
        db = TinyDB(fileLocation)
        Person = Query()
        self.activationCode = codeToReturn
        db.update({'activationCode': self.activationCode}, Person.phone == self.phone)
        db.close()

def massNotification(tokens, message):
    apns = APNs(use_sandbox=True, cert_file='certificates/certificate.pem', key_file='certificates/npkey.pem')
    frame = Frame()
    identifier = 1
    expiry = time.time()+3600
    priority = 10
    payload = Payload(alert=message, sound="default", badge=1, mutable_content=True)
    for i in tokens:
        frame.add_item(i, payload, identifier, expiry, priority)
    apns.gateway_server.send_notification_multiple(frame)
    return "Success"

def sendNotification(phoneNumber,message):
    apns = APNs(use_sandbox=True, cert_file='certificates/certificate.pem', key_file='certificates/npkey.pem')
    tempPerson = openPerson(phoneNumber)
    frame.add_item(tempPerson.notifToken, payload, identifier, expiry, priority)
    payload = Payload(alert=message, sound="default", badge=1, mutable_content=True)
    apns.gateway_server.send_notification(tempPerson.notifToken, payload)

@app.route('/signUp', methods=['POST'])
def signUp():
    json = request.get_json(force=True)
    code = json['activationCode']
    name = json['name']
    phone = json['phone']
    fileLocation = "files/person_" + phone[0] + ".json"
    db = TinyDB(fileLocation)
    User = Query()
    if db.search(User.phone == phone):
        db.close()
        return "Error"
    else:
        db.close()
        token = json['token']
        friendNames = json['friendNames']
        friendNumbers = json['friendNumbers']
        person = personObject(name,phone,token,[],[],friendNumbers,friendNames,[],1)
        person.savePerson()
        # person.sendVerification(code)
        return "Success"

@app.route('/signIn', methods=['POST'])
def signIn():
    json = request.get_json(force=True)
    code = json['activationCode']
    phone = json['phone']
    token = json['token']
    person = openPerson(phone)
    if person:
        if len(token) > 5:
            person.updateToken(token)
        # person.sendVerification(code)
        return person.name
    else:
        return "sorry, no user found for that number"
        # person.sendVerification(code,name)

@app.route('/addFriend',methods=['POST'])
def addFriend():
    json = request.get_json(force=True)
    phone = json['phone']
    otherPhone = json['otherPhone']
    otherName = json['otherName']
    person = openPerson(phone)
    person.addFriend(otherName,otherPhone)
    returnString = ""
    friendNameList = person.friendNames
    friendNumberList = person.friendNumbers
    groupList = person.groups
    y = 0
    while  y < len(groupList):
        returnString = returnString + groupList[y] + "#$#$"
        y = y + 1
    returnString = returnString + "!@!@"
    x = 0
    while x < len(friendNameList):
        returnString = returnString + "@#$@" + friendNameList[x] + "@#$@" + friendNumberList[x] + "@#$@" + "***"
        x = x + 1
    returnString = returnString + "!@!@"
    return returnString

@app.route('/modifyGroup', methods=['POST'])
def modifyGroup():
    json = request.get_json(force=True)
    phone = json['phone']
    groupName = json['groupName']
    group = json['group']
    person = openPerson(phone)
    person.modifyGroup(group,groupName)
    friendNameList = person.friendNames
    friendNumberList = person.friendNumbers
    groupList = person.groups
    returnString = ""
    y = 0
    while  y < len(groupList):
        returnString = returnString + groupList[y] + "#$#$"
        y = y + 1
    returnString = returnString + "!@!@"
    x = 0
    while x < len(friendNameList):
        returnString = returnString + "@#$@" + friendNameList[x] + "@#$@" + friendNumberList[x] + "@#$@" + "***"
        x = x + 1
    returnString = returnString + "!@!@"
    return returnString

@app.route('/deleteGroup', methods=['POST'])
def deleteGroup():
    json = request.get_json(force=True)
    phone = json['phone']
    groupName = json['groupName']
    person = openPerson(phone)
    person.deleteGroup(groupName)
    friendNameList = person.friendNames
    friendNumberList = person.friendNumbers
    groupList = person.groups
    returnString = ""
    y = 0
    while  y < len(groupList):
        returnString = returnString + groupList[y] + "#$#$"
        y = y + 1
    returnString = returnString + "!@!@"
    x = 0
    while x < len(friendNameList):
        returnString = returnString + "@#$@" + friendNameList[x] + "@#$@" + friendNumberList[x] + "@#$@" + "***"
        x = x + 1
    returnString = returnString + "!@!@"
    return returnString

@app.route('/postActivity', methods=['POST'])
def postActivity():
    # get the sent activity
    json = request.get_json(force=True)
    name = json['name']
    myPhone = json['phone']
    creator = json['creator']
    pending = json['pending']
    actID = json['actID']
    message = json['message']
    me = openPerson(myPhone)
    me.addActivity(actID)
    activity = activityObject(name,creator,pending,[],[],actID)
    activity.saveActivity()
    arrayOfTokens = []
    for i in pending:
        tempPerson = openPerson(i)
        if tempPerson:
            tempPerson.addInvite(actID)
            arrayOfTokens.append(tempPerson.notifToken)
        else:
            print "no account for: " + i
    if len(arrayOfTokens) > 0:
        massNotification(arrayOfTokens,message)
    return "Success"

@app.route('/sendMessage', methods=['POST'])
def sendMessage():
    json = request.get_json(force=True)
    message = json['message']
    notifMessage = json['notifMessage']
    actID = json['actID']
    activity = openActivity(actID)
    activity.sendMessage(message, notifMessage)
    phone = json['phone']
    user = openPerson(phone)
    returnString = "***"
    messageString = ""
    for a in activity.messages:
        messageString = messageString + a +"&*^"
    pendingString = ""
    for b in activity.pending:
        pendingString = pendingString + b +"$#$"
    attendingString = ""
    for c in activity.attending:
        if c == True:
            attendingString = attendingString + "Y@~!"
        else:
            attendingString = attendingString + "N@~!"
    nameString = ""
    for b in activity.pending:
        fileLocation = "files/person_" + b[0] + ".json"
        db = TinyDB(fileLocation)
        Person = Query()
        data = db.get(Person.phone == b)
        if data:
            nameString = nameString + data['name'] + "$#$"
        else:
            nameString = nameString + "unknown user" + "$#$"
    returnString = returnString + "!@#" + activity.id + "!@#" + activity.name + "!@#" + activity.creator + "!@#" + messageString + "!@#" + pendingString + "!@#" + attendingString + "!@#" + nameString + "!@#" + activity.creator + "***"
    return returnString

@app.route('/amAttending', methods=['POST'])
def amAttending():
    json = request.get_json(force=True)
    phone = json['phone']
    actID = json['actID']
    activity = openActivity(actID)
    activity.amAttending(phone)
    fileLocation = "files/person_" + phone[0] + ".json"
    db = TinyDB(fileLocation)
    Person = Query()
    data = db.get(Person.phone == phone)
    newPersonObject = personObject(data['name'],data['phone'],data['token'],data['activities'],data['invites'],data['friendNumbers'],data['friendNames'],data['groups'],0)
    x = 0
    while x < len(newPersonObject.invites):
        if newPersonObject.invites[x] == actID:
            del newPersonObject.invites[x]
            break
    newPersonObject.activities.append(actID)
    db.update({'invites': newPersonObject.invites, 'activities': newPersonObject.activities}, Person.phone == phone)
    returnString = ""
    for i in newPersonObject.invites:
        activity = openActivity(i)
        returnString = returnString + "!@#" + activity.id + "!@#" + activity.name + "!@#" + activity.creator + "***"
    return returnString

@app.route('/getMyInvites', methods=['POST'])
def getMyInvites():
    json = request.get_json(force=True)
    phone = json['phone']
    user = openPerson(phone)
    returnString = ""
    for i in user.invites:
        activity = openActivity(i)
        returnString = returnString + "!@#" + activity.id + "!@#" + activity.name + "!@#" + activity.creator + "***"
    return returnString

@app.route('/getMyFriends', methods=['POST'])
def getMyFriends():
    json = request.get_json(force=True)
    phone = json['phone']
    user = openPerson(phone)
    returnString = ""
    friendNameList = user.friendNames
    friendNumberList = user.friendNumbers
    groupList = user.groups
    y = 0
    while  y < len(groupList):
        returnString = returnString + groupList[y] + "#$#$"
        y = y + 1
    returnString = returnString + "!@!@"
    x = 0
    while x < len(friendNameList):
        returnString = returnString + "@#$@" + friendNameList[x] + "@#$@" + friendNumberList[x] + "@#$@" + "***"
        x = x + 1
    returnString = returnString + "!@!@"
    return returnString

@app.route('/getMyActivities',methods=['POST'])
def getMyActivities():
    json = request.get_json(force=True)
    phone = json['phone']
    user = openPerson(phone)
    returnString = "***"
    for i in user.activities:
        activity = openActivity(i)
        messageString = ""
        for a in activity.messages:
            messageString = messageString + a +"&*^"
        pendingString = ""
        for b in activity.pending:
            pendingString = pendingString + b +"$#$"
        attendingString = ""
        for c in activity.attending:
            if c == True:
                attendingString = attendingString + "Y@~!"
            else:
                attendingString = attendingString + "N@~!"
        nameString = ""
        for b in activity.pending:
                fileLocation = "files/person_" + b[0] + ".json"
                db = TinyDB(fileLocation)
                Person = Query()
                data = db.get(Person.phone == b)
                if data:
                    nameString = nameString + data['name'] + "$#$"
                else:
                    nameString = nameString + "unknown user" + "$#$"
        returnString = returnString + "!@#" + activity.id + "!@#" + activity.name + "!@#" + activity.creator + "!@#" + messageString + "!@#" + pendingString + "!@#" + attendingString + "!@#" + nameString + "!@#" + activity.creator + "***"
    return returnString





if __name__ == "__main__":
    app.run(debug = True, host= '0.0.0.0', threaded=True)




# person = personObject("rob","5105416477","12345",[],[],[],[])
# person.savePerson()
# person = personObject("troy","4157222509","12345",[],[],[],[])
# person.savePerson()
# person = personObject("leslie","5104832559","12345",[],[],[],[])
# person.savePerson()
# person = personObject("home","5104825316","12345",[],[],[],[])
# person.savePerson()
