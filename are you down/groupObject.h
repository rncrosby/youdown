//
//  groupObject.h
//  are you down
//
//  Created by Robert Crosby on 5/18/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface groupObject : NSObject

+(instancetype)GroupWithName:(NSString*)name andMembers:(NSMutableArray*)members;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, strong) NSNumber *selected;


@end
