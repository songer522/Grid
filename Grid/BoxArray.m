//
//  BoxArray.m
//  Grid
//
//  Created by Yang Song on 4/30/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "BoxArray.h"


@implementation BoxArray
+(id)BoxArrayWithNumOfBoxes:(int)numberOfBoxes
{
    return [[self alloc] initWithNumOfBoxes:numberOfBoxes];
}

-(id)initWithNumOfBoxes:(int)numberOfBoxes
{
    if ((self=[super init])) {
        
        
        self=[NSMutableArray arrayWithCapacity:numberOfBoxes];
        
        for(int x=0;x<numberOfBoxes; x++)
        {
            //NSLog(@"x:%d",x);
            [self addObject:[Box instance]];
            
        }
        
    }
    return self;
}


-(BoxInfo)checkBoxInfoAtIndex:(NSUInteger)indexNumber
{
    Box *box=[self objectAtIndex:indexNumber];
    return [box checkStatus];
}
@end
