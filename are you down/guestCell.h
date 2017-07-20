//
//  guestCell.h
//  are you down
//
//  Created by Robert Crosby on 6/24/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface guestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *addFriend;
@property (nonatomic) NSString *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *isGoing;

@end
