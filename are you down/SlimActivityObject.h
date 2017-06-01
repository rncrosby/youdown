//
//  SlimActivityObject.h
//  are you down
//
//  Created by Robert Crosby on 5/29/17.
//  Copyright © 2017 Robert Crosby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlimActivityObject : NSObject

+(instancetype)SlimActivityWithName:(NSString*)name andCreator:(NSString*)guests andID:(NSString*)actID;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *actID;
@property (nonatomic, strong) NSString *creator;

@end
