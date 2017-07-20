//
//  invitesView.m
//  are you down
//
//  Created by Robert Crosby on 6/24/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "invitesView.h"
#import "References.h"

@interface invitesView () {
    
    __weak IBOutlet UIScrollView *superScrollView;
    __weak IBOutlet UITableView *inviteTable;
    __weak IBOutlet UIButton *close;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *statusBarBlur;
    bool statusBar;
}
- (IBAction)close:(id)sender;

@end

@implementation invitesView

- (void)viewDidLoad {
    if ([References screenHeight] > 568) {
        close.frame = CGRectMake(close.frame.origin.x+50, close.frame.origin.y, close.frame.size.width, close.frame.size.height);
        superScrollView.frame = CGRectMake(0, 0, [References screenWidth], [References screenHeight]);
        statusBarBlur.frame = CGRectMake(statusBarBlur.frame.origin.x, statusBarBlur.frame.origin.y, [References screenWidth], statusBarBlur.frame.size.height);
        if ([References screenHeight] > 667) {
            close.frame = CGRectMake(close.frame.origin.x+30, close.frame.origin.y, close.frame.size.width, close.frame.size.height);

        }
    }
    statusBarBlur.alpha = 0;
    statusBar = NO;
    [References blurView:statusBarBlur];
    [References createLine:superScrollView xPos:8 yPos:titleLabel.frame.origin.y+titleLabel.frame.size.height+4];
    [References tintUIButton:close color:[UIColor darkGrayColor]];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier = @"inviteCell";
    inviteCell *cell = (inviteCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    int ogWidth = cell.card.frame.size.width;
    if ([References screenHeight] > 568) {
        cell.card.frame = CGRectMake(cell.card.frame.origin.x, cell.card.frame.origin.y, [References screenWidth]-16, cell.card.frame.size.height);
        cell.shadow.frame = CGRectMake(cell.shadow.frame.origin.x, cell.shadow.frame.origin.y, [References screenWidth]-21, cell.shadow.frame.size.height);
        cell.no.frame = CGRectMake(cell.no.frame.origin.x, cell.no.frame.origin.y, cell.no.frame.size.width+((cell.card.frame.size.width-ogWidth)/2), cell.no.frame.size.height);
        cell.yes.frame = CGRectMake(cell.yes.frame.origin.x+((cell.card.frame.size.width-ogWidth)/2), cell.yes.frame.origin.y, cell.yes.frame.size.width+((cell.card.frame.size.width-ogWidth)/2), cell.yes.frame.size.height);
    }
    CAGradientLayer *gradient = [References createGradient:[References colorFromHexString:@"#F97794"] andColor:[References colorFromHexString:@"#623AA2"]];
    SlimActivityObject *object = _invitesArray[indexPath.row];
    cell.name.text = [object valueForKey:@"name"];
    cell.creator.text = [NSString stringWithFormat:@"%@ INVITED YOU",[[object valueForKey:@"creator"]uppercaseString]];
    cell.yes.tag = indexPath.row;
    cell.no.tag = indexPath.row;
    [cell.card.layer insertSublayer:gradient atIndex:0];
    cell.shadow.backgroundColor = [UIColor whiteColor];
    [cell.yes addTarget:self action:@selector(willAttend:) forControlEvents:UIControlEventTouchUpInside];
    [cell.no addTarget:self action:@selector(willNotAttend:) forControlEvents:UIControlEventTouchUpInside];
    [References cardshadow:cell.shadow];
    [References cornerRadius:cell.card radius:8.0f];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    superScrollView.contentSize = CGSizeMake([References screenWidth], 81 + (_invitesArray.count*98));
    inviteTable.frame = CGRectMake(0, inviteTable.frame.origin.y, [References screenWidth], _invitesArray.count*98);
    return _invitesArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 98;
}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0) {
        if (statusBar == NO) {
            statusBar = YES;
            [References fadeIn:statusBarBlur];
        }
    } else if (scrollView.contentOffset.y <= 0) {
        if (statusBar == YES) {
            statusBar = NO;
            [References fadeOut:statusBarBlur];
        }
    }
}

-(void)willAttend:(id)sender {
    UIButton *button = (UIButton*)sender;
    SlimActivityObject *object = [_invitesArray objectAtIndex:button.tag];
    [self amAttending:[object valueForKey:@"actID"]];
}

-(void)willNotAttend:(id)sender {
    UIButton *button = (UIButton*)sender;
    SlimActivityObject *object = [_invitesArray objectAtIndex:button.tag];
    [self notAttending:[object valueForKey:@"actID"]];
}

-(void)amAttending:(NSString*)actID{
    NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/amAttending"];
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
                                       [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
                                       [[UIApplication sharedApplication] cancelAllLocalNotifications];
                                       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"refreshInvites"];
                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   } else {
                                       [_invitesArray removeAllObjects];
                                       _invitesArray = [[NSMutableArray alloc] init];
                                       NSArray *tempArrayOfInvites = [responseBody componentsSeparatedByString:@"***"];
                                       for (int a = 0; a < tempArrayOfInvites.count-1; a++) {
                                           NSArray *tempInvite = [tempArrayOfInvites[a] componentsSeparatedByString:@"!@#"];
                                           SlimActivityObject *object = [SlimActivityObject SlimActivityWithName:tempInvite[2] andCreator:tempInvite[3] andID:tempInvite[1]];
                                           [_invitesArray addObject:object];
                                       }
                                       [[UIApplication sharedApplication] setApplicationIconBadgeNumber: _invitesArray.count];
                                       [inviteTable reloadData];
                                   }
                               }
                           }];
}

-(void)notAttending:(NSString*)actID{
    NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/notAttending"];
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
                                       [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
                                       [[UIApplication sharedApplication] cancelAllLocalNotifications];
                                       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"refreshInvites"];
                                       [[NSUserDefaults standardUserDefaults] synchronize];
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   } else {
                                       [_invitesArray removeAllObjects];
                                       _invitesArray = [[NSMutableArray alloc] init];
                                       NSArray *tempArrayOfInvites = [responseBody componentsSeparatedByString:@"***"];
                                       for (int a = 0; a < tempArrayOfInvites.count-1; a++) {
                                           NSArray *tempInvite = [tempArrayOfInvites[a] componentsSeparatedByString:@"!@#"];
                                           SlimActivityObject *object = [SlimActivityObject SlimActivityWithName:tempInvite[2] andCreator:tempInvite[3] andID:tempInvite[1]];
                                           [_invitesArray addObject:object];
                                       }
                                       [[UIApplication sharedApplication] setApplicationIconBadgeNumber: _invitesArray.count];
                                       [inviteTable reloadData];
                                   }
                               }
                           }];
}

@end
