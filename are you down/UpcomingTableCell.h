//
//  UpcomingTableCell.h
//  are you down
//
//  Created by Robert Crosby on 5/25/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "References.h"

@interface UpcomingTableCell : UITableViewCell {
    int currentMessagePosition, numberOfMessages;
    bool respond;
}


@property (weak, nonatomic) IBOutlet UIScrollView *chatView;

@property (nonatomic) NSMutableArray *invited;
@property (nonatomic)  NSMutableArray *chat;
@property (weak, nonatomic) IBOutlet UILabel *card;
@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (nonatomic) NSMutableArray *friendList,*activityList,*userMessages;


@end
