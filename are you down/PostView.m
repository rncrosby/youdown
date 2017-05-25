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
    friends = [[NSMutableArray alloc] initWithCapacity:4];
    friendNames = [[NSMutableArray alloc] initWithObjects:@"person1",@"person2",@"person3",@"person4", nil];
    groups = [[NSMutableArray alloc] initWithCapacity:3];
    for (int a = 0; a < 4; a++) {
        friendObject *object = [friendObject FriendWithName:friendNames[a] andFact:@"usually runs with you"];
        if (a < 3) {
            NSMutableArray *temp;
            groupObject *gObject;
            if (a == 0) {
                temp = [[NSMutableArray alloc] initWithObjects:@"person1",@"person2",@"person3",@"person4", nil];
                gObject = [groupObject GroupWithName:@"running" andMembers:temp];
            } else if (a == 1) {
                temp = [[NSMutableArray alloc] initWithObjects:@"person3",@"person4", nil];
                gObject = [groupObject GroupWithName:@"studying" andMembers:temp];
            } else if (a == 2) {
                temp = [[NSMutableArray alloc] initWithObjects:@"person1",@"person2", nil];
                gObject = [groupObject GroupWithName:@"basketball" andMembers:temp];
            }
            
            [groups addObject:gObject];
        }
        [friends addObject:object];
    }
    [References cornerRadius:createPostCard radius:10.0f];
    [References cornerRadius:inviteFriendsTitleCard radius:10.0f];
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
    [super viewDidLoad];
    createPostScroll.contentSize = CGSizeMake([References screenWidth]*3, [References screenHeight]);
    createPostScroll.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]);
    createPostScroll.contentOffset = CGPointMake([References screenWidth], 0);
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
    [textField resignFirstResponder];
    [textField setPlaceholder:@"hoop"];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [textField setPlaceholder:@""];
    return YES;
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
        return 3;
    } else if (tableView.tag == 25) {
        inboxscrollview.contentSize = CGSizeMake([References screenWidth], 107 + (5*124)+5);
        inboxtable.frame = CGRectMake(inboxtable.frame.origin.x, inboxtable.frame.origin.y, inboxtable.frame.size.width, 5*124);
        return 5;
    } else {
        if (section == 0) {
            return groups.count;
        } else {
            return [friends count];
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
        [References cornerRadius:cell.card radius:10.0f];
        cell.backgroundColor = [UIColor clearColor];
        cell.activityName.text = @"ball out";
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
        cell.fact.text = [object valueForKey:@"fact"];
            
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

// Our custom method
- (void)customAction:(id)sender {
    NSLog(@"Custom Action");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 50) {
        return 559;
    }
    else if (tableView.tag == 25) {
        return 124;
    } else {
            return 65;
    }
}


@end
