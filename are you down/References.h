//
//  References.h
//  Hitch for iOS
//
//  Created by Robert Crosby on 11/15/16.
//  Copyright © 2016 Robert Crosby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface References : UIViewController <NSURLConnectionDataDelegate> {
    NSMutableData *_responseData;
    NSString *result;
}
+(NSString *)backendAddress;
+(UIColor *)colorFromHexString:(NSString *)hexString;
+(CGFloat)screenWidth;
+(CGFloat)screenHeight;
+(void)borderColor:(UIView*)view color:(UIColor*)color;
+(void)cornerRadius:(UIView*)view radius:(float)radius;
+(void)bottomshadow:(UIView*)view;
+(void)topshadow:(UIView*)view;
+(void)cardshadow:(UIView*)view;
+(void)fade:(UIView*)view alpha:(float)alpha;
+(void)fromoffscreen:(UIView*)view where:(NSString*)where;
+(void)fromonscreen:(UIView*)view where:(NSString*)where;
+(void)justMoveOffScreen:(UIView*)view where:(NSString*)where;
+(void)justMoveOnScreen:(UIView*)view where:(NSString*)where;
+(void)fadeThenMove:(UIView*)view where:(NSString*)where;
+(void)fadeIn:(UIView*)view;
+(void)fadeOut:(UIView*)view;
+(void)shift:(UIView*)view X:(float)X Y:(float)Y W:(float)W H:(float)H;
+(void)moveUp:(UIView*)view yChange:(float)yChange;
+(void)moveDown:(UIView*)view yChange:(float)yChange;
+(void)moveBackDown:(UIView*)view frame:(CGRect)frame;
+(void)blurView:(UIView*)view;
+(void)textFieldInset:(UITextField*)text;
+(void)fadeColor:(UIView*)view color:(UIColor*)color;
+(void)fadeButtonTextColor:(UIButton*)view color:(UIColor*)color;
+(void)fadeButtonColor:(UIButton*)view color:(UIColor*)color;
+(void)tintUIButton:(UIButton*)button color:(UIColor*)color;
+(void)createLine:(UIView*)superview view:(UIView*)view xPos:(int)xPos yPos:(int)yPos;
+(void)fadeLabelText:(UILabel*)view newText:(NSString*)newText;
+(void)moveHorizontal:(UIView*)view where:(NSString*)where;
+(NSString *) randomStringWithLength: (int) len;
+(UIView*)createGradient:(UIColor*)colorA andColor:(UIColor*)colorB withFrame:(CGRect)frame;
+(UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
@end
