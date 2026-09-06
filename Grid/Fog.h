//
//  Fog.h
//  Grid
//
//  Created by Song Yang on 6/4/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GridView;
@interface Fog : CCSprite
{
    CCSprite *_fogGraphic;
    CGPoint _fogPosition;
  
    float _waitToFadeOutFog;
    float _waitToPlayFogAnimation;
    GridView *_parentGridView;
    
}

@property  CGPoint fogPosition;
@property (retain,nonatomic)CCSprite *fogGraphic;

@property float waitToFadeOutFog;
@property float waitToPlayFogAnimation;

@property (nonatomic,assign)GridView *parentGridView;
+ (id)FogAtPosition:(CGPoint)position;
- (void)playFogAnimation;

- (void)update:(ccTime)dt;
@end
