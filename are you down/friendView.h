//
//  friendView.h
//  are you down
//
//  Created by Robert Crosby on 6/27/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sectionHeader.h"
#import "friendObject.h"
#import "groupObject.h"
#import "newGroupView.h"
#import "addFriendView.h"

@interface friendView : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSString *activityTitle;
@property (nonatomic) NSMutableArray *friendList;
@property (nonatomic) NSMutableArray *groupList;
@property (nonatomic) NSMutableArray *namesForSearch;

@end
