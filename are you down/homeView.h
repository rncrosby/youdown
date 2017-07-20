//
//  homeView.h
//  are you down
//
//  Created by Robert Crosby on 6/12/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "infoView.h"
#import "ActivityObject.h"
#import "groupObject.h"
#import "ActivityObject.h"
#import "friendObject.h"
#import "UIColor+BFPaperColors.h"
#import "SlimActivityObject.h"

@interface homeView : UIViewController <UIScrollViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> {
    BOOL statusBarBlur;
    NSMutableArray *friends,*activities,*groups,*friendNumbers,*arrayOfInvites;
}

@end
