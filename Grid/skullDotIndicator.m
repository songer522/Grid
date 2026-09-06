//
//  skullDotIndicator.m
//  Grid
//
//  Created by Song Yang on 5/31/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "skullDotIndicator.h"
#import "DeviceSettings.h"

@implementation skullDotIndicator



+(id)skullDotIndicatorWithNumberOfDots:(int)number AndPosition:(CGPoint)position CurrentPage:(int)currentPage
{
    return [[self alloc] initWithNumberOfDots:number AndPosition:position CurrentPage:currentPage];
}

-(id)initWithNumberOfDots:(int)number AndPosition:(CGPoint)position CurrentPage:(int)currentPage
{
     if ((self=[super init])) {
    _dotArray=[[NSMutableArray alloc] init];
    for (int i=0; i<number; i++) {
        if(i==currentPage)
        {
           CCSprite *dot=[CCSprite spriteWithSpriteFrameName:@"Graphic_PageDot_L.png"]; 
             [dot setPosition:ccp(position.x-(((number-1)*HD_PIXELS(30))/2)+i*HD_PIXELS(30),position.y)];
            [_dotArray addObject:dot];
            [self addChild:dot];
        }
        else
        {
        CCSprite *dot=[CCSprite spriteWithSpriteFrameName:@"Graphic_PageDot_S.png"];
               [dot setPosition:ccp(position.x-(((number-1)*HD_PIXELS(30))/2)+i*HD_PIXELS(30),position.y)];
             [_dotArray addObject:dot];
            [self addChild:dot];
        }
       
    }
     }
    return self;
}

-(void)changeDotForPage:(int)pageNumber
{
for(CCSprite *obj in _dotArray)
{
    if([_dotArray indexOfObject:obj]==pageNumber)
    {
        [obj setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_PageDot_L.png"]]; 
    }
    else {
        [obj setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_PageDot_S.png"]]; 
    }
        
}
}
@end
