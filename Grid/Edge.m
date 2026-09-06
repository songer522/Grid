//
//  Edge.m
//  grid
//
//  Created by Yang Song on 4/5/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "Edge.h"

@implementation Edge
@synthesize isFilled=_isFilled;
@synthesize edgeIndex=_edgeIndex;
@synthesize rowOrLine=_rowOrLine;
@synthesize rowOrLineIndex=_rowOrLineIndex;

+(id)instance
{
    return [[self alloc] init];
}

-(id)init
{
     if ((self=[super init])) {
         _isFilled=YES;
        
        
     }
    return self;
}

-(BOOL)checkFiled
{
    return _isFilled;
    
}

@end
