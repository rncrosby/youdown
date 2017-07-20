//
//  newGroupView.h
//  are you down
//
//  Created by Robert Crosby on 6/13/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "groupObject.h"

@interface newGroupView : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic) groupObject *group;
@property (nonatomic) NSMutableArray *friendList;
@property (nonatomic) NSNumber *isNewGroup;
@property (nonatomic) NSString *oldgroupName;
@end
