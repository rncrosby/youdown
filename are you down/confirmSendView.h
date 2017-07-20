//
//  confirmSendView.h
//  are you down
//
//  Created by Robert Crosby on 6/24/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "References.h"
#import "ActivityObject.h"

@interface confirmSendView : UIViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic) NSString *name;
@property (nonatomic) NSMutableArray *recipients,*recipientNames;


@end
