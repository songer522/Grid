//
//  Fog.m
//  Grid
//
//  Created by Song Yang on 6/4/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "Fog.h"
#import "GridView.h"
#import "DeviceSettings.h"
@implementation Fog
@synthesize parentGridView=_parentGridView;
@synthesize fogPosition=_fogPosition;
@synthesize fogGraphic=_fogGraphic;
@synthesize waitToFadeOutFog=_waitToFadeOutFog;
@synthesize waitToPlayFogAnimation=_waitToPlayFogAnimation;


+ (id)FogAtPosition:(CGPoint)position
{
    return [[self alloc] initAtPosition:position];
}

- (id)initAtPosition:(CGPoint)position
{
    if ((self=[super init])) {
        _fogGraphic=[CCSprite spriteWithSpriteFrameName:@"Graphic_Fog_1.png"];
        
        [self setPosition:position];
        _fogPosition=position;
       
        _waitToFadeOutFog=0;
        _waitToPlayFogAnimation=0.3;
    
        [self addChild:_fogGraphic];
    }
    return self;
}

- (void)setPosition:(CGPoint)position
{
    [_fogGraphic setPosition:ccp(position.x,position.y-HD_PIXELS(2.5))];
    //[_score setPosition:position];
}

- (void)playFogAnimation
{
    CCAnimation *OpenAnimation=[CCAnimation animation];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Fog_1.png"]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Fog_2.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Fog_3.png"]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Fog_2.png" ]];
    //id OpenAnimationAction=[CCAnimate actionWithDuration:0.5 animation:OpenAnimation restoreOriginalFrame:NO];
    OpenAnimation.restoreOriginalFrame=NO;
    OpenAnimation.delayPerUnit=0.8 / OpenAnimation.frames.count;
    [_fogGraphic runAction:[[[CCAnimate alloc] initWithAnimation:OpenAnimation] autorelease]];

}



- (void)update:(ccTime)dt
{

    if(_waitToPlayFogAnimation>0)
    {
        _waitToPlayFogAnimation=_waitToPlayFogAnimation-dt;
        if(_waitToPlayFogAnimation<0)
        {
            [self playFogAnimation];
            _waitToPlayFogAnimation=1.0;
        }
    }
    
    
    if(_waitToFadeOutFog>0)
    {
        _waitToFadeOutFog=_waitToFadeOutFog-dt;
        
        if(_waitToFadeOutFog<0.2&&_waitToFadeOutFog>0)
        {
            [self.fogGraphic setOpacity:_waitToFadeOutFog*1275];
        }
        if(_waitToFadeOutFog<0)
        {
            
            [self.fogGraphic setOpacity:0];
            //[_parentGridView fillBlockAtPositionX:self.fogPosition.x PositionY:self.fogPosition.y WithColor:BLUE_BOX];
            
            
        }
    }
    
        
}
@end
