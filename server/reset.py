from tinydb import TinyDB, Query

string = "abcdefghijklmnopqrstuvwxyz0123456789"
x = 0
while x < 36:
    if x < 26:
        location = "files/activity_" + string[x] + ".json"
        db = TinyDB(location)
    else:
        location = "files/person_" + string[x] + ".json"
        db = TinyDB(location)
    x = x + 1
