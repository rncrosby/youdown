//
//  introView.h
//  are you down
//
//  Created by Robert Crosby on 6/19/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Contacts/Contacts.h>
#import "homeView.h"

@interface introView : UIViewController <UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic) AVPlayer *avPlayer;

@end
