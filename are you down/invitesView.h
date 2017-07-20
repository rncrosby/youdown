//
//  invitesView.h
//  are you down
//
//  Created by Robert Crosby on 6/24/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlimActivityObject.h"
#import "inviteCell.h"

@interface invitesView : UIViewController <UITableViewDelegate,UITableViewDataSource> {
}

@property (nonatomic) NSMutableArray *invitesArray;
@end
