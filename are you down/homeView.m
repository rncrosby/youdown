//
//  homeView.m
//  are you down
//
//  Created by Robert Crosby on 6/12/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "homeView.h"
#import "References.h"
#import "upcomingCell.h"
#import "sendView.h"
#import "invitesView.h"

#define CELLHEIGHT 118

@interface homeView () {
    
    __weak IBOutlet UIScrollView *superScrollView;
    __weak IBOutlet UILabel *statusBar;
    // create new
    __weak IBOutlet UITextField *new_textField;
    __weak IBOutlet UILabel *new_Title;
    __weak IBOutlet UIButton *new_Next;
    
    // for you
    __weak IBOutlet UILabel *forYou_Title;
    __weak IBOutlet UITableView *forYou_Table;
	NSMutableArray *namesForSearch;
    __weak IBOutlet UIButton *settings;
    __weak IBOutlet UIButton *invite;
    __weak IBOutlet UILabel *inviteCount;
    __weak IBOutlet UILabel *inviteCountText;
    __weak IBOutlet UIButton *addFriend;
	
}
- (IBAction)new_Next:(id)sender;
- (IBAction)showInvites:(id)sender;
- (IBAction)addFriend:(id)sender;

@end

@implementation homeView

- (void)viewDidLoad {
	if ([References screenHeight] > 568) {
		new_textField.frame = CGRectMake(new_textField.frame.origin.x, new_textField.frame.origin.y, [References screenWidth]-16, new_textField.frame.size.height);
		new_Next.frame = CGRectMake(new_Next.frame.origin.x+new_Next.frame.size.width, new_Next.frame.origin.y, new_Next.frame.size.width, new_Next.frame.size.height);
		settings.frame = CGRectMake(settings.frame.origin.x+50, settings.frame.origin.y, settings.frame.size.width, settings.frame.size.height);
		invite.frame = CGRectMake(invite.frame.origin.x+50, invite.frame.origin.y, invite.frame.size.width, invite.frame.size.height);
		addFriend.frame = CGRectMake(addFriend.frame.origin.x+50, addFriend.frame.origin.y, addFriend.frame.size.width, addFriend.frame.size.height);
		inviteCount.frame = CGRectMake(inviteCount.frame.origin.x+50, inviteCount.frame.origin.y, inviteCount.frame.size.width, inviteCount.frame.size.height);
		inviteCountText.frame = CGRectMake(inviteCountText.frame.origin.x+50, inviteCountText.frame.origin.y, inviteCountText.frame.size.width, inviteCountText.frame.size.height);
		statusBar.frame = CGRectMake(statusBar.frame.origin.x, statusBar.frame.origin.y, [References screenWidth], statusBar.frame.size.height);
		if ([References screenHeight] > 667) {
			invite.frame = CGRectMake(invite.frame.origin.x+30, invite.frame.origin.y, invite.frame.size.width, invite.frame.size.height);
			addFriend.frame = CGRectMake(addFriend.frame.origin.x+30, addFriend.frame.origin.y, addFriend.frame.size.width, addFriend.frame.size.height);
			inviteCount.frame = CGRectMake(inviteCount.frame.origin.x+30, inviteCount.frame.origin.y, inviteCount.frame.size.width, inviteCount.frame.size.height);
			inviteCountText.frame = CGRectMake(inviteCountText.frame.origin.x+30, inviteCountText.frame.origin.y, inviteCountText.frame.size.width, inviteCountText.frame.size.height);
			settings.frame = CGRectMake(settings.frame.origin.x+30, settings.frame.origin.y, settings.frame.size.width, settings.frame.size.height);
			new_Next.frame = CGRectMake(new_Next.frame.origin.x+40, new_Next.frame.origin.y, new_Next.frame.size.width, new_Next.frame.size.height);
		}
	}
	inviteCount.hidden = YES;
	inviteCountText.hidden = YES;
	[References cornerRadius:inviteCount radius:inviteCount.frame.size.width/2];
	CAGradientLayer *gradient = [References createGradient:[UIColor paperColorRed400] andColor:[UIColor paperColorRed600]];
	[inviteCount.layer insertSublayer:gradient atIndex:0];
    [References tintUIButton:settings color:[References colorFromHexString:@"#F97794"]];
	[References tintUIButton:addFriend color:[References colorFromHexString:@"#F97794"]];
    [References tintUIButton:invite color:[References colorFromHexString:@"#F97794"]];
    statusBarBlur = NO;
    [References blurView:statusBar];
    [References createLine:superScrollView xPos:forYou_Title.frame.origin.x yPos:forYou_Title.frame.origin.y+forYou_Title.frame.size.height+4];
    [References cornerRadius:new_textField radius:8.0f];
    [References textFieldInset:new_textField];
    [super viewDidLoad];
    [self getActivities];
	[self getInvites];
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	//set text for the refresh view indicating that we are refreshing
	refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh" ];
	[refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
	//assuming self.scrollView is connected to a UIScrollView control
	//add the refresh controll to the subview
	//[self.scrollView addSubview:refreshControl];
	[superScrollView insertSubview:refreshControl atIndex:0];
    // Do any additional setup after loading the view.
}

-(void)refreshView: (UIRefreshControl *) refresh{
	
	//this is where we'd do our data fetch
	//since we are not fetching real data here
	//I'll add an artificial delay here
	[self getActivities];
	[self getInvites];
	//the code in the block will not run until 2 seconds has passed
	double delayInSeconds = 1;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	//execute the code after .5 seconds
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		
		//once all the data has been fetched
		//we should end the refresh animation by
		//calling the endRefreshing Method of UIRefreshControl
		[refresh endRefreshing];
		
	});
}

-(void)viewDidAppear:(BOOL)animated {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"reloadActivities"] == YES) {
		[self getActivities];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"reloadActivites"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"refreshInvites"] == YES) {
			invite.enabled = NO;
			inviteCountText.hidden = YES;
			inviteCount.hidden = YES;
		[self getInvites];
		[self getActivities];
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refreshInvites"];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    upcomingCell *cell = (upcomingCell *)[tableView dequeueReusableCellWithIdentifier:@"upcomingCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"upcomingCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
	if ([References screenHeight] > 568) {
		cell.card.frame = CGRectMake(cell.card.frame.origin.x, cell.card.frame.origin.y, [References screenWidth]-16, cell.card.frame.size.height);
		cell.forward.frame = CGRectMake(cell.forward.frame.origin.x+50, cell.forward.frame.origin.y, cell.forward.frame.size.width, cell.forward.frame.size.height);
		if ([References screenHeight] > 667) {
			cell.forward.frame = CGRectMake(cell.forward.frame.origin.x+30, cell.forward.frame.origin.y, cell.forward.frame.size.width, cell.forward.frame.size.height);
		}
	}
	
    cell.backgroundColor = [UIColor clearColor];
    [References cornerRadius:cell.card radius:8.0f];
	
    CAGradientLayer *gradient = [References createGradient:[References colorFromHexString:@"#F97794"] andColor:[References colorFromHexString:@"#623AA2"]];
    [cell.card.layer insertSublayer:gradient atIndex:0];
    UILabel *shadow = [[UILabel alloc] initWithFrame:CGRectMake(cell.card.frame.origin.x+5, cell.card.frame.origin.y+5, cell.card.frame.size.width-10, cell.card.frame.size.height-10)];
    shadow.backgroundColor = [UIColor whiteColor];
    [References cardshadow:shadow];
    [cell addSubview:shadow];
    [cell sendSubviewToBack:shadow];
    ActivityObject *activity = activities[indexPath.row];
    cell.title.text = [activity valueForKey:@"name"];
    cell.createdBy.text = [NSString stringWithFormat:@"CREATED BY %@",[activity valueForKey:@"creator"]];
	NSNumber *time = [activity valueForKey:@"time"];
	if ([time doubleValue] == 0) {
		cell.shortInfo.text = @"Now";
	} else if ([time doubleValue] == 1) {
		cell.shortInfo.text = @"Soon";
	} else {
		NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[time doubleValue]];
		NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
		[formatter setDateFormat:@"MMM d, h:mm a"];
		cell.shortInfo.text = [formatter stringFromDate:date];
	}
    //cell.shortInfo.text = [NSString stringWithFormat:@"%@ and %lu others were invited",invited[0],invited.count-1];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELLHEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger heightRows = activities.count * CELLHEIGHT;
	superScrollView.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]);
	superScrollView.contentSize = CGSizeMake([References screenWidth], tableView.frame.origin.y + heightRows + 8);
	tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, [References screenWidth], heightRows);
    return activities.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	dispatch_async(dispatch_get_main_queue(), ^{
		infoView *viewController = [[UIStoryboard storyboardWithName:@"iPhone4" bundle:nil] instantiateViewControllerWithIdentifier:@"infoView"];
		viewController.activity = activities[indexPath.row];
		[self presentViewController:viewController animated:YES completion:nil];
	});
}


-(void)getActivities{
    NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/getMyActivities"];
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
									   NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
									   f.numberStyle = NSNumberFormatterDecimalStyle;
									   
                                       NSArray *attending = [activityArray[6] componentsSeparatedByString:@"@~!"];
                                       
                                       NSMutableArray *names = [[NSMutableArray alloc] initWithArray:[activityArray[7] componentsSeparatedByString:@"$#$"]];
                                       ActivityObject *activity = [ActivityObject ActivityWithName:activityArray[2] andGuests:pending andMessages:messages andAttending:[[NSMutableArray alloc] initWithArray:attending] andID:activityArray[1] andNames:names andCreator:[activityArray[3] uppercaseString] andTime:[f numberFromString:activityArray[9]]];
									   
                                       [activities addObject:activity];
                                   }
								   if (activities.count > 0) {
									   [self sortActivities];
								   }
								   
                               }
                           }];
}



-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
	if (new_Next.alpha == 0) {
		[References shift:new_textField X:new_textField.frame.origin.x Y:new_textField.frame.origin.y W:new_textField.frame.size.width-new_Next.frame.size.width-8 H:new_textField.frame.size.height];
		[References fadeIn:new_Next];
	}
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (new_textField.text.length < 1) {
		[References shift:new_textField X:new_textField.frame.origin.x Y:new_textField.frame.origin.y W:new_textField.frame.size.width+new_Next.frame.size.width+8 H:new_textField.frame.size.height];
		[References fadeOut:new_Next];
	}
    [textField resignFirstResponder];
    return YES;
}

-(void)getFriends{
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
								   
                                   [friends removeAllObjects];
                                   [groups removeAllObjects];
								   [namesForSearch removeAllObjects];
                                   NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
								   
                                   NSArray *seperator = [responseBody componentsSeparatedByString:@"!@!@"];
                                   NSArray *allGroups = [seperator[0] componentsSeparatedByString:@"#$#$"];
								   groups = [[NSMutableArray alloc] init];
                                   for (int a = 0; a < allGroups.count-1; a++) {
                                       NSArray *tempGroup = [allGroups[a] componentsSeparatedByString:@"*&^"];
                                       NSMutableArray *tempGroupMembers = [[NSMutableArray alloc] init];
                                       for (int b = 1; b < tempGroup.count-1; b++) {
                                           [tempGroupMembers addObject:tempGroup[b]];
                                       }
                                       groupObject *tempGroupObject = [groupObject GroupWithName:tempGroup[0] andMembers:tempGroupMembers];
                                       [groups addObject:tempGroupObject];
                                   }
								   namesForSearch = [[NSMutableArray alloc] init];
                                   NSArray *allFriends = [seperator[1] componentsSeparatedByString:@"***"];
                                   friends = [[NSMutableArray alloc] init];
                                   for (int a = 0; a < allFriends.count-1; a++) {
                                       NSArray *person = [allFriends[a] componentsSeparatedByString:@"@#$@"];
                                       
                                       friendObject *friend = [friendObject FriendWithName:person[1] andPhone:person[2]];
									   [namesForSearch addObject:person[1]];
                                       //[friendNumbers addObject:person[2]];
                                       [friends addObject:friend];
                                   }
									
                               }
									
                           }];
    
}

-(void)getInvites{
	NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/getMyInvites"];
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
								   [arrayOfInvites removeAllObjects];
								   arrayOfInvites = [[NSMutableArray alloc] init];
								   NSArray *tempArrayOfInvites = [responseBody componentsSeparatedByString:@"***"];
								   for (int a = 0; a < tempArrayOfInvites.count-1; a++) {
									   NSArray *tempInvite = [tempArrayOfInvites[a] componentsSeparatedByString:@"!@#"];
									   SlimActivityObject *object = [SlimActivityObject SlimActivityWithName:tempInvite[2] andCreator:tempInvite[3] andID:tempInvite[1]];
									   [arrayOfInvites addObject:object];
								   }
								   if (arrayOfInvites.count == 0) {
									   [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
									   [[UIApplication sharedApplication] cancelAllLocalNotifications];
									   invite.enabled = NO;
								   } else {
									   [[NSUserDefaults standardUserDefaults] setInteger:arrayOfInvites.count forKey:@"notificationCount"];
									   inviteCountText.text = [NSString stringWithFormat:@"%lu",(unsigned long)arrayOfInvites.count];
									   [[UIApplication sharedApplication] setApplicationIconBadgeNumber: arrayOfInvites.count];
									   inviteCountText.hidden = NO;
									   inviteCount.hidden = NO;
									   invite.enabled = YES;
								   }
							   }
						   }];
}

- (IBAction)new_Next:(id)sender {
	sendView *viewController = [[UIStoryboard storyboardWithName:@"iPhone4" bundle:nil] instantiateViewControllerWithIdentifier:@"sendView"];
	viewController.activityTitle = new_textField.text;
	viewController.friendList = friends;
	viewController.groupList = groups;
	viewController.namesForSearch = namesForSearch;
	
	[self presentViewController:viewController animated:YES completion:nil];

}

- (IBAction)showInvites:(id)sender {
	dispatch_async(dispatch_get_main_queue(), ^{
		invitesView *viewController = [[UIStoryboard storyboardWithName:@"iPhone4" bundle:nil] instantiateViewControllerWithIdentifier:@"invitesView"];
		viewController.invitesArray = arrayOfInvites;
		[self presentViewController:viewController animated:YES completion:nil];

			});
}

-(void)sortActivities {
	bool keepSorting = YES;
	int swapsMade = 0;
	while (keepSorting == YES) {
		for (int a = 0; a < activities.count-1; a++) {
			if (activities[a+1]) {
			NSNumber *timeA = [activities[a] valueForKey:@"time"];
			NSNumber *timeB = [activities[a+1] valueForKey:@"time"];
					if (timeA.doubleValue > timeB.doubleValue) {
						ActivityObject *tempObject = activities[a+1];
						activities[a+1] = activities[a];
						activities[a] = tempObject;
						swapsMade++;
					}
			}
		}
		if (swapsMade == 0) {
			keepSorting = NO;
		} else {
			swapsMade = 0;
		}
	}
	[forYou_Table reloadData];
}

- (IBAction)addFriend:(id)sender {
}

-(void)message{
	// Check the result or perform other tasks.    // Dismiss the message compose view controller.
	[self dismissViewControllerAnimated:YES completion:nil];}

@end
