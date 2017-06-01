//
//  MessageObject.m
//  are you down
//
//  Created by Robert Crosby on 5/25/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "MessageObject.h"

@implementation MessageObject

-(id)initWithDetails:(NSString*)text andAmSender:(NSNumber*)amSender{
    self = [super init];
    if (self) {
        self.amSender = amSender;
        self.text = text;
    }
    return self;
}

+(instancetype)MessageWithText:(NSString*)text andAmSender:(NSNumber*)amSender{
    MessageObject *object = [[MessageObject alloc] initWithDetails:text andAmSender:amSender];
    return object;
}

@end
