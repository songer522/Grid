//
//  TreasureBox.h
//  Grid
//
//  Created by Yang Song on 4/25/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@class GridView;
@interface TreasureBox : CCSprite
{
     CCSprite *_boxGraphic;
    CGPoint _boxPosition;
    float _waitToPlayTreasureBoxAnimation;
    float _waitToFadeOutTreasureBoxBlue;
    float _waitToFadeOutTreasureBoxOrange;
    GridView *_parentGridView;
    
}

@property  CGPoint boxPosition;
@property (retain,nonatomic)CCSprite *boxGraphic;
@property float waitToPlayTreasureBoxAnimation;
@property float waitToFadeOutTreasureBoxBlue;
@property float waitToFadeOutTreasureBoxOrange;
@property (nonatomic,assign)GridView *parentGridView;
+ (id)treasureBoxAtPosition:(CGPoint)position;
- (void)playHalfOpenAnimation;
- (void)playOpenAnimation;
- (void)update:(ccTime)dt;
@end
