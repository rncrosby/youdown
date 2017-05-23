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

@interface EditGroup : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    NSString* groupName;
    NSMutableArray* groupMembers;
    __weak IBOutlet UITableView *friendTable;
}

@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSMutableArray *groupMembers;

@end
