//
//  EdgeArray.m
//  grid
//
//  Created by Yang Song on 4/5/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "EdgeArray.h"
#import "Edge.h"

@implementation EdgeArray


+(id)EdgeArrayWithNumOfEdges:(int)numberOfEdges
{
    
    return [[self alloc] initWithNumOfEdges:numberOfEdges];
}

-(id)initWithNumOfEdges:(int)numberOfEdges
{
    if ((self=[super init])) {
      
        
        self=[NSMutableArray arrayWithCapacity:numberOfEdges];
        
        for(int x=0;x<numberOfEdges; x++)
        {
            //NSLog(@"x:%d",x);
            [self addObject:[Edge instance]];
           
        }
               
    }
    return self;
}


-(BOOL)checkEdgeFilledAtIndex:(NSUInteger)indexNumber
{
    Edge *edge=[self objectAtIndex:indexNumber];
    return [edge checkFiled];
    
}
@end
