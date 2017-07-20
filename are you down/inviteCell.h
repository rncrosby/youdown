//
//  inviteCell.h
//  are you down
//
//  Created by Robert Crosby on 6/24/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface inviteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shadow;
@property (weak, nonatomic) IBOutlet UILabel *card;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *creator;
@property (weak, nonatomic) IBOutlet UIButton *yes;
@property (weak, nonatomic) IBOutlet UIButton *no;

@end
