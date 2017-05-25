//
//  InboxTableCell.h
//  are you down
//
//  Created by Robert Crosby on 5/24/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *card;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *who;
@property (weak, nonatomic) IBOutlet UIButton *ignore;
@property (weak, nonatomic) IBOutlet UIButton *no;
@property (weak, nonatomic) IBOutlet UIButton *yeah;
@property (weak, nonatomic) IBOutlet UIButton *more;
@property (weak, nonatomic) IBOutlet UILabel *secondCard;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end
