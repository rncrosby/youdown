//
//  ActivityObject.h
//  are you down
//
//  Created by Robert Crosby on 5/25/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>
# import "References.h"

@interface ActivityObject : NSObject

+(instancetype)ActivityWithName:(NSString*)name andGuests:(NSMutableArray*)guests andMessages:(NSMutableArray*)messages andAttending:(NSMutableArray*)attending andID:(NSString*)actID andNames:(NSMutableArray*)guestNames andCreator:(NSString*)creator andTime:(NSNumber*)time;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *actID;
@property (nonatomic, strong) NSString *creator;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSMutableArray *guests;
@property (nonatomic, strong) NSMutableArray *guestNames;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *attending;

@end
