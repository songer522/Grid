//
//  TreasureMap.m
//  Grid
//
//  Created by Yang Song on 5/7/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "TreasureMap.h"
#import "GridView.h"

@implementation TreasureMap
@synthesize mapGraphic=_mapGraphic;
@synthesize mapPosition=_mapPosition;
@synthesize waitToFadeOutTreasureMapBlue=_waitToFadeOutTreasureMapBlue;
@synthesize waitToFadeOutTreasureMapOrange=_waitToFadeOutTreasureMapOrange;
@synthesize waitToPlayTreasureMapAnimation=_waitToPlayTreasureMapAnimation;
@synthesize parentGridView=_parentGridView;
@synthesize partNumber=_partNumber;
+ (id)treasureMapAtPosition:(CGPoint)position andType:(TreasureMapNumber)part
{
    return [[self alloc] initAtPosition:position andType:part];
}

- (id)initAtPosition:(CGPoint)position andType:(TreasureMapNumber)part
{
    if ((self=[super init])) {
       
        _partNumber=part;
        if(part==TREASUREMAP_PART_ONE)
        {
         _mapGraphic=[CCSprite spriteWithSpriteFrameName:@"Graphic_Map_1.png"];
        }
        else if(part==TREASUREMAP_PART_TWO)
        {
            _mapGraphic=[CCSprite spriteWithSpriteFrameName:@"Graphic_Map_2.png"];
        }
        [self setPosition:position];
        _mapPosition=position;
        _waitToPlayTreasureMapAnimation=0.3;
        _waitToFadeOutTreasureMapBlue=0;
        _waitToFadeOutTreasureMapOrange=0;
        [self addChild:_mapGraphic];
    }
    return self;
}
- (void)setPosition:(CGPoint)position
{
    [_mapGraphic setPosition:position];
    //[_score setPosition:position];
}

- (void)playHalfOpenAnimation
{
    
}
- (void)playOpenAnimation
{
    
}
- (void)update:(ccTime)dt
{
    
}
@end
