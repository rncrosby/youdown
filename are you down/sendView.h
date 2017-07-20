//
//  sendView.h
//  are you down
//
//  Created by Robert Crosby on 6/13/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sendCell.h"
#import "newGroupView.h"
#import "sectionHeader.h"
#import "confirmSendView.h"

@interface sendView : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate> {
    NSMutableArray *recipients,*recipientNames;
    bool alertIsShowing;
}
@property (nonatomic) NSString *activityTitle;
@property (nonatomic) NSMutableArray *friendList;
@property (nonatomic) NSMutableArray *groupList;
@property (nonatomic) NSMutableArray *namesForSearch;

@end
