//
//  pushSegue.m
//  are you down
//
//  Created by Robert Crosby on 6/22/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "pushSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation pushSegue

- (void)perform{
    UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destViewController = (UIViewController *) self.destinationViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [srcViewController.view.window.layer addAnimation:transition forKey:nil];
    
    [srcViewController presentViewController:destViewController animated:NO completion:nil];
}

@end
