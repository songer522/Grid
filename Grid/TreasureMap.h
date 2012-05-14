//
//  TreasureMap.h
//  Grid
//
//  Created by Yang Song on 5/7/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
typedef enum {
    TREASUREMAP_PART_ONE,
    TREASUREMAP_PART_TWO
    
} TreasureMapNumber;


@class GridView;
@interface TreasureMap : CCSprite
{
    CCSprite *_mapGraphic;
    TreasureMapNumber _partNumber;
    CGPoint _mapPosition;
 
    float _waitToPlayTreasureMapAnimation;
    float _waitToFadeOutTreasureMapBlue;
    float _waitToFadeOutTreasureMapOrange;
    GridView *_parentGridView;
}

@property  CGPoint mapPosition;
@property (retain,nonatomic)CCSprite *mapGraphic;
@property float waitToPlayTreasureMapAnimation;
@property float waitToFadeOutTreasureMapBlue;
@property float waitToFadeOutTreasureMapOrange;
@property (nonatomic,assign)GridView *parentGridView;
@property (nonatomic,assign)TreasureMapNumber partNumber;
+ (id)treasureMapAtPosition:(CGPoint)position andType:(TreasureMapNumber)part;
- (void)playHalfOpenAnimation;
- (void)playOpenAnimation;
- (void)update:(ccTime)dt;

@end
