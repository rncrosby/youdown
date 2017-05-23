//
//  groupObject.m
//  are you down
//
//  Created by Robert Crosby on 5/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "groupObject.h"

@implementation groupObject

-(id)initWithDetails:(NSString*)name andMembers:(NSMutableArray*)members{
    self = [super init];
    if (self) {
        self.name = name;
        self.members = members;
        self.selected = [NSNumber numberWithBool:NO];
    }
    return self;
}

+(instancetype) GroupWithName:(NSString *)name andMembers:(NSMutableArray *)members{
    groupObject *object = [[groupObject alloc] initWithDetails:name andMembers:members];
    return object;
}

@end
