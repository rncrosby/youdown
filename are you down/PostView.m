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
    // shadow on the cards
    //[References cardshadow:createPostCard];
    //[References cardshadow:inviteFriendsFriendsCard];
    //[References cardshadow:inviteFriendsTitleCard];
    /*
    int image = arc4random() % 3;
    [backgroundImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",image]]];
    UILabel *blurBack = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [References screenWidth], [References screenHeight])];
    [References blurView:blurBack];
    blurBack.text = @"";
    [self.view addSubview:blurBack];
    [self.view sendSubviewToBack:blurBack];
    [self.view sendSubviewToBack:backgroundImage];
    [References blurView:createPostCard];
    [References cornerRadius:createPostCard radius:12.0f];
    [References blurView:inviteFriendsFriendsCard];
    [References cornerRadius:inviteFriendsFriendsCard radius:12.0f];
     */
    // temporary friend array
    friends = [[NSMutableArray alloc] initWithCapacity:4];
    friendNames = [[NSMutableArray alloc] initWithObjects:@"person1",@"person2",@"person3",@"person4", nil];
    groups = [[NSMutableArray alloc] initWithCapacity:3];
    for (int a = 0; a < 4; a++) {
        friendObject *object = [friendObject FriendWithName:friendNames[a] andFact:@"usually runs with you"];
        if (a < 3) {
            NSMutableArray *temp;
            if (a == 0) {
                temp = [[NSMutableArray alloc] initWithObjects:@"person1",@"person2",@"person3",@"person4", nil];
            } else if (a == 1) {
                temp = [[NSMutableArray alloc] initWithObjects:@"person3",@"person4", nil];
            } else if (a == 2) {
                temp = [[NSMutableArray alloc] initWithObjects:@"person1",@"person2", nil];
            }
            groupObject *gObject = [groupObject GroupWithName:@"study" andMembers:temp];
            [groups addObject:gObject];
        }
        [friends addObject:object];
    }
    [References cornerRadius:createPostCard radius:10.0f];
    [References cornerRadius:inviteFriendsTitleCard radius:10.0f];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
        if(createPostScroll.contentOffset.y > 120) {
            keepScrollingCreatePost = NO;
            keepScrollingInvite = YES;
            [References moveUp:createPostScroll yChange:[References screenHeight]];
            [References moveUp:inviteFriendsScroll yChange:[References screenHeight]];
            inviteFriendsActivity.text = createPostText.text;
            return ;
        }

    }
    if (keepScrollingInvite == YES) {
        if(inviteFriendsScroll.contentOffset.y < -120) {
            keepScrollingCreatePost = YES;
            keepScrollingInvite = NO;
            [References moveDown:createPostScroll yChange:[References screenHeight]];
            [References moveDown:inviteFriendsScroll yChange:[References screenHeight]];
            return ;
        }
        
    }


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return groups.count;
    } else {
    return [friends count];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"tapGesture:");
    //    CGRect targetRectangle = self.tapView.frame;
    CGRect targetRectangle = CGRectMake(100, 100, 100, 100);
    [[UIMenuController sharedMenuController] setTargetRect:targetRectangle
                                                    inView:self.view];
    
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Custom Action"
                                                      action:@selector(customAction:)];
    
    [[UIMenuController sharedMenuController]
     setMenuItems:@[menuItem]];
    [[UIMenuController sharedMenuController]
     setMenuVisible:YES animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
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
    PostFriendsTableCell *cell = (PostFriendsTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    friendObject *object = friends[indexPath.row];
        
    if ([object valueForKey:@"selected"] == [NSNumber numberWithBool:0]) {
        [object setValue:[NSNumber numberWithBool:YES] forKey:@"selected"];
        cell.isSelected.alpha = 0.7;
    } else {
        [object setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
        cell.isSelected.alpha = 0.1;
    }
    }
}

// Our custom method
- (void)customAction:(id)sender {
    NSLog(@"Custom Action");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


@end
