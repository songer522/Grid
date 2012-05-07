//
//  Ship.m
//  Grid
//
//  Created by Yang Song on 5/2/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "Ship.h"
#import "MapSettings.h"
#import "DeviceSettings.h"
#import "GridView.h"
@implementation Ship
@synthesize parentGridView=_parentGridView;
@synthesize shipGraphic=_shipGraphic;
@synthesize shipPosition=_shipPosition;
@synthesize waitToFadeOutShipBlue=_waitToFadeOutShipBlue;
@synthesize waitToFadeOutShipOrange=_waitToFadeOutShipOrange;
@synthesize waitToPlayShipAnimation=_waitToPlayShipAnimation;
@synthesize isFlip=_isFlip;

+ (id)shipAtPosition:(CGPoint)position Flip:(BOOL)FlipX
{
    return [[self alloc] initAtPosition:position Flip:FlipX];
}

- (id)initAtPosition:(CGPoint)position Flip:(BOOL)FlipX
{
    if ((self=[super init])) {
        _isFlip=NO;
        _shipGraphic=[CCSprite spriteWithSpriteFrameName:@"Graphic_Ship_1.png"];
        _shipPosition=position;
        _waitToPlayShipAnimation=0.1;
        //[_shipGraphic setVisible:NO];
        if(!FlipX)
        {
            //[_shipGraphic setPosition:ccp((position.x-0.6*EDGE_LENGTH),(position.y+0.1*EDGE_LENGTH))];
            [_shipGraphic setPosition:position];
        }
        else {
            _isFlip=YES;
            //[_shipGraphic setPosition:ccp((position.x+0.6*EDGE_LENGTH),(position.y+0.1*EDGE_LENGTH))];
            [_shipGraphic setPosition:position];
           
            [_shipGraphic setFlipX:YES];
           
        }
        [self addChild:_shipGraphic];
  
    }
    return self;
}

- (void)moveShip
{
    if(!_isFlip)
    {
    id moveAction=[CCMoveTo actionWithDuration:2.5 position:ccp(_shipPosition.x+ADJUST_X(350),_shipPosition.y)];
        [_shipGraphic runAction:moveAction];
    }
    else {
        id moveAction=[CCMoveTo actionWithDuration:2.5 position:ccp(_shipPosition.x-ADJUST_X(350),_shipPosition.y)];
        [_shipGraphic runAction:moveAction];
    }
}
- (void)playShipAnimation
{
    CCAnimation *shipAnimation=[CCAnimation animation];
    [shipAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Ship_1.png"]];
    [shipAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Ship_2.png" ]];
    [shipAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Ship_3.png"]];
        
    
    //id cannonAnimationAction=[CCAnimate actionWithDuration:0.5 animation:cannonAnimation restoreOriginalFrame:NO];
    
    shipAnimation.restoreOriginalFrame=NO;
    shipAnimation.delayPerUnit=1.2/shipAnimation.frames.count;
    
    [_shipGraphic runAction:[[[CCAnimate alloc] initWithAnimation:shipAnimation] autorelease]];
}

- (void)playShipFastAnimation
{
    CCAnimation *shipAnimation=[CCAnimation animation];
    [shipAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Ship_1.png"]];
    [shipAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Ship_2.png" ]];
    [shipAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Ship_3.png"]];
    [shipAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Ship_1.png"]];
    [shipAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Ship_2.png" ]];
    [shipAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Ship_3.png"]];
    [shipAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Ship_1.png"]];
    [shipAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Ship_2.png" ]];
    [shipAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Ship_3.png"]];
    
    
    //id cannonAnimationAction=[CCAnimate actionWithDuration:0.5 animation:cannonAnimation restoreOriginalFrame:NO];
    
    shipAnimation.restoreOriginalFrame=NO;
    shipAnimation.delayPerUnit=1.8/shipAnimation.frames.count;
    
    [_shipGraphic runAction:[[[CCAnimate alloc] initWithAnimation:shipAnimation] autorelease]];
}
- (void)update:(ccTime)dt
{
    if(_waitToPlayShipAnimation>0)
    {
        _waitToPlayShipAnimation=_waitToPlayShipAnimation-dt;
        if(_waitToPlayShipAnimation<0)
        {
            [self playShipAnimation];
            _waitToPlayShipAnimation=1.2;
        }
    }

    
    
    if(_waitToFadeOutShipBlue>0)
    {
        _waitToFadeOutShipBlue=_waitToFadeOutShipBlue-dt;
        
        
        if(_waitToFadeOutShipBlue<0.5 && _waitToFadeOutShipBlue>0)
        {
            [_shipGraphic setOpacity:_waitToFadeOutShipBlue*510];
            
        }
        
        if(_waitToFadeOutShipBlue<0)
        {
            [_shipGraphic setOpacity:0];
            [_parentGridView fillBlockAtPositionX:_shipPosition.x PositionY:_shipPosition.y WithColor:BLUE_BOX];
            
            // _parentGridView.secondBoxPositionX=self.cannonPosition.x;
            //_parentGridView.secondBoxPositionY=self.cannonPosition.y;
            //_parentGridView.waitToShowSecondBoxBlue=0.5;
        }
    }
    
    if(_waitToFadeOutShipOrange>0)
    {
        _waitToFadeOutShipOrange=_waitToFadeOutShipOrange-dt;
        
        if(_waitToFadeOutShipOrange<0.5 && _waitToFadeOutShipOrange>0)
        {
            [_shipGraphic setOpacity:_waitToFadeOutShipOrange*510];
        }
        
        if(_waitToFadeOutShipOrange<0)
        {
            [_shipGraphic setOpacity:0];
            
            [_parentGridView fillBlockAtPositionX:_shipPosition.x PositionY:_shipPosition.y WithColor:ORANGE_BOX];
            // _parentGridView.secondBoxPositionX=self.cannonPosition.x;
            //_parentGridView.secondBoxPositionY=self.cannonPosition.y;
            //_parentGridView.waitToShowSecondBoxOrange=0.5;
        }
    }

}

@end
