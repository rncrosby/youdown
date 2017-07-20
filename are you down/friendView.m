//
//  friendView.m
//  are you down
//
//  Created by Robert Crosby on 6/27/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "friendView.h"
#import "References.h"
#import "sendCell.h"

@interface friendView () {
    bool alertIsShowing;
    __weak IBOutlet UITableView *friendsTable;
    __weak IBOutlet UILabel *titleBar;
    __weak IBOutlet UIScrollView *superScrollView;
    __weak IBOutlet UIButton *close;
    __weak IBOutlet UILabel *statusBar;
    bool statusBarBlur;
}
- (IBAction)addFriend:(id)sender;
- (IBAction)addGroup:(id)sender;
- (IBAction)close:(id)sender;

@end

@implementation friendView

- (void)viewDidLoad {
    statusBarBlur = NO;
    [References blurView:statusBar];
    statusBar.alpha = 0;
    statusBar.frame =CGRectMake(0, 0, [References screenWidth] , 20);
    if ([References screenHeight] > 568) {
    
        close.frame = CGRectMake(close.frame.origin.x+50, close.frame.origin.y, close.frame.size.width, close.frame.size.height);
        friendsTable.frame = CGRectMake(friendsTable.frame.origin.x, friendsTable.frame.origin.y, [References screenWidth], [References screenHeight]-friendsTable.frame.origin.y);
        if ([References screenHeight] > 667) {
            close.frame = CGRectMake(close.frame.origin.x+30, close.frame.origin.y, close.frame.size.width, close.frame.size.height);
            
        }
    }
    [References tintUIButton:close color:[UIColor darkGrayColor]];
    alertIsShowing = NO;
    [References createLine:superScrollView xPos:titleBar.frame.origin.x yPos:titleBar.frame.origin.y+titleBar.frame.size.height+4];
    [self getFriends];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:@"updateFriends"];
    if (text.length > 5) {
        [self getFriends];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"updateFriends"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addFriend:(id)sender {
    addFriendView *viewController = [[UIStoryboard storyboardWithName:@"iPhone4" bundle:nil] instantiateViewControllerWithIdentifier:@"addFriendView"];
    viewController.justAddFriend = [NSNumber numberWithBool:YES];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)addGroup:(id)sender {
    newGroupView *viewController = [[UIStoryboard storyboardWithName:@"iPhone4" bundle:nil] instantiateViewControllerWithIdentifier:@"newGroupView"];
    viewController.friendList = _friendList;
    viewController.isNewGroup = [NSNumber numberWithBool:YES];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
                                   } else {
                                       
                                       friendsTable.hidden = false;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_groupList.count + _friendList.count == 0) {
        friendsTable.hidden = YES;
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
                                           } else {
                                               
                                               friendsTable.hidden = false;
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        if (statusBarBlur == NO) {
            statusBarBlur = YES;
            [References fadeIn:statusBar];
        }
    } else if (scrollView.contentOffset.y <= 0) {
        if (statusBarBlur == YES) {
            statusBarBlur = NO;
            [References fadeOut:statusBar];
        }
    }
}



@end
