//
//  sendView.m
//  are you down
//
//  Created by Robert Crosby on 6/13/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "sendView.h"
#import "friendObject.h"
#import "groupObject.h"
#import "References.h"
#import "addFriendView.h"

@interface sendView () {
    NSString *timeSeconds;
    bool isSelectingDate;
    UILabel *blurItAll;
    UIDatePicker *datePicker;
    __weak IBOutlet UILabel *activityName;
    __weak IBOutlet UIScrollView *superScrollView;
    __weak IBOutlet UITableView *friendsTable;
    __weak IBOutlet UITextField *searchBar;
    __weak IBOutlet UILabel *people;
    __weak IBOutlet UISegmentedControl *segmentControl;
    
    __weak IBOutlet UIToolbar *toolbar;
    
    __weak IBOutlet UIButton *cancelButton;
    
    __weak IBOutlet UIButton *sendButton;
    __weak IBOutlet UIButton *findFriend;
    __weak IBOutlet UIButton *newGroup;
}
- (IBAction)sendButton:(id)sender;
- (IBAction)makeGroup:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (IBAction)findFriend:(id)sender;
- (IBAction)segmentControl:(id)sender;

@end

@implementation sendView

- (void)viewDidLoad {
    if ([References screenHeight] > 568) {
        segmentControl.frame = CGRectMake(segmentControl.frame.origin.x, segmentControl.frame.origin.y, [References screenWidth]-16, segmentControl.frame.size.height);
        superScrollView.frame = CGRectMake(superScrollView.frame.origin.x, superScrollView.frame.origin.y, [References screenWidth], [References screenHeight] - superScrollView.frame.origin.y);
        friendsTable.frame = CGRectMake(friendsTable.frame.origin.x, friendsTable.frame.origin.y, [References screenWidth], superScrollView.frame.size.height-friendsTable.frame.origin.y);
        searchBar.frame = CGRectMake(searchBar.frame.origin.x, searchBar.frame.origin.y, [References screenWidth]-16, searchBar.frame.size.height);
    }
    timeSeconds = @"0";
    isSelectingDate = false;
    alertIsShowing = NO;
    [friendsTable setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];
    [References createLine:self.view xPos:activityName.frame.origin.x-8 yPos:superScrollView.frame.origin.y-1];
    //[References createLine:self.view xPos:0 yPos:friendsTable.frame.origin.y];
    [References cornerRadius:searchBar radius:8.0f];
    [super viewDidLoad];
    recipients = [[NSMutableArray alloc] init];
    recipientNames = [[NSMutableArray alloc] init];
    activityName.text = _activityTitle;
    [self getFriends];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:@"updateFriends"];
    if (text.length > 5) {
        [self getFriends];
    }

}

-(void)getFriends{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]);
    NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/getMyFriends"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"phone"     : [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]
            };
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (error) {
                                   // Returned Error
                                   NSLog(@"Unknown Error Occured");
                               } else {
                                   NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   if ([responseBody isEqualToString:@"Loser"]) {
                                       friendsTable.hidden = TRUE;
                                       searchBar.hidden = TRUE;
                                   } else {
                                       
                                   friendsTable.hidden = false;
                                   searchBar.hidden = false;
                                   NSLog(@"%@",responseBody);
                                   //NSLog(@"detected change, refreshing friends and groups");
                                   [_groupList removeAllObjects];
                                   [_friendList removeAllObjects];
                                   _groupList = [[NSMutableArray alloc] init];
                                   NSArray *seperator = [responseBody componentsSeparatedByString:@"!@!@"];
                                   NSArray *allGroups = [seperator[0] componentsSeparatedByString:@"#$#$"];
                                   for (int a = 0; a < allGroups.count-1; a++) {
                                       NSArray *tempGroup = [allGroups[a] componentsSeparatedByString:@"*&^"];
                                       NSLog(@"GROUP: %@",tempGroup[0]);
                                       NSMutableArray *tempGroupMembers = [[NSMutableArray alloc] init];
                                       for (int b = 1; b < tempGroup.count-1; b++) {
                                           [tempGroupMembers addObject:tempGroup[b]];
                                           NSLog(@"%@",tempGroup[b]);
                                       }
                                       
                                       groupObject *tempGroupObject = [groupObject GroupWithName:tempGroup[0] andMembers:tempGroupMembers];
                                       [_groupList addObject:tempGroupObject];
                                       
                                   }
                                   NSArray *allFriends = [seperator[1] componentsSeparatedByString:@"***"];
                                   _friendList = [[NSMutableArray alloc] init];
                                   for (int a = 0; a < allFriends.count-1; a++) {
                                       NSArray *person = [allFriends[a] componentsSeparatedByString:@"@#$@"];
                                       friendObject *friend = [friendObject FriendWithName:person[1] andPhone:person[2]];
                                       //[friendNumbers addObject:person[2]];
                                       [_friendList addObject:friend];
                                   }
                                   [[NSUserDefaults standardUserDefaults] setObject:@" " forKey:@"updateFriends"];
                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   [friendsTable reloadData];
                               }
                               }
                           }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_groupList.count + _friendList.count == 0) {
        friendsTable.hidden = YES;
        searchBar.hidden = YES;
    }
    superScrollView.contentSize = CGSizeMake([References screenWidth], ((_groupList.count + _friendList.count)*44) + friendsTable.frame.origin.y+44);
    
    
    if (section == 0) {
        return _groupList.count;
    } else {
        return _friendList.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 21;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"General Cases";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *simpleTableIdentifier = @"sectionHeader";
    sectionHeader *cell = (sectionHeader *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    // Configure the cell title etc
    if (section == 0) {
        cell.title.text = @"Groups";
    } else {
        cell.title.text = @"Friends";
    }
    //[References createLine:cell xPos:cell.title.frame.origin.x yPos:cell.title.frame.origin.y+cell.title.frame.size.height];
    
    return cell;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"sendCell";
    sendCell *cell = (sendCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell.isSelected setBackgroundColor:[References colorFromHexString:@"#F97794"]];
    [References cornerRadius:cell.isSelected radius:cell.isSelected.frame.size.width/2];
    if (indexPath.section == 0) {
        groupObject *object = _groupList[indexPath.row];
        cell.isSelected.hidden = YES;
        cell.name.text = [object valueForKey:@"name"];
        cell.groupMembers = object;
        NSString *members = @"";
        NSMutableArray *memberArray = [object valueForKey:@"members"];
        for (int a = 0; a < memberArray.count; a++) {
            if (a == memberArray.count-1) {
                members = [members stringByAppendingString:[NSString stringWithFormat:@"%@",memberArray[a]]];
            } else {
                members = [members stringByAppendingString:[NSString stringWithFormat:@"%@, ",memberArray[a]]];
            }
        }
        //cell.groupMembers = object;
        //cell.fact.text = members;
        //UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        //[cell addGestureRecognizer:longPress];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [cell addGestureRecognizer:longPress];

    } else {
        
        friendObject *object = _friendList[indexPath.row];
        cell.name.text = [object valueForKey:@"name"];
        cell.phone.text = [object valueForKey:@"phone"];
        if ([object valueForKey:@"selected"] == [NSNumber numberWithBool:1]) {
            cell.isSelected.alpha = 0.7;
            
        } else {
            cell.isSelected.alpha = 0.1;
        }
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(removeFriendHold:)];
        [cell addGestureRecognizer:longPress];
    }
    if ([References screenHeight] > 568) {
        if (cell.isSelected.frame.origin.x < [References screenWidth]-100) {
        cell.isSelected.frame = CGRectMake(cell.isSelected.frame.origin.x+50, cell.isSelected.frame.origin.y, cell.isSelected.frame.size.width, cell.isSelected.frame.size.height);
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    sendCell *cell = (sendCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (cell.isSelected.alpha == 0.1) {
            cell.isSelected.alpha = 0.7;
        } else {
            cell.isSelected.alpha = 0.1;
        }
        groupObject *group = _groupList[indexPath.row];
        NSMutableArray *numbers = [group valueForKey:@"members"];
        for (int a = 0; a < numbers.count; a++) {
            for (int b = 0; b < _friendList.count; b++) {
                friendObject *object = _friendList[b];
                if ([[object valueForKey:@"phone"] isEqualToString:numbers[a]]) {
                    if ([object valueForKey:@"selected"] == [NSNumber numberWithBool:0]) {
                        [object setValue:[NSNumber numberWithBool:YES] forKey:@"selected"];
                        [recipients addObject:[object valueForKey:@"phone"]];
                        [recipientNames addObject:[object valueForKey:@"name"]];
                    } else {
                        [object setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
                        for (int a = 0 ; a < recipients.count; a++) {
                            if ([[object valueForKey:@"phone"] isEqualToString:recipients[a]]) {
                                [recipients removeObjectAtIndex:a];
                                [recipientNames removeObjectAtIndex:a];
                            }
                        }
                    }
                }
            }
        }
        [friendsTable reloadData];
    } else {
    friendObject *object = _friendList[indexPath.row];
    
    if ([object valueForKey:@"selected"] == [NSNumber numberWithBool:0]) {
        [object setValue:[NSNumber numberWithBool:YES] forKey:@"selected"];
        cell.isSelected.alpha = 0.7;
        [recipients addObject:[object valueForKey:@"phone"]];
        [recipientNames addObject:[object valueForKey:@"name"]];
        //[newGenerator selectionChanged];
    } else {
        [object setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
        cell.isSelected.alpha = 0.1;
        for (int a = 0 ; a < recipients.count; a++) {
            if ([[object valueForKey:@"phone"] isEqualToString:recipients[a]]) {
                [recipients removeObjectAtIndex:a];
                [recipientNames removeObjectAtIndex:a];
            }
        }
        //[newGenerator selectionChanged];
    }
    }
    if (recipients.count == 0) {
        people.text = @"INVITE SOME FRIENDS";
    } else {
    NSString *invited = @"WITH ";
    for (int a = 0; a < recipients.count; a++) {
        if (a == 0) {
            invited = [NSString stringWithFormat:@"%@ %@",invited,[recipientNames[a] uppercaseString]];
        } else {
            invited = [NSString stringWithFormat:@"%@, %@",invited,[recipientNames[a] uppercaseString]];
        }
        
    }
        people.text = invited;
    }
}

- (IBAction)sendButton:(id)sender {
    if (isSelectingDate == true) {
        [References fadeIn:newGroup];
        [References fadeIn:findFriend];
        [References fadeButtonText:sendButton text:@"Send"];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             datePicker.alpha = 0;
                             isSelectingDate = false;
                             toolbar.frame = CGRectMake(toolbar.frame.origin.x, toolbar.frame.origin.y+162, toolbar.frame.size.width, toolbar.frame.size.height);
                             [self.view bringSubviewToFront:toolbar];
                             blurItAll.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             [datePicker removeFromSuperview];
                             [blurItAll removeFromSuperview];
                         }];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:datePicker.date.timeIntervalSince1970];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMM d h:mm a"];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        [segmentControl setTitle:formattedDateString forSegmentAtIndex:2];
    } else {
    [self postActivity];
    }
}

- (IBAction)makeGroup:(id)sender {
    newGroupView *viewController = [[UIStoryboard storyboardWithName:@"iPhone4" bundle:nil] instantiateViewControllerWithIdentifier:@"newGroupView"];
    viewController.friendList = _friendList;
    viewController.isNewGroup = [NSNumber numberWithBool:YES];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)cancelButton:(id)sender {
    if (isSelectingDate == true) {
        [References fadeIn:newGroup];
        [References fadeIn:findFriend];
        [References fadeButtonText:sendButton text:@"Send"];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             datePicker.alpha = 0;
                             isSelectingDate = false;
                             toolbar.frame = CGRectMake(toolbar.frame.origin.x, toolbar.frame.origin.y+162, toolbar.frame.size.width, toolbar.frame.size.height);
                             [self.view bringSubviewToFront:toolbar];
                             blurItAll.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             [datePicker removeFromSuperview];
                             [blurItAll removeFromSuperview];
                         }];
        [segmentControl setSelectedSegmentIndex:1];
    } else {
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)findFriend:(id)sender {
    addFriendView *viewController = [[UIStoryboard storyboardWithName:@"iPhone4" bundle:nil] instantiateViewControllerWithIdentifier:@"addFriendView"];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)segmentControl:(id)sender {
        NSString *selected = [segmentControl titleForSegmentAtIndex:segmentControl.selectedSegmentIndex];
        if ([selected isEqualToString:@"Now"]) {
            timeSeconds = @"0";
            [segmentControl setSelectedSegmentIndex:0];
        } else if ([selected isEqualToString:@"Soon"]) {
            timeSeconds = @"1";
            [segmentControl setSelectedSegmentIndex:1];
        } else {
            blurItAll = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], [References screenHeight])];
            blurItAll.alpha = 0;
            [References blurView:blurItAll];
            [self.view addSubview:blurItAll];
            [self.view bringSubviewToFront:blurItAll];
            isSelectingDate = true;
            datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(0, [References screenHeight]-162,[References screenWidth], 162)];
            datePicker.alpha = 0;
            datePicker.datePickerMode=UIDatePickerModeDateAndTime;
            datePicker.date=[NSDate date];
            [datePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:datePicker];
            [self.view bringSubviewToFront:datePicker];
            [References fadeOut:newGroup];
            [References fadeOut:findFriend];
            [References fadeButtonText:sendButton text:@"Next"];
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                               
                                 toolbar.frame = CGRectMake(toolbar.frame.origin.x, toolbar.frame.origin.y-162, toolbar.frame.size.width, toolbar.frame.size.height);
                                 [self.view bringSubviewToFront:toolbar];
                                 blurItAll.alpha = 1;
                                 datePicker.alpha = 1;
                             }
                             completion:^(BOOL finished){
                             }];
            
            
            [segmentControl setSelectedSegmentIndex:2];
            
        }
    }


-(void)LabelTitle:(id)sender
{
    timeSeconds = [NSString stringWithFormat:@"%f",datePicker.date.timeIntervalSince1970];
}

-(bool)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length >1) {
        bool found = NO;
        for (int a = 0; a < _friendList.count; a++) {
            friendObject *person = _friendList[a];
            if ([[[person valueForKey:@"name"] lowercaseString] containsString:[textField.text lowercaseString]]) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:a inSection:1];
                [friendsTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
                found = YES;
            }
        }
        if (found == NO) {
            [References toastMessage:@"Sorry, something's not right" andView:self];
        }
    }
    
    [textField resignFirstResponder];
    return YES;
}

-(void)postActivity{
        NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/postActivity"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        // NSError *actualerror = [[NSError alloc] init];
        // Parameters
        NSDictionary *tmp = [[NSDictionary alloc] init];
        tmp = @{
                @"time"     : timeSeconds,
                @"pending"     : recipients,
                @"creator"     : [[NSUserDefaults standardUserDefaults] objectForKey:@"name"],
                @"message"  : [NSString stringWithFormat:@"%@ wants to know if you're down to %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"name"],activityName.text],
                @"phone"    : [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"],
                @"actID"       : [References randomStringWithLength:16],
                @"name"         : activityName.text
                };
        
        NSError *error;
        NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        [request setHTTPBody:postdata];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data,
                                                   NSError *error) {
                                   if (error) {
                                       // Returned Error
                                       NSLog(@"Unknown Error Occured");
                                   } else {
                                       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"reloadActivites"];
                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }
                               }];

}

- (void)remo:(UITapGestureRecognizer *)tapGesture {
    if (alertIsShowing == NO) {
        sendCell *cell = (sendCell*)tapGesture.view;
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:cell.name.text message:@"from here you can edit or delete this group" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            alertIsShowing = NO;
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Delete %@",cell.name.text] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            alertIsShowing = NO;
            [self deleteGroup:cell.name.text];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Modify %@",cell.name.text] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // OK button tapped.
            alertIsShowing = NO;
            newGroupView *viewController = [[UIStoryboard storyboardWithName:@"iPhone4" bundle:nil] instantiateViewControllerWithIdentifier:@"newGroupView"];
            viewController.friendList = _friendList;
            viewController.group = cell.groupMembers;
            viewController.isNewGroup = [NSNumber numberWithBool:NO];
            [self presentViewController:viewController animated:YES completion:nil];
        }]];
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
        alertIsShowing = YES;
    }
    
}

- (void)removeFriendHold:(UITapGestureRecognizer *)tapGesture {
    if (alertIsShowing == NO) {
        sendCell *cell = (sendCell*)tapGesture.view;
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:cell.name.text message:@"from here you can edit or delete this friend" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            alertIsShowing = NO;
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Delete %@",cell.name.text] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            sendCell *cell = (sendCell*)tapGesture.view;
            NSString *phoneToDelete = cell.phone.text;
            NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/removeFriend"];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            request.HTTPMethod = @"POST";
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            // NSError *actualerror = [[NSError alloc] init];
            // Parameters
            NSDictionary *tmp = [[NSDictionary alloc] init];
            tmp = @{
                    @"phone"     : [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"],
                    @"removePhone"    : phoneToDelete
                    };
            
            NSError *error;
            NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
            [request setHTTPBody:postdata];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response,
                                                       NSData *data,
                                                       NSError *error) {
                                       if (error) {
                                           // Returned Error
                                           NSLog(@"Unknown Error Occured");
                                       } else {
                                           NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                           if ([responseBody isEqualToString:@"Loser"]) {
                                               friendsTable.hidden = TRUE;
                                               searchBar.hidden = TRUE;
                                           } else {
                                               
                                               friendsTable.hidden = false;
                                               searchBar.hidden = false;
                                               NSLog(@"%@",responseBody);
                                               //NSLog(@"detected change, refreshing friends and groups");
                                               [_groupList removeAllObjects];
                                               [_friendList removeAllObjects];
                                               _groupList = [[NSMutableArray alloc] init];
                                               NSArray *seperator = [responseBody componentsSeparatedByString:@"!@!@"];
                                               NSArray *allGroups = [seperator[0] componentsSeparatedByString:@"#$#$"];
                                               for (int a = 0; a < allGroups.count-1; a++) {
                                                   NSArray *tempGroup = [allGroups[a] componentsSeparatedByString:@"*&^"];
                                                   NSLog(@"GROUP: %@",tempGroup[0]);
                                                   NSMutableArray *tempGroupMembers = [[NSMutableArray alloc] init];
                                                   for (int b = 1; b < tempGroup.count-1; b++) {
                                                       [tempGroupMembers addObject:tempGroup[b]];
                                                       NSLog(@"%@",tempGroup[b]);
                                                   }
                                                   
                                                   groupObject *tempGroupObject = [groupObject GroupWithName:tempGroup[0] andMembers:tempGroupMembers];
                                                   [_groupList addObject:tempGroupObject];
                                                   
                                               }
                                               NSArray *allFriends = [seperator[1] componentsSeparatedByString:@"***"];
                                               _friendList = [[NSMutableArray alloc] init];
                                               for (int a = 0; a < allFriends.count-1; a++) {
                                                   NSArray *person = [allFriends[a] componentsSeparatedByString:@"@#$@"];
                                                   friendObject *friend = [friendObject FriendWithName:person[1] andPhone:person[2]];
                                                   //[friendNumbers addObject:person[2]];
                                                   [_friendList addObject:friend];
                                               }
                                               [[NSUserDefaults standardUserDefaults] setObject:@" " forKey:@"updateFriends"];
                                               [[NSUserDefaults standardUserDefaults] synchronize];
                                               [friendsTable reloadData];
                                           }
                                       }
                                   }];

                    }]];
        
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
        alertIsShowing = YES;
    }
    
}


- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (alertIsShowing == NO) {
        sendCell *cell = (sendCell*)tapGesture.view;
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:cell.name.text message:@"from here you can edit or delete this group" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            alertIsShowing = NO;
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Delete %@",cell.name.text] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            alertIsShowing = NO;
            [self deleteGroup:cell.name.text];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Modify %@",cell.name.text] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // OK button tapped.
            alertIsShowing = NO;
            newGroupView *viewController = [[UIStoryboard storyboardWithName:@"iPhone4" bundle:nil] instantiateViewControllerWithIdentifier:@"newGroupView"];
            viewController.friendList = _friendList;
            viewController.group = cell.groupMembers;
            viewController.isNewGroup = [NSNumber numberWithBool:NO];
            [self presentViewController:viewController animated:YES completion:nil];
        }]];
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
        alertIsShowing = YES;
    }
    
}

-(void)deleteGroup:(NSString*)groupName{
    NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/deleteGroup"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"phone"     : [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"],
            @"groupName"    : groupName
            };
    
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postdata];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (error) {
                                   // Returned Error
                                   NSLog(@"Unknown Error Occured");
                               } else {
                                   NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"%@",responseBody);
                                   //NSLog(@"detected change, refreshing friends and groups");
                                   [_groupList removeAllObjects];
                                   [_friendList removeAllObjects];
                                   _groupList = [[NSMutableArray alloc] init];
                                   NSArray *seperator = [responseBody componentsSeparatedByString:@"!@!@"];
                                   NSArray *allGroups = [seperator[0] componentsSeparatedByString:@"#$#$"];
                                   for (int a = 0; a < allGroups.count-1; a++) {
                                       NSArray *tempGroup = [allGroups[a] componentsSeparatedByString:@"*&^"];
                                       NSLog(@"GROUP: %@",tempGroup[0]);
                                       NSMutableArray *tempGroupMembers = [[NSMutableArray alloc] init];
                                       for (int b = 1; b < tempGroup.count-1; b++) {
                                           [tempGroupMembers addObject:tempGroup[b]];
                                           NSLog(@"%@",tempGroup[b]);
                                       }
                                       
                                       groupObject *tempGroupObject = [groupObject GroupWithName:tempGroup[0] andMembers:tempGroupMembers];
                                       [_groupList addObject:tempGroupObject];
                                       
                                   }
                                   NSArray *allFriends = [seperator[1] componentsSeparatedByString:@"***"];
                                   _friendList = [[NSMutableArray alloc] init];
                                   for (int a = 0; a < allFriends.count-1; a++) {
                                       NSArray *person = [allFriends[a] componentsSeparatedByString:@"@#$@"];
                                       friendObject *friend = [friendObject FriendWithName:person[1] andPhone:person[2]];
                                       //[friendNumbers addObject:person[2]];
                                       [_friendList addObject:friend];
                                   }
                                   [[NSUserDefaults standardUserDefaults] setObject:@" " forKey:@"updateFriends"];
                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   [friendsTable reloadData];
                               }
                           }];
    
}

@end
