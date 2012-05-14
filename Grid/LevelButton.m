//
//  LevelButton.m
//  Grid
//
//  Created by Yang Song on 5/3/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "LevelButton.h"
#import "GameSettings.h"
#import "GameLayer.h"
#import "DeviceSettings.h"


@implementation LevelButton
@synthesize buttonId=_buttonId;

+(id)levelButtonWithId:(int)buttonId
{
    return [[self alloc] initWithId:buttonId];
}

-(id)initWithId:(int)buttonId
{
    if ((self=[super init])) {
        _buttonId = buttonId;
       
        [self initButton];
    }        
    return self;    
}


-(void)initButton
{
      
   NSString *unlockedValue = [[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"level%d",_buttonId]];
    if ([unlockedValue isEqualToString:@"YES"])
    {
                _buttonGraphic=[CCSprite spriteWithSpriteFrameName:@"Graphic_LevelBack.png"];
        _levelNumber=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_buttonId] fontName:@"Marker Felt" fontSize: HD_TEXT(38)];

         // [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
       [self addChild:_buttonGraphic];
        [self addChild:_levelNumber];
    }
    else {
        _buttonGraphic=[CCSprite spriteWithSpriteFrameName:@"Graphic_LevelLocked.png"];
         [self addChild:_buttonGraphic];
    }
    
            
   
        
  
}
-(void)setPosition:(CGPoint)position
{
    [_buttonGraphic setPosition:position];
    [_levelNumber setPosition:position];
    _buttonPosition=position;
    
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    
  if ( [self checkTouchAtPosition:touchOrigin2])
  {
      [self ButtonPressed];
  }
    
    
    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    return; 
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    return;
}




-(void)ButtonPressed
{
    NSString *unlockedValue = [[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"level%d",_buttonId]];
    
    NSString *levelNumber=[NSString stringWithFormat:@"%d",_buttonId];
    [[GameSettings shared] setGlobal:levelNumber ForKey:@"selectedLevel"];
    
    
    
    if ([unlockedValue isEqualToString:@"YES"])
    {
    CCAnimation *buttonAnimation=[CCAnimation animation];
    [buttonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_Level.png"]];
    [buttonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_LevelPressed.png" ]];
        buttonAnimation.restoreOriginalFrame=YES;
    buttonAnimation.delayPerUnit=0.1/buttonAnimation.frames.count;
    [_buttonGraphic runAction:[[[CCAnimate alloc] initWithAnimation:buttonAnimation] autorelease]];
        
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[GameLayer scene]]]; 

    }
    
}

-(BOOL)checkTouchAtPosition:(CGPoint)point
{
    if(abs(point.x-_buttonPosition.x)<20&&abs(point.y-_buttonPosition.y)<20 )
    {
        return YES;
    }
    else {
        return NO;
    }
}

@end
