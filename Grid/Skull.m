//
//  Skull.m
//  Grid
//
//  Created by Song Yang on 5/30/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "Skull.h"
#import "GridView.h"
@implementation Skull

@synthesize parentGridView=_parentGridView;
@synthesize skullPosition=_skullPosition;
@synthesize skullGraphic=_skullGraphic;
@synthesize waitToFadeOutSkullBlue=_waitToFadeOutSkullBlue;
@synthesize waitToFadeOutSkullOrange=_waitToFadeOutSkullOrange;
@synthesize waitToPlaySkullAnimation=_waitToPlaySkullAnimation;
+ (id)skullAtPosition:(CGPoint)position
{
    return [[self alloc] initAtPosition:position];
}

- (id)initAtPosition:(CGPoint)position
{
    if ((self=[super init])) {
        _skullGraphic=[CCSprite spriteWithSpriteFrameName:@"Graphic_Skull.png"];
        
        [self setPosition:position];
        _skullPosition=position;
        _waitToPlaySkullAnimation=0.3;
        _waitToFadeOutSkullBlue=0;
        _waitToFadeOutSkullOrange=0;
        [self addChild:_skullGraphic];
    }
    return self;
}

- (void)setPosition:(CGPoint)position
{
    [_skullGraphic setPosition:position];
    //[_score setPosition:position];
}



- (void)playCapturedAnimation
{
    CCAnimation *OpenAnimation=[CCAnimation animation];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TBox_1.png"]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TBox_2.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TBox_3.png"]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TBox_4.png" ]];
    //id OpenAnimationAction=[CCAnimate actionWithDuration:0.5 animation:OpenAnimation restoreOriginalFrame:NO];
    OpenAnimation.restoreOriginalFrame=NO;
    OpenAnimation.delayPerUnit=0.5 / OpenAnimation.frames.count;
    [_skullGraphic runAction:[[[CCAnimate alloc] initWithAnimation:OpenAnimation] autorelease]];
    
    //[_boxGraphic setVisible:NO];
    
}

- (void)update:(ccTime)dt
{
       
    if(_waitToFadeOutSkullBlue>0)
    {
        _waitToFadeOutSkullBlue=_waitToFadeOutSkullBlue-dt;
        
        if(_waitToFadeOutSkullBlue<0.5&&_waitToFadeOutSkullBlue>0)
        {
            [self.skullGraphic setOpacity:_waitToFadeOutSkullBlue*510];
        }
        if(_waitToFadeOutSkullBlue<0)
        {
            
            [self.skullGraphic setOpacity:0];
            [_parentGridView fillBlockAtPositionX:self.skullPosition.x PositionY:self.skullPosition.y WithColor:BLUE_BOX];
            
            
        }
    }
    
    if(_waitToFadeOutSkullOrange>0)
    {
        _waitToFadeOutSkullOrange=_waitToFadeOutSkullOrange-dt;
        
        
        if(_waitToFadeOutSkullOrange<0.5 && _waitToFadeOutSkullOrange>0)
        {
            [self.skullGraphic setOpacity:_waitToFadeOutSkullOrange*510];
        }
        
        if(_waitToFadeOutSkullOrange<0)
        {
            
            [self.skullGraphic setOpacity:0];
            [_parentGridView fillBlockAtPositionX:self.skullPosition.x PositionY:self.skullPosition.y WithColor:ORANGE_BOX];
            
            
        }
    }
    
}

@end
