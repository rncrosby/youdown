//
//  friendObject.m
//  are you down
//
//  Created by Robert Crosby on 5/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "friendObject.h"

@implementation friendObject

-(id)initWithDetails:(NSString*)name andFact:(NSString*)fact{
    self = [super init];
    if (self) {
        self.name = name;
        self.fact = fact;
        self.selected = [NSNumber numberWithBool:NO];
    }
    return self;
}

+(instancetype) FriendWithName:(NSString*)name andFact:(NSString*)fact{
    friendObject *object = [[friendObject alloc] initWithDetails:name andFact:fact];
    return object;
}

@end
