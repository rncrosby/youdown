//
//  PostView.m
//  are you down
//
//  Created by Robert Crosby on 5/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "PostView.h"

@interface PostView ()

@end

@implementation PostView



- (void)viewDidLoad {
    friends = [[NSMutableArray alloc] init];
     arrayOfInvites = [[NSMutableArray alloc] init];
    alertIsShowing = NO;
    groupSelected = @"";
    keepScrollingCreatePost = YES;
    keepScrollingInvite = YES;
    // set view content sizes
    createPostScroll.contentSize = CGSizeMake([References screenWidth], [References screenHeight]);
    inviteFriendsScroll.contentSize = CGSizeMake([References screenWidth], [References screenHeight]);
    sendActivityScroll.contentSize = CGSizeMake([References screenWidth], [References screenHeight]);
    // timer to animate text field
    animateText = YES;
    createPostTextTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                             target:self
                                                           selector:@selector(createPostTextAnimate)
                                                           userInfo:nil
                                                            repeats:YES];
    
    [References cornerRadius:createPostCard radius:10.0f];
    [References cornerRadius:inviteFriendsTitleCard radius:10.0f];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        // Has camera
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        session.sessionPreset = AVCaptureSessionPresetHigh;
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        [session addInput:input];
        
        AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        newCaptureVideoPreviewLayer.frame = self.view.bounds;
        UIView *blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], [References screenHeight])];
        [References blurView:blurView];
        [self.view insertSubview:blurView atIndex:0];
        [self.view.layer insertSublayer:newCaptureVideoPreviewLayer atIndex:0];
        [session startRunning];
    }
        [super viewDidLoad];

    createPostScroll.contentSize = CGSizeMake([References screenWidth]*3, [References screenHeight]);
    createPostScroll.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]);
    createPostScroll.contentOffset = CGPointMake([References screenWidth], 0);
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    [self getActivities];
    [self getInvites];
    [self getFriends];
}

- (void)viewDidAppear:(BOOL)animated {
    [inviteFriendsTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)createPostTextAnimate {
    if (animateText == NO) {
        nil;
    } else {
        if ([createPostText.placeholder containsString:@"|"] ) {
            [createPostText setPlaceholder:[createPostText.placeholder stringByReplacingOccurrencesOfString:@"|" withString:@""]];
        } else {
            [createPostText setPlaceholder:[createPostText.placeholder stringByAppendingString:@"|"]];
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 10) {
        [self sendMessage:currentActivityID];
        [textField resignFirstResponder];
       
    } else {
        [textField resignFirstResponder];
        [textField setPlaceholder:@"hoop"];
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 10) {
        nil;
         } else {
        [textField setPlaceholder:@""];
    }
    return YES;
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    keyboardHeight = [self.view convertRect:rawFrame fromView:nil];
    [References moveUp:activityMessageField yChange:keyboardHeight.size.height];
    [References moveUp:upcomingtable yChange:keyboardHeight.size.height];
    [References moveUp:upcomingTitle yChange:keyboardHeight.size.height];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (keepScrollingCreatePost == YES) {
        if(createPostScroll.contentOffset.y < -100) {
            //keepScrollingCreatePost = NO;
            //keepScrollingInvite = YES;
            //[References moveUp:createPostScroll yChange:[References screenHeight]];
            //[References moveUp:inviteFriendsScroll yChange:[References screenHeight]];
            //inviteFriendsActivity.text = createPostText.text;
            return ;
        }

    }


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 50) {
        return activities.count;
    } else if (tableView.tag == 25) {
        inboxscrollview.contentSize = CGSizeMake([References screenWidth], 107 + (5*124)+5);
        inboxtable.frame = CGRectMake(inboxtable.frame.origin.x, inboxtable.frame.origin.y, inboxtable.frame.size.width, 5*124);
        return arrayOfInvites.count;
    } else {
        if (section == 0) {
            //return groups.count;
            return 0;
        } else {
            return friends.count;
        }

    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 50) {
        return 1;
    } else if (tableView.tag == 25) {
        return 1;
    } else {
            return 2;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 50) {
        static NSString *simpleTableIdentifier = @"UpcomingTableCell";
        
        UpcomingTableCell *cell = (UpcomingTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UpcomingTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        currentActivity = indexPath;
        currentmessagePosition = 10;
        [References cornerRadius:cell.card radius:10.0f];
        [cell setBackgroundColor:[UIColor clearColor]];
        ActivityObject *object = activities[indexPath.row];
        cell.activityName.text = [object valueForKey:@"name"];
        currentActivityID = [object valueForKey:@"actID"];
        cell.guestListLabel.text = [NSString stringWithFormat:@"you told %@ you're down to",[object valueForKey:@"creator"]];
        NSMutableArray *messages = [object valueForKey:@"messages"];
        for (int a = 0; a < messages.count-1; a++) {
            NSArray *messageData = [messages[a] componentsSeparatedByString:@"^*&"];
            MessageObject *message;
            if ([messageData[0] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]]) {
                 message = [MessageObject MessageWithText:messageData[1] andAmSender:[NSNumber numberWithBool:YES]];
                [self createMessage:YES withText:[message valueForKey:@"text"] inScrollView:cell.chatView :cell];
            } else {
                message = [MessageObject MessageWithText:messageData[1] andAmSender:[NSNumber numberWithBool:NO]];
                [self createMessage:NO withText:[message valueForKey:@"text"] inScrollView:cell.chatView :cell];
            }
        }
        //[cell.guestListView  setTextContainerInset:UIEdgeInsetsMake(0, 16, 0, 0)];
        
        NSString *guestList = @"with ";
        NSArray *tempGuestList = [object valueForKey:@"guests"];
        for (int a = 0; a < tempGuestList.count-1; a++) {
            guestList = [NSString stringWithFormat:@"%@ %@, ",guestList,tempGuestList[a]];
        }
        return cell;

    } else if (tableView.tag == 25 ) {
        static NSString *simpleTableIdentifier = @"InboxTableCell";
        
        InboxTableCell *cell = (InboxTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InboxTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [References cornerRadius:cell.card radius:10.0f];
        [References cornerRadius:cell.yeah radius:10.0f];
        [References cornerRadius:cell.no radius:10.0f];
        SlimActivityObject *object = [arrayOfInvites objectAtIndex:indexPath.row];
        cell.name.text = [object valueForKey:@"name"];
        cell.who.text = [object valueForKey:@"creator"];
        cell.yeah.tag = indexPath.row;
        [cell.yeah addTarget:self action:@selector(willAttend:) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundColor = [UIColor clearColor];
            return cell;
    } else {
    static NSString *simpleTableIdentifier = @"PostFriendsTableCell";
    
    PostFriendsTableCell *cell = (PostFriendsTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostFriendsTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    [References cornerRadius:cell.isSelected radius:cell.isSelected.frame.size.width/2];
    if (indexPath.section == 0) {
        groupObject *object = groups[indexPath.row];
        if ([object valueForKey:@"selected"] == [NSNumber numberWithBool:YES]) {
            cell.isSelected.alpha = 0.7;
        } else {
            cell.isSelected.alpha = 0.1;
        }

        cell.name.text = [object valueForKey:@"name"];
        NSString *members = @"";
        NSMutableArray *memberArray = [object valueForKey:@"members"];
        for (int a = 0; a < memberArray.count; a++) {
            if (a == memberArray.count-1) {
                members = [members stringByAppendingString:[NSString stringWithFormat:@"%@",memberArray[a]]];
            } else {
            members = [members stringByAppendingString:[NSString stringWithFormat:@"%@, ",memberArray[a]]];
            }
        }
        cell.groupMembers = object;
        cell.fact.text = members;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [cell addGestureRecognizer:longPress];
        
        } else {
            
        friendObject *object = friends[indexPath.row];
        cell.name.text = [object valueForKey:@"name"];
        cell.fact.text = [object valueForKey:@"phone"];
            
        if ([object valueForKey:@"selected"] == [NSNumber numberWithBool:1]) {
            cell.isSelected.alpha = 0.7;
            
        } else {
            cell.isSelected.alpha = 0.1;
        }
    }
    return cell;
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (alertIsShowing == NO) {
        PostFriendsTableCell *cell = (PostFriendsTableCell*)tapGesture.view;
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:cell.name.text message:@"from here you can edit or delete this group" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            alertIsShowing = NO;
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Delete %@",cell.name.text] style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            alertIsShowing = NO;
            // Distructive button tapped.
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Modify %@",cell.name.text] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // OK button tapped.
            alertIsShowing = NO;
            EditGroup *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditGroup"];
            viewController.friendList = friends;
            viewController.group = cell.groupMembers;
            viewController.groupName = cell.name.text;
            [self presentViewController:viewController animated:YES completion:nil];
        }]];
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
        alertIsShowing = YES;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UINotificationFeedbackGenerator *newGenerator = [[UINotificationFeedbackGenerator alloc] init];
        [newGenerator prepare];
        [newGenerator notificationOccurred:UINotificationFeedbackTypeSuccess];
        groupObject *group = groups[indexPath.row];
        if ([group valueForKey:@"selected"] == [NSNumber numberWithBool:0]) {
            [group setValue:[NSNumber numberWithBool:YES] forKey:@"selected"];
        } else {
            [group setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
        }
        NSMutableArray *arrayOfMembers = [group valueForKey:@"members"];
        for (int a = 0; a < arrayOfMembers.count; a++) {
            for(int b = 0; b < friendNames.count; b++) {
                if (arrayOfMembers[a] == friendNames[b]) {
                    friendObject *friend = friends[b];
                    if ([friend valueForKey:@"selected"] == [NSNumber numberWithBool:YES]) {
                                            [friend setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
                    } else {
                                            [friend setValue:[NSNumber numberWithBool:YES] forKey:@"selected"];
                    }
                }
            }
        }
        [inviteFriendsTable reloadData];
    } else {
        UISelectionFeedbackGenerator *newGenerator = [[UISelectionFeedbackGenerator alloc] init];
        [newGenerator prepare];
    PostFriendsTableCell *cell = (PostFriendsTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    friendObject *object = friends[indexPath.row];
        
    if ([object valueForKey:@"selected"] == [NSNumber numberWithBool:0]) {
        [object setValue:[NSNumber numberWithBool:YES] forKey:@"selected"];
        cell.isSelected.alpha = 0.7;
        [newGenerator selectionChanged];
    } else {
        [object setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
        cell.isSelected.alpha = 0.1;
        [newGenerator selectionChanged];
    }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 50) {
        return 582;
    }
    else if (tableView.tag == 25) {
        return 124;
    } else {
            return 65;
    }
}

-(void)createMessage:(BOOL)amSender withText:(NSString*)message inScrollView:(UIScrollView*)scrollView :(UIView*)parent{
    if (amSender == YES) {
        message = [message stringByAppendingString:@"  "];
    }
    int messageLength = (int)message.length;
    int bubbleWidth = 20;
    for (int a = 0; a < messageLength; a++) {
        bubbleWidth+=10;
    }
    bubbleWidth = bubbleWidth - (bubbleWidth*.25);
    if (bubbleWidth > scrollView.frame.size.width*0.8) {
        bubbleWidth = scrollView.frame.size.width*0.8;
    }
    int messageDivisor = messageLength/36;
    int numberofLines = messageDivisor+1;
    int bubbleHeight = 30;
    if (numberofLines > 1) {
        bubbleHeight = bubbleHeight + (numberofLines*8);
        NSLog(@"%i",bubbleHeight);
    }
    int xPosition;
    
    UIColor *bubbleColor,*textColor;
    if (amSender == YES) {
        xPosition = scrollView.frame.size.width - bubbleWidth - 8;
        bubbleColor = [UIColor paperColorLightBlueA400];
        textColor = [UIColor whiteColor];
    } else {
        xPosition = 8;
        bubbleColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        textColor = [UIColor darkTextColor];
    }
    UILabel *messageBubble = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, currentmessagePosition, bubbleWidth, bubbleHeight)];
    [messageBubble setBackgroundColor:bubbleColor];
    [References cornerRadius:messageBubble radius:10.0f];
    [messageBubble setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
    [messageBubble setTextColor:textColor];
    messageBubble.alpha = 1;
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    if (amSender == YES) {
        style.alignment = NSTextAlignmentRight;
    } else {
        style.alignment = NSTextAlignmentLeft;
    }
    
    style.firstLineHeadIndent = 10.0f;
    style.headIndent = 10.0f;
    style.tailIndent = -10.0f;
    
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:message attributes:@{ NSParagraphStyleAttributeName : style}];
    messageBubble.numberOfLines = numberofLines;
    messageBubble.attributedText = attrText;
    [scrollView addSubview:messageBubble];
    [parent bringSubviewToFront:scrollView];
    currentmessagePosition = currentmessagePosition + 5 + messageBubble.frame.size.height;
    numberOfMessages++;
    if (scrollView.contentSize.height < currentmessagePosition) {
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.contentSize.height+bubbleHeight+5);
    }
}

-(void)sendMessageForActivity {
    ActivityObject *activity = activities[currentActivity.row];
    NSMutableArray *messages = [activity valueForKey:@"messages"];
    MessageObject *message = [MessageObject MessageWithText:activityMessageField.text andAmSender:[NSNumber numberWithBool:YES]];
    [messages addObject:message];
    [upcomingtable reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:currentActivity, nil] withRowAnimation:UITableViewRowAnimationFade];
    [References moveDown:activityMessageField yChange:keyboardHeight.size.height];
    [References moveDown:upcomingtable yChange:keyboardHeight.size.height];
    [References moveDown:upcomingTitle yChange:keyboardHeight.size.height];
    [activityMessageField setText:@""];
}

-(void)postActivity:(NSArray*)pending andID:(NSString*)actID{
    if (createPostText.text.length < 1) {
        [References toastMessage:@"you forgot to tell your friends what it is they could be down for" andView:self];
    } else {
    NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:5000/postActivity"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"pending"     : pending,
            @"creator"     : [[NSUserDefaults standardUserDefaults] objectForKey:@"username"],
            @"phone"    : [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"],
            @"actID"       : actID,
            @"name"         : createPostText.text
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
                                   //NSMutableDictionary *activity = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                                   NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"%@",responseBody);
                               }
                           }];
    }
}

- (IBAction)sendActivityButton:(id)sender {
    phoneNumberInvited = [[NSMutableArray alloc] init];
    for (int a = 0; a < friends.count; a++) {
        if ([friends[a] valueForKey:@"selected"] == [NSNumber numberWithBool:YES]) {
            [phoneNumberInvited addObject:[friends[a] valueForKey:@"phone"]];
        }
    }
    NSString *activity =[References randomStringWithLength:16];
    NSLog(@"%@",activity);
    [self postActivity:phoneNumberInvited andID:activity];
}

-(void)sendMessage:(NSString*)actID{
    NSString *message = [NSString stringWithFormat:@"%@^*&%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"],activityMessageField.text];
    NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:5000/sendMessage"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"actID"     : actID,
            @"message"     : message,
            @"phone"    : [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]
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
                                   NSArray *tempArrayActivities = [responseBody componentsSeparatedByString:@"***"];
                                   activities = [[NSMutableArray alloc] init];
                                   for (int a = 1; a < tempArrayActivities.count-1; a++) {
                                       NSArray *activityArray = [tempArrayActivities[a] componentsSeparatedByString:@"!@#"];
                                       NSMutableArray *messages = [[NSMutableArray alloc] initWithArray:[activityArray[4] componentsSeparatedByString:@"&*^"]];
                                       NSMutableArray *pending = [[NSMutableArray alloc] initWithArray:[activityArray[5] componentsSeparatedByString:@"$#$"]];
                                       NSArray *attending = [activityArray[6] componentsSeparatedByString:@"@~!"];
                                       ActivityObject *activity = [ActivityObject ActivityWithName:activityArray[2] andGuests:pending andMessages:messages andAttending:[[NSMutableArray alloc] initWithArray:attending] andID:activityArray[1]];
                                       [activities addObject:activity];
                                   }
                                   [upcomingtable reloadData];
                               }
                           }];
}

-(void)willAttend:(id)sender {
    UIButton *button = (UIButton*)sender;
    SlimActivityObject *object = [arrayOfInvites objectAtIndex:button.tag];
    [self amAttending:[object valueForKey:@"actID"]];
}

-(void)amAttending:(NSString*)actID{
    NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:5000/amAttending"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"actID"     : actID,
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
                                   if (responseBody.length < 13) {
                                       [arrayOfInvites removeAllObjects];
                                       [inboxtable reloadData];
                                   } else {
                                   NSLog(@"%@",responseBody);
                                   NSArray *tempArrayOfInvites = [responseBody componentsSeparatedByString:@"***"];
                                   for (int a = 0; a < tempArrayOfInvites.count-1; a++) {
                                       NSArray *tempInvite = [tempArrayOfInvites[a] componentsSeparatedByString:@"!@#"];
                                       SlimActivityObject *object = [SlimActivityObject SlimActivityWithName:tempInvite[2] andCreator:tempInvite[3] andID:tempInvite[1]];
                                       [arrayOfInvites addObject:object];
                                   }
                                   [inboxtable reloadData];
                                   }
                               }
                           }];
}


-(void)getInvites{
    NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:5000/getMyInvites"];
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
                                   NSLog(@"%@",responseBody);
                                   NSArray *tempArrayOfInvites = [responseBody componentsSeparatedByString:@"***"];
                                   for (int a = 0; a < tempArrayOfInvites.count-1; a++) {
                                       NSArray *tempInvite = [tempArrayOfInvites[a] componentsSeparatedByString:@"!@#"];
                                       SlimActivityObject *object = [SlimActivityObject SlimActivityWithName:tempInvite[2] andCreator:tempInvite[3] andID:tempInvite[1]];
                                       [arrayOfInvites addObject:object];
                                   }
                                   [inboxtable reloadData];
                               }
                           }];
}

-(void)getActivities{
    NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:5000/getMyActivities"];
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
                                   NSArray *tempArrayActivities = [responseBody componentsSeparatedByString:@"***"];
                                   activities = [[NSMutableArray alloc] init];
                                   for (int a = 1; a < tempArrayActivities.count-1; a++) {
                                      NSArray *activityArray = [tempArrayActivities[a] componentsSeparatedByString:@"!@#"];
                                       NSMutableArray *messages = [[NSMutableArray alloc] initWithArray:[activityArray[4] componentsSeparatedByString:@"&*^"]];
                                       NSMutableArray *pending = [[NSMutableArray alloc] initWithArray:[activityArray[5] componentsSeparatedByString:@"$#$"]];
                                       NSArray *attending = [activityArray[6] componentsSeparatedByString:@"@~!"];
                                       ActivityObject *activity = [ActivityObject ActivityWithName:activityArray[2] andGuests:pending andMessages:messages andAttending:[[NSMutableArray alloc] initWithArray:attending] andID:activityArray[1]];
                                       [activities addObject:activity];
                                   }
                                   [upcomingtable reloadData];
                               }
                           }];
}

-(void)getFriends{
    NSURL *url = [NSURL URLWithString:@"http://0.0.0.0:5000/getMyFriends"];
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
                                   NSLog(@"%@",responseBody);
                                   
                                   NSArray *tempArrayActivities = [responseBody componentsSeparatedByString:@"***"];
                                   friends = [[NSMutableArray alloc] init];
                                   for (int a = 0; a < tempArrayActivities.count-1; a++) {
                                       NSArray *person = [tempArrayActivities[a] componentsSeparatedByString:@"@#$@"];
                                       NSLog(@"person: %@ phone: %@",person[1],person[2]);
                                       friendObject *friend = [friendObject FriendWithName:person[1] andPhone:person[2]];
                                       [friends addObject:friend];
                                   }
                                   
                                   [inviteFriendsTable reloadData];
                               }
                           }];

}

@end
