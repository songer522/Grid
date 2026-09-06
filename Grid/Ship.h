//
//  Ship.h
//  Grid
//
//  Created by Yang Song on 5/2/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class GridView;

@interface Ship : CCSprite
{
    CCSprite *_shipGraphic;
    CGPoint _shipPosition;
    float _waitToFadeOutShipBlue;
    float _waitToFadeOutShipOrange;
    float _waitToPlayShipAnimation;
    GridView *_parentGridView;
    BOOL _isFlip;
}
@property CGPoint shipPosition;
@property (retain,nonatomic)CCSprite *shipGraphic;

@property float waitToFadeOutShipBlue;
@property float waitToFadeOutShipOrange;
@property float waitToPlayShipAnimation;
@property (nonatomic,assign)GridView *parentGridView;
@property BOOL isFlip;

+ (id)shipAtPosition:(CGPoint)position Flip:(BOOL)FlipX;
- (void)moveShip;
- (void)playShipFastAnimation;
- (void)update:(ccTime)dt;
@end
