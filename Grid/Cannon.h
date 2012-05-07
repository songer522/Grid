//
//  Cannon.h
//  Grid
//
//  Created by Yang Song on 4/26/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
@class GridView;
@interface Cannon : CCSprite

{
    CCSprite *_cannonGraphic;
    CCSprite *_cannonBallGraphic;
    CGPoint _cannonPosition;
    float _waitToFadeOutCannonBlue;
    float _waitToFadeOutCannonOrange;
    float _waitToMoveCannon;
    GridView *_parentGridView;
    BOOL _isFlip;
}
@property CGPoint cannonPosition;
@property (retain,nonatomic)CCSprite *cannonGraphic;
@property (retain,nonatomic)CCSprite *cannonBallGraphic;
@property float waitToFadeOutCannonBlue;
@property float waitToFadeOutCannonOrange;
@property (nonatomic,assign)GridView *parentGridView;
@property BOOL isFlip;
+ (id)cannonAtPosition:(CGPoint)position Flip:(BOOL)FlipX;
- (void)playCannonMovingAnimation;
- (void)playCannonShootingAnimation;
- (void)update:(ccTime)dt;
@end
