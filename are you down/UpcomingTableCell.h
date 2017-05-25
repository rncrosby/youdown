//
//  UpcomingTableCell.h
//  are you down
//
//  Created by Robert Crosby on 5/25/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpcomingTableCell : UITableViewCell

@property (nonatomic) NSMutableArray *invited;
@property (nonatomic)  NSMutableArray *chat;
@property (weak, nonatomic) IBOutlet UILabel *card;
@property (weak, nonatomic) IBOutlet UILabel *activityName;


@end
