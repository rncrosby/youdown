//
//  References.m
//  Hitch for iOS
//
//  Created by Robert Crosby on 11/15/16.
//  Copyright © 2016 Robert Crosby. All rights reserved.
//

#import "References.h"

@interface References ()

@end

@implementation References

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(void)cornerRadius:(UIView *)view radius:(float)radius{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

+(void)borderColor:(UIView*)view color:(UIColor*)color{
    view.layer.borderWidth = 1;
    
    view.layer.borderColor = color.CGColor;
}

+(CGFloat)screenWidth {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat wid = screenSize.width;
    return wid;
}

+(CGFloat)screenHeight {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat high = screenSize.height;
    return high;
}

+(void)bottomshadow:(UIView*)view {
    view.layer.shadowOffset = CGSizeMake(0, 5);
    view.layer.shadowRadius = 5;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = .2;
}
+(void)topshadow:(UIView*)view {
    view.layer.shadowOffset = CGSizeMake(0, -2);
    view.layer.shadowRadius = 5;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = .1;
}
+(void)cardshadow:(UIView*)view {
    view.layer.shadowOffset = CGSizeMake(0, 3);
    view.layer.shadowRadius = 5;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = .1;
}

+(void)fromoffscreen:(UIView*)view where:(NSString*)where{
    CGRect location = view.frame;
    if ([where isEqualToString:@"BOTTOM"]) {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+[self screenHeight], view.frame.size.width, view.frame.size.height);
    }
    if ([where isEqualToString:@"TOP"]) {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-[self screenHeight], view.frame.size.width, view.frame.size.height);
    }
    view.hidden = NO;
    [UIView animateWithDuration:1 animations:^{
        view.frame = location;
    }];
}

+(void)fromonscreen:(UIView *)view where:(NSString *)where{
    if ([where isEqualToString:@"BOTTOM"]) {
        [UIView animateWithDuration:1 animations:^{
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+[self screenHeight], view.frame.size.width, view.frame.size.height);
        }];
            }
    if ([where isEqualToString:@"TOP"]) {
        [UIView animateWithDuration:1 animations:^{
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-[self screenHeight], view.frame.size.width, view.frame.size.height);
            
        }];
        
    }
}

+(void)justMoveOffScreen:(UIView *)view where:(NSString *)where{
    if ([where isEqualToString:@"BOTTOM"]) {
        [UIView animateWithDuration:1 animations:^{
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+[self screenHeight], view.frame.size.width, view.frame.size.height);
            }];
    }
    if ([where isEqualToString:@"TOP"]) {
         [UIView animateWithDuration:1 animations:^{
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-[self screenHeight], view.frame.size.width, view.frame.size.height);
         }];
    }
}

+(void)justMoveOnScreen:(UIView *)view where:(NSString *)where{
    if ([where isEqualToString:@"BOTTOM"]) {
        view.hidden = NO;
        [UIView animateWithDuration:1 animations:^{
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-[self screenHeight], view.frame.size.width, view.frame.size.height);
        }];
    }
    if ([where isEqualToString:@"TOP"]) {
        view.hidden = NO;
        [UIView animateWithDuration:1 animations:^{
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+[self screenHeight], view.frame.size.width, view.frame.size.height);
        }];
    }
    

}

+(void)fadeThenMove:(UIView *)view where:(NSString *)where{
    [UIView animateWithDuration:1 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        view.hidden = YES;
        if ([where isEqualToString:@"BOTTOM"]) {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+[self screenHeight], view.frame.size.width, view.frame.size.height);
            view.alpha = 1;
        }
        if ([where isEqualToString:@"TOP"]) {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-[self screenHeight], view.frame.size.width, view.frame.size.height);
            view.alpha = 1;
        }
    }];
}

+(void)fadeIn:(UIView *)view{
    view.hidden = NO;
    view.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        view.alpha = 1;
    }];
}
+(void)fadeOut:(UIView *)view{
    [UIView animateWithDuration:1 animations:^{
        view.alpha = 0;
    } completion:^(BOOL complete){
    }];
}

+(void)shift:(UIView*)view X:(float)X Y:(float)Y W:(float)W H:(float)H;{
    [UIView animateWithDuration:1 animations:^{
        view.frame = CGRectMake(X, Y, W, H);
    }];
}

+(void)moveUp:(UIView*)view yChange:(float)yChange{
    [UIView animateWithDuration:.3 animations:^{
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-yChange, view.frame.size.width, view.frame.size.height);
    }];
}
+(void)moveDown:(UIView*)view yChange:(float)yChange{
    [UIView animateWithDuration:.3 animations:^{
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+yChange, view.frame.size.width, view.frame.size.height);
    }];
}

+(void)moveHorizontal:(UIView*)view where:(NSString*)where{
    [UIView animateWithDuration:.3 animations:^{
        if ([where isEqualToString:@"RIGHT"]) {
            view.frame = CGRectMake(view.frame.origin.x+[self screenWidth], view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        }
        if ([where isEqualToString:@"LEFT"]) {
            view.frame = CGRectMake(view.frame.origin.x-[self screenWidth], view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        }

    } completion:^(BOOL finished) {
            }];

}

+(void)moveBackDown:(UIView*)view frame:(CGRect)frame{
    [UIView animateWithDuration:.3 animations:^{
        view.frame = CGRectMake(frame.origin.x, frame.origin.y-350, frame.size.width, frame.size.height);
    }];
}

+(void)textFieldInset:(UITextField *)text{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, text.frame.size.height)];
    leftView.backgroundColor = text.backgroundColor;
    text.leftView = leftView;
    text.leftViewMode = UITextFieldViewModeAlways;
}

+(void)fade:(UIView*)view alpha:(float)alpha {
    [UIView animateWithDuration:.5 animations:^{
        view.alpha = alpha;
    }];

}

+(void)blurView:(UIView *)view {
    [view setBackgroundColor:[UIColor clearColor]];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [view addSubview:blurEffectView];
    [view sendSubviewToBack:blurEffectView];
}

+(void)fadeColor:(UIView*)view color:(UIColor*)color{
    UIColor *temp = view.backgroundColor;
    view.layer.backgroundColor = temp.CGColor;
    [view setBackgroundColor:[UIColor clearColor]];
    
    [UIView animateWithDuration:0.5 animations:^{
        view.layer.backgroundColor = color.CGColor;
    } completion:NULL];
}

+(void)fadeButtonTextColor:(UIButton*)view color:(UIColor*)color{
    [UIView animateWithDuration:0.5 animations:^{
        [view setTitleColor:color forState:UIControlStateNormal];
    } completion:NULL];
}

+(void)fadeButtonColor:(UIButton*)view color:(UIColor*)color{
    [UIView animateWithDuration:0.5 animations:^{
        [view setBackgroundColor:color];
    } completion:NULL];
}

+(void)tintUIButton:(UIButton*)button color:(UIColor*)color{
    UIImage *image = [button.currentBackgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:image forState:UIControlStateNormal];
    button.tintColor = color;
}

+(NSString *) randomStringWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

+(void)createLine:(UIView*)superview view:(UIView*)view xPos:(int)xPos yPos:(int)yPos{
    view = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, 1000, 1)];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    view.alpha = 0.5;
    [superview addSubview:view];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+(NSString *)backendAddress {
    return @"http://138.197.217.29:5000/";
}

+(void)fadeLabelText:(UILabel*)view newText:(NSString*)newText {
    [UIView transitionWithView:view
                      duration:0.4f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        view.text = newText;
                        
                    } completion:nil];
}

+(UIView*)createGradient:(UIColor *)colorA andColor:(UIColor *)colorB withFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = view.bounds;
    gradient.colors = @[(id)colorA.CGColor, (id)colorB.CGColor];
    
    [view.layer insertSublayer:gradient atIndex:0];
    return view;
}

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

- (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}
@end
