//
//  ChooseLevelMenu.m
//  Grid
//
//  Created by Yang Song on 5/3/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "ChooseLevelMenu.h"
#import "DeviceSettings.h"
#import "LevelButton.h"
#import "GameSettings.h"

@implementation ChooseLevelMenu
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ChooseLevelMenu *layer = [ChooseLevelMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init])) {
		
		
		// ask director the the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
        
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spriteSheet.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"background.plist" ];
               
        CCSprite *background=[CCSprite spriteWithSpriteFrameName:@"Graphic_Background.png"];
        [background setPosition:ADJUST_CCP(ccp(160,240))];
      [[GameSettings shared] setGlobal:@"YES" ForKey:@"level1"];
         [[GameSettings shared] setGlobal:@"NO" ForKey:@"level2"];
         [[GameSettings shared] setGlobal:@"NO" ForKey:@"level3"];
         [[GameSettings shared] setGlobal:@"NO" ForKey:@"level4"];
         [[GameSettings shared] setGlobal:@"NO" ForKey:@"level5"];
        LevelButton *button1=[LevelButton levelButtonWithId:1];
        LevelButton *button2=[LevelButton levelButtonWithId:2];
        LevelButton *button3=[LevelButton levelButtonWithId:3];
        LevelButton *button4=[LevelButton levelButtonWithId:4];
         LevelButton *button5=[LevelButton levelButtonWithId:5];
        [button1 setPosition:ADJUST_CCP(ccp(40,400))];
         [button2 setPosition:ADJUST_CCP(ccp(120,400))];
        [button3 setPosition:ADJUST_CCP(ccp(200,400))];
        [button4 setPosition:ADJUST_CCP(ccp(280,400))];
        [button5 setPosition:ADJUST_CCP(ccp(40,320))];
       
        [self addChild: background];
        [self addChild:button1];
        [self addChild:button2];
        [self addChild:button3];
        [self addChild:button4];
        [self addChild:button5];
       // [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        //[self schedule:@selector(update:)];
        
		        
	}
	return self;
}


@end
