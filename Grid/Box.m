//
//  Box.m
//  Grid
//
//  Created by Yang Song on 4/30/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "Box.h"

@implementation Box
@synthesize status=_status;
@synthesize hasFog=_hasFog;

+(id)instance
{
    return [[self alloc] init];
}

-(id)init
{
    if ((self=[super init])) {
        _status=UNAVAILABLE;
        _hasFog=NO;
        
        
    }
    return self;
}

-(BoxInfo)checkStatus
{
    return _status;
    
}
@end
