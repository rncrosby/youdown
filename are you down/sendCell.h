//
//  sendCell.h
//  are you down
//
//  Created by Robert Crosby on 6/13/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "groupObject.h"

@interface sendCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *isSelected;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet groupObject *groupMembers;
@end
