//
//  friendObject.h
//  are you down
//
//  Created by Robert Crosby on 5/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface friendObject : NSObject

+(instancetype)FriendWithName:(NSString*)name andPhone:(NSString*)phone;

@property (nonatomic, strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic, strong) NSNumber *selected;

@end
