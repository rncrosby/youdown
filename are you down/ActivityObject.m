//
//  ActivityObject.m
//  are you down
//
//  Created by Robert Crosby on 5/25/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import "ActivityObject.h"

@implementation ActivityObject

-(id)initWithDetails:(NSString*)name andGuests:(NSMutableArray*)guests andAttending:(NSMutableArray*)attending andMessages:(NSMutableArray*)messages andID:(NSString*)actID{
    self = [super init];
    if (self) {
        self.name = name;
        self.guests = guests;
        self.messages = messages;
        self.attending = attending;
        self.actID = actID;
        self.creator = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    }
    return self;
}
+(instancetype)ActivityWithName:(NSString*)name andGuests:(NSMutableArray*)guests andMessages:(NSMutableArray*)messages andAttending:(NSMutableArray*)attending andID:(NSString*)actID{
    ActivityObject *object = [[ActivityObject alloc] initWithDetails:name andGuests:guests andAttending:attending andMessages:messages andID:actID];
    return object;
}

@end
