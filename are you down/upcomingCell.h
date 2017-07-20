//
//  upcomingCell.h
//  are you down
//
//  Created by Robert Crosby on 6/12/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface upcomingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *card;
@property (weak, nonatomic) IBOutlet UILabel *createdBy;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *shortInfo;
@property (weak, nonatomic) IBOutlet UIImageView *forward;

@end
