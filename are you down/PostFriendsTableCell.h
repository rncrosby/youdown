//
//  PostFriendsTableCell.h
//  are you down
//
//  Created by Robert Crosby on 5/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostFriendsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *isSelected;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *fact;

@end
