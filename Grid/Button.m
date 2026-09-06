//
//  Button.m
//  Grid
//
//  Created by Yang Song on 5/8/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "Button.h"
#import "SimpleAudioEngine.h"

@implementation Button
@synthesize waitToFadeOutButton=_waitToFadeOutButton;
@synthesize buttonGraphic=_buttonGraphic;
@synthesize buttonPosition=_buttonPosition;
@synthesize waitToFadeInButton=_waitToFadeInButton;


+ (id)buttonAtPosition:(CGPoint)position andImage:(NSString*)image
{
    return [[self alloc] initAtPosition:position andImage:image];
}


- (id)initAtPosition:(CGPoint)position andImage:(NSString*)image
{
    if ((self=[super init])) {
        _buttonGraphic=[CCSprite spriteWithSpriteFrameName:image];
        _imageName=image;     
        [self setPosition:position];
        _buttonPosition=position;
        _waitToFadeOutButton=0;
        _waitToFadeInButton=0;
        [self addChild:_buttonGraphic];
        
    }
    return self;
}


- (void)playbuttonAnimation
{
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"menuForward.mp3"];
    CCAnimation *OpenAnimation=[CCAnimation animation];
    
    NSString *suffix=@"_Pressed.png";
    NSString *tempString=_imageName;
    NSString *aString=[tempString stringByDeletingPathExtension];

     //NSLog(@"%@",aString);
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_imageName]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[aString stringByAppendingString:suffix] ]];
      [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_imageName]];

 
    //id OpenAnimationAction=[CCAnimate actionWithDuration:0.5 animation:OpenAnimation restoreOriginalFrame:NO];
    OpenAnimation.restoreOriginalFrame=NO;
    OpenAnimation.delayPerUnit=0.5 / OpenAnimation.frames.count;
    [_buttonGraphic runAction:[[[CCAnimate alloc] initWithAnimation:OpenAnimation] autorelease]];
}


- (void)playIconAnimation
{
    
    //[[SimpleAudioEngine sharedEngine] playEffect:@"menuForward.mp3"];
    CCAnimation *OpenAnimation=[CCAnimation animation];
    
    NSString *suffix=@"_Pressed.png";
    NSString *tempString=_imageName;
    NSString *aString=[tempString stringByDeletingPathExtension];
    
    //NSLog(@"%@",aString);
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_imageName]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[aString stringByAppendingString:suffix] ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_imageName]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[aString stringByAppendingString:suffix] ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_imageName]];
    
    //id OpenAnimationAction=[CCAnimate actionWithDuration:0.5 animation:OpenAnimation restoreOriginalFrame:NO];
    OpenAnimation.restoreOriginalFrame=NO;
    OpenAnimation.delayPerUnit=0.8 / OpenAnimation.frames.count;
    [_buttonGraphic runAction:[[[CCAnimate alloc] initWithAnimation:OpenAnimation] autorelease]];
}



- (void)update:(ccTime)dt
{
    if(_waitToFadeOutButton>0)
    {
        _waitToFadeOutButton=_waitToFadeOutButton-dt;
        
        if(_waitToFadeOutButton<0.5&&_waitToFadeOutButton>0)
        {
            [_buttonGraphic setOpacity:_waitToFadeOutButton*510];
           
        }
        if(_waitToFadeOutButton<1&&_waitToFadeOutButton>0)
        {
             //[_buttonGraphic setScale:_waitToFadeInButton*1];
        }
        if(_waitToFadeOutButton<0)
        {
            
            [_buttonGraphic setOpacity:0];
            //[_buttonGraphic setScale:0];
           
            
            
        }
    }

    
    if(_waitToFadeInButton>0)
    {
        _waitToFadeInButton=_waitToFadeInButton-dt;
        if(_waitToFadeInButton<0.5&&_waitToFadeInButton>0)
        [_buttonGraphic setOpacity:(0.5-_waitToFadeInButton)*510]; 
        if(_waitToFadeInButton<0)
        {
            [_buttonGraphic setOpacity:255];
            //_waitToFadeOutButton=3.0;
        }
    }

    
}

@end
