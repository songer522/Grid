//
//  TreasureBox.m
//  Grid
//
//  Created by Yang Song on 4/25/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//


#import "TreasureBox.h"
#import "GridView.h"
@implementation TreasureBox
@synthesize parentGridView=_parentGridView;
@synthesize boxPosition=_boxPosition;
@synthesize boxGraphic=_boxGraphic;
@synthesize waitToFadeOutTreasureBoxBlue=_waitToFadeOutTreasureBoxBlue;
@synthesize waitToFadeOutTreasureBoxOrange=_waitToFadeOutTreasureBoxOrange;
@synthesize waitToPlayTreasureBoxAnimation=_waitToPlayTreasureBoxAnimation;

+ (id)treasureBoxAtPosition:(CGPoint)position
{
    return [[self alloc] initAtPosition:position];
}

- (id)initAtPosition:(CGPoint)position
{
    if ((self=[super init])) {
        _boxGraphic=[CCSprite spriteWithSpriteFrameName:@"Graphic_TBox_1.png"];
        
        [self setPosition:position];
        _boxPosition=position;
        _waitToPlayTreasureBoxAnimation=0.3;
        _waitToFadeOutTreasureBoxBlue=0;
        _waitToFadeOutTreasureBoxOrange=0;
        [self addChild:_boxGraphic];
    }
    return self;
}

- (void)setPosition:(CGPoint)position
{
    [_boxGraphic setPosition:position];
    //[_score setPosition:position];
}

- (void)playHalfOpenAnimation
{
    CCAnimation *halfOpenAnimation=[CCAnimation animation];
    [halfOpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TBox_1.png"]];
    [halfOpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TBox_2.png" ]];
    [halfOpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TBox_3.png"]];
   // id halfOpenAnimationAction=[CCAnimate actionWithDuration:0.75 animation:halfOpenAnimation restoreOriginalFrame:NO];
    
    
    halfOpenAnimation.restoreOriginalFrame=NO;
    halfOpenAnimation.delayPerUnit =  0.5 / halfOpenAnimation.frames.count;
    [_boxGraphic runAction:[[[CCAnimate alloc] initWithAnimation:halfOpenAnimation] autorelease]];

}

- (void)playOpenAnimation
{
    CCAnimation *OpenAnimation=[CCAnimation animation];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TBox_1.png"]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TBox_2.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TBox_3.png"]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TBox_4.png" ]];
    //id OpenAnimationAction=[CCAnimate actionWithDuration:0.5 animation:OpenAnimation restoreOriginalFrame:NO];
    OpenAnimation.restoreOriginalFrame=NO;
    OpenAnimation.delayPerUnit=0.5 / OpenAnimation.frames.count;
    [_boxGraphic runAction:[[[CCAnimate alloc] initWithAnimation:OpenAnimation] autorelease]];
    
    //[_boxGraphic setVisible:NO];
    
}

- (void)update:(ccTime)dt
{
    if(_waitToPlayTreasureBoxAnimation>0)
    {
        _waitToPlayTreasureBoxAnimation=_waitToPlayTreasureBoxAnimation-dt;
        if(_waitToPlayTreasureBoxAnimation<0)
        {
            [self playHalfOpenAnimation];
            _waitToPlayTreasureBoxAnimation=2.0;
        }
    }
    
    if(_waitToFadeOutTreasureBoxBlue>0)
    {
        _waitToFadeOutTreasureBoxBlue=_waitToFadeOutTreasureBoxBlue-dt;
        
        if(_waitToFadeOutTreasureBoxBlue<0.5&&_waitToFadeOutTreasureBoxBlue>0)
        {
            [self.boxGraphic setOpacity:_waitToFadeOutTreasureBoxBlue*510];
        }
        if(_waitToFadeOutTreasureBoxBlue<0)
        {
           
            [self.boxGraphic setOpacity:0];
            [_parentGridView fillBlockAtPositionX:self.boxPosition.x PositionY:self.boxPosition.y WithColor:BLUE_BOX];
         
            
        }
    }
    
    if(_waitToFadeOutTreasureBoxOrange>0)
    {
        _waitToFadeOutTreasureBoxOrange=_waitToFadeOutTreasureBoxOrange-dt;
        
        
        if(_waitToFadeOutTreasureBoxOrange<0.5 && _waitToFadeOutTreasureBoxOrange>0)
        {
            [self.boxGraphic setOpacity:_waitToFadeOutTreasureBoxOrange*510];
        }
        
        if(_waitToFadeOutTreasureBoxOrange<0)
        {
           
            [self.boxGraphic setOpacity:0];
            [_parentGridView fillBlockAtPositionX:self.boxPosition.x PositionY:self.boxPosition.y WithColor:ORANGE_BOX];
           
            
        }
    }

}
@end
