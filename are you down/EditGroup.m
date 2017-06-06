//
//  EditGroup.m
//  are you down
//
//  Created by Robert Crosby on 5/19/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "EditGroup.h"

@interface EditGroup ()

@end

@implementation EditGroup

-(void)viewDidLoad {

    [super viewDidLoad];
    [_groupNameField setText:_groupName];
    oldName = _groupNameField.text;
    NSLog(@"group members now:");
    if ([_group valueForKey:@"members"] != NULL) {
        groupMembers = [_group valueForKey:@"members"];
    }
    if (_isNewGroup == [NSNumber numberWithBool:YES]) {
        groupMembers = [[NSMutableArray alloc] init];
    }
    if (groupMembers.count > 0) {
        anyGroupMembers = true;
    } else {
        anyGroupMembers = false;
    }
}

- (IBAction)close:(id)sender {
    if (_groupNameField.text.length < 1) {
        [References toastMessage:@"you need to give your group a name" andView:self];
    } else {
        [self modifyGroup];
    }

}

-(void)modifyGroup{
    NSString *groupMemberString = [NSString stringWithFormat:@"%@*&^",_groupNameField.text];
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
            @"groupName"     : _groupNameField.text,
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


-(bool)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return _friendList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
    friendObject *object = _friendList[indexPath.row];
    cell.name.text = [object valueForKey:@"name"];
    //cell.name.frame = CGRectMake(cell.name.frame.origin.x, 0, cell.name.frame.size.width, cell.frame.size.height);
    cell.fact.text = [object valueForKey:@"phone"];
    //cell.fact.hidden = YES;
    if (anyGroupMembers == false) {
        cell.isSelected.alpha = 0.1;
    } else {
        for (int a = 0; a < groupMembers.count; a++) {
            if ([cell.fact.text isEqualToString:groupMembers[a]]) {
                cell.isSelected.alpha = 0.7;
                a = (int)groupMembers.count;
            } else {
                cell.isSelected.alpha = 0.1;
            }
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PostFriendsTableCell *cell = (PostFriendsTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    bool didntfind = true;
    for (int a = 0; a < groupMembers.count; a++) {
        if ([cell.fact.text isEqualToString:groupMembers[a]]) {
            [groupMembers removeObjectAtIndex:a];
            if (groupMembers.count == 0) {
                NSLog(@"no members now");
                anyGroupMembers = false;
            }
            didntfind = false;
            a = (int)groupMembers.count;
        }
    }
    if (didntfind == true) {
        anyGroupMembers = true;
        [groupMembers addObject:cell.fact.text];
    }
    [tableView reloadData];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
