//
//  SlimActivityObject.m
//  are you down
//
//  Created by Robert Crosby on 5/29/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "SlimActivityObject.h"

@implementation SlimActivityObject

-(id)initWithDetails:(NSString*)name andCreator:(NSString*)creator andID:(NSString*)actID{
    self = [super init];
    if (self) {
        self.name = name;
        self.creator = creator;
        self.actID = actID;
    }
    return self;
}
+(instancetype)SlimActivityWithName:(NSString*)name andCreator:(NSString*)creator andID:(NSString*)actID{
    SlimActivityObject *object = [[SlimActivityObject alloc] initWithDetails:name andCreator:creator andID:actID];
    return object;
}

@end
