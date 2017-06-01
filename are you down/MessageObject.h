//
//  MessageObject.h
//  are you down
//
//  Created by Robert Crosby on 5/25/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageObject : NSObject

+(instancetype)MessageWithText:(NSString*)text andAmSender:(NSNumber*)amSender;

@property (nonatomic, strong) NSNumber *amSender;
@property (nonatomic, strong) NSString *text;

@end
