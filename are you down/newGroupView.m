//
//  newGroupView.m
//  are you down
//
//  Created by Robert Crosby on 6/13/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "newGroupView.h"
#import "References.h"
#import "sendCell.h"
#import "friendObject.h"

@interface newGroupView () {
    NSMutableArray *groupMembers;
    bool anyGroupMembers;
    __weak IBOutlet UITextField *groupName;
    __weak IBOutlet UITableView *friendTable;
}
- (IBAction)save:(id)sender;

@end

@implementation newGroupView

- (void)viewDidLoad {
    if ([References screenHeight] > 568) {
        friendTable.frame = CGRectMake(friendTable.frame.origin.x, friendTable.frame.origin.y, [References screenWidth], [References screenHeight] - friendTable.frame.origin.y);
    }
    [References createLine:self.view xPos:groupName.frame.origin.x yPos:groupName.frame.origin.y+groupName.frame.size.height+4];
    groupMembers = [[NSMutableArray alloc] init];
    if (_isNewGroup == [NSNumber numberWithBool:YES]) {
        [groupName setText:@"New Group"];
        anyGroupMembers = NO;
    } else {
        groupMembers = [_group valueForKey:@"members"];
        [groupName setText:[_group valueForKey:@"name"]];
        anyGroupMembers = YES;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_friendList.count == 0) {
        tableView.alpha = 0;
    }
    return _friendList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else {
        return 44;
    }
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
    friendObject *object = _friendList[indexPath.row];
    cell.name.text = [object valueForKey:@"name"];
    if (anyGroupMembers == false) {
        cell.isSelected.alpha = 0.1;
    } else {
        NSString *phone = [object valueForKey:@"phone"];
        for (int a = 0; a < groupMembers.count; a++) {
            if ([phone isEqualToString:groupMembers[a]]) {
                cell.isSelected.alpha = 0.7;
                a = (int)groupMembers.count;
            } else {
                cell.isSelected.alpha = 0.1;
            }
        }
    }
    if ([References screenHeight] > 568) {
        cell.isSelected.frame = CGRectMake(334, cell.isSelected.frame.origin.y, cell.isSelected.frame.size.width, cell.isSelected.frame.size.height);
        if ([References screenHeight] > 667) {
            cell.isSelected.frame = CGRectMake(cell.isSelected.frame.origin.x+30, cell.isSelected.frame.origin.y, cell.isSelected.frame.size.width, cell.isSelected.frame.size.height);
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    friendObject *object = _friendList[indexPath.row];
    NSString *phoneNumber = [object valueForKey:@"phone"];
    if (anyGroupMembers == NO) {
        [groupMembers addObject:phoneNumber];
        anyGroupMembers = YES;
    } else {
        bool didFind = NO;
        for (int a = 0; a < groupMembers.count; a++) {
            if ([phoneNumber isEqualToString:groupMembers[a]]) {
                [groupMembers removeObjectAtIndex:a];
                didFind = YES;
                break;
            }
        }
        if (groupMembers.count == 0) {
            anyGroupMembers = NO;
        }
        if (didFind == NO) {
            [groupMembers addObject:phoneNumber];
        }
    }
    [friendTable reloadData];
}


- (IBAction)save:(id)sender {
    [self modifyGroup];
}

-(bool)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)modifyGroup{
    NSString *groupMemberString = [NSString stringWithFormat:@"%@*&^",groupName.text];
    for (int a = 0; a < groupMembers.count; a++) {
        groupMemberString = [NSString stringWithFormat:@"%@%@*&^",groupMemberString,groupMembers[a]];
    }
    NSURL *url = [NSURL URLWithString:@"http://138.197.217.29:5000/modifyGroup"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // NSError *actualerror = [[NSError alloc] init];
    // Parameters
    NSDictionary *tmp = [[NSDictionary alloc] init];
    tmp = @{
            @"groupName"     : groupName.text,
            @"group"     : groupMemberString,
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
                                   [[NSUserDefaults standardUserDefaults] setObject:responseBody forKey:@"updateFriends"];
                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }
                           }];
}
- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
