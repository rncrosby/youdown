//
//  EditGroup.h
//  are you down
//
//  Created by Robert Crosby on 5/19/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "groupObject.h"
#import "References.h"
#import "PostFriendsTableCell.h"
#import "friendObject.h"
#import "groupObject.h"
#import "PostView.h"

@interface EditGroup : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> {
    __weak IBOutlet UITableView *friendTable;
    NSMutableArray *groupMembers;
    NSString *oldName;
    bool anyGroupMembers;
}

@property (nonatomic) NSString *groupName;
@property (nonatomic) NSMutableArray *friendList;
@property (nonatomic) groupObject *group;
- (IBAction)close:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *groupNameField;


@end
