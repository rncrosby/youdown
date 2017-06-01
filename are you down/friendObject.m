//
//  friendObject.m
//  are you down
//
//  Created by Robert Crosby on 5/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "friendObject.h"

@implementation friendObject

-(id)initWithDetails:(NSString*)name andPhone:(NSString*)phone{
    self = [super init];
    if (self) {
        self.name = name;
        self.phone = phone;
        self.selected = [NSNumber numberWithBool:NO];
    }
    return self;
}

+(instancetype) FriendWithName:(NSString*)name andPhone:(NSString*)phone{
    friendObject *object = [[friendObject alloc] initWithDetails:name andPhone:phone];
    return object;
}

@end
