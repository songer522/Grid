//
//  Cannon.m
//  Grid
//
//  Created by Yang Song on 4/26/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "Cannon.h"
#import "MapSettings.h"
#import "DeviceSettings.h"
#import "GridView.h"
@implementation Cannon
@synthesize parentGridView=_parentGridView;
@synthesize cannonPosition=_cannonPosition;
@synthesize cannonGraphic=_cannonGraphic;
@synthesize cannonBallGraphic=_cannonBallGraphic;
@synthesize waitToFadeOutCannonBlue=_waitToFadeOutCannonBlue;
@synthesize waitToFadeOutCannonOrange=_waitToFadeOutCannonOrange;
@synthesize isFlip=_isFlip;
+ (id)cannonAtPosition:(CGPoint)position Flip:(BOOL)FlipX
{
    return [[self alloc] initAtPosition:position Flip:FlipX];
}


- (id)initAtPosition:(CGPoint)position Flip:(BOOL)FlipX
{
    if ((self=[super init])) {
        _isFlip=NO;
        _waitToMoveCannon=0.1;
        _cannonGraphic=[CCSprite spriteWithSpriteFrameName:@"Graphic_Cannon_1.png"];
        _cannonBallGraphic=[CCSprite spriteWithSpriteFrameName:@"Graphic_Artillery_1.png"];
        _cannonPosition=position;
         [_cannonBallGraphic setVisible:NO];
        if(!FlipX)
        {
        [_cannonGraphic setPosition:ccp((position.x-0.6*EDGE_LENGTH),(position.y+0.1*EDGE_LENGTH))];
        [_cannonBallGraphic setPosition:ccp((_cannonPosition.x-0.6*EDGE_LENGTH),(_cannonPosition.y+0.1*EDGE_LENGTH))];
        }
        else {
            _isFlip=YES;
            [_cannonGraphic setPosition:ccp((position.x+0.6*EDGE_LENGTH),(position.y+0.1*EDGE_LENGTH))];
            [_cannonBallGraphic setPosition:ccp((_cannonPosition.x+0.6*EDGE_LENGTH),(_cannonPosition.y+0.1*EDGE_LENGTH))];
            [_cannonGraphic setFlipX:YES];
            [_cannonBallGraphic setFlipX:YES];
        }
        [self addChild:_cannonBallGraphic];
        [self addChild:_cannonGraphic];
    }
    return self;
}

- (void)playCannonMovingAnimation
{
    CCAnimation *cannonAnimation=[CCAnimation animation];
    [cannonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Cannon_1.png"]];
    [cannonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Cannon_2.png" ]];
    [cannonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Cannon_3.png"]];
    [cannonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Cannon_4.png"]];
  
    
    //id cannonAnimationAction=[CCAnimate actionWithDuration:0.5 animation:cannonAnimation restoreOriginalFrame:NO];

    cannonAnimation.restoreOriginalFrame=NO;
    cannonAnimation.delayPerUnit=0.8/cannonAnimation.frames.count;
    
    [_cannonGraphic runAction:[[[CCAnimate alloc] initWithAnimation:cannonAnimation] autorelease]];

}
- (void)playCannonShootingAnimation
{
    
    
    CCAnimation *cannonAnimation=[CCAnimation animation];
    [cannonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Artillery_1.png"]];
    [cannonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Artillery_2.png" ]];
    [cannonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Artillery_3.png"]];
    [cannonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Artillery_4.png"]];
    [cannonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Explode_1.png" ]];
    [cannonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Explode_2.png"]];
    [cannonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Explode_3.png"]];
    [cannonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Explode_4.png" ]];
     [cannonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Explode_5.png" ]];
  
    //id cannonAnimationAction=[CCAnimate actionWithDuration:0.5 animation:cannonAnimation restoreOriginalFrame:NO];
    cannonAnimation.restoreOriginalFrame=NO;
    cannonAnimation.delayPerUnit=0.5/cannonAnimation.frames.count;
    [_cannonBallGraphic setVisible:YES];
    
    [_cannonBallGraphic runAction:[[[CCAnimate alloc] initWithAnimation:cannonAnimation] autorelease]];
}

- (void)update:(ccTime)dt
{
    
    if(_waitToMoveCannon>0)
    {
        _waitToMoveCannon=_waitToMoveCannon-dt;
        if(_waitToMoveCannon<0)
        {
            [self playCannonMovingAnimation];
            _waitToMoveCannon=0.8;
        }
    }

    
    
if(_waitToFadeOutCannonBlue>0)
{
    _waitToFadeOutCannonBlue=_waitToFadeOutCannonBlue-dt;
    
    
    if(_waitToFadeOutCannonBlue<0.5 && _waitToFadeOutCannonBlue>0)
    {
        [self.cannonGraphic setOpacity:_waitToFadeOutCannonBlue*510];
        [self.cannonBallGraphic setOpacity:_waitToFadeOutCannonBlue*510];
    }
    
    if(_waitToFadeOutCannonBlue<0)
    {
        [self.cannonGraphic setOpacity:0];
        [self.cannonBallGraphic setOpacity:0];
        [_parentGridView fillBlockAtPositionX:self.cannonPosition.x PositionY:self.cannonPosition.y WithColor:BLUE_BOX];
        
       // _parentGridView.secondBoxPositionX=self.cannonPosition.x;
        //_parentGridView.secondBoxPositionY=self.cannonPosition.y;
        //_parentGridView.waitToShowSecondBoxBlue=0.5;
    }
}

if(_waitToFadeOutCannonOrange>0)
{
    _waitToFadeOutCannonOrange=_waitToFadeOutCannonOrange-dt;
    
    if(_waitToFadeOutCannonOrange<0.5 && _waitToFadeOutCannonOrange>0)
    {
        [self.cannonGraphic setOpacity:_waitToFadeOutCannonOrange*510];
        [self.cannonBallGraphic setOpacity:_waitToFadeOutCannonOrange*510];
    }
    
    if(_waitToFadeOutCannonOrange<0)
    {
        [self.cannonGraphic setOpacity:0];
        [self.cannonBallGraphic setOpacity:0];
        [_parentGridView fillBlockAtPositionX:self.cannonPosition.x PositionY:self.cannonPosition.y WithColor:ORANGE_BOX];
       // _parentGridView.secondBoxPositionX=self.cannonPosition.x;
        //_parentGridView.secondBoxPositionY=self.cannonPosition.y;
        //_parentGridView.waitToShowSecondBoxOrange=0.5;
    }
}
}

@end
