//
//  Skull.h
//  Grid
//
//  Created by Song Yang on 5/30/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GridView;
@interface Skull : CCSprite
{
    CCSprite *_skullGraphic;
    CGPoint _skullPosition;
    float _waitToPlaySkullAnimation;
    float _waitToFadeOutSkullBlue;
    float _waitToFadeOutSkullOrange;
    GridView *_parentGridView;
}

@property  CGPoint skullPosition;
@property (retain,nonatomic)CCSprite *skullGraphic;
@property float waitToPlaySkullAnimation;
@property float waitToFadeOutSkullBlue;
@property float waitToFadeOutSkullOrange;
@property (nonatomic,assign)GridView *parentGridView;
+ (id)skullAtPosition:(CGPoint)position;

- (void)playCapturedAnimation;
- (void)update:(ccTime)dt;


@end
