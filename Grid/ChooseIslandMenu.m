//
//  ChooseIslandMenu.m
//  Grid
//
//  Created by Yang Song on 5/29/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "ChooseIslandMenu.h"
#import "DeviceSettings.h"
#import "LevelButton.h"
#import "GameSettings.h"
#import "TextField.h"
#import "MainMenu.h"
#import "UpgradeMenu.h"
#import "GameLayer.h"
#import "InAppPurchaseManager.h"
#import "IslandWindow.h"
#import "ChooseLevelMenu.h"

@implementation ChooseIslandMenu

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ChooseIslandMenu *layer = [ChooseIslandMenu node];
	
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
		gameMode=[[GameSettings shared] getGlobalForKey:@"gameMode"];
		//[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ChooseLevelSprites.plist" ];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MenuBackground.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"chooseIslandSprite.plist"];
       // [[InAppPurchaseManager shared] loadStoreWithDelegate:self];
        CCSprite *background=[CCSprite spriteWithSpriteFrameName:@"Graphic_MainMenuBack.png"];
        
        [background setPosition:ADJUST_CCP(ccp(160,240))];
               
        
        [self addChild: background];
        
       
        _isSoundOn=YES;
       
        NSString *soundSetting=[[GameSettings shared] getGlobalForKey:@"isSoundOn"];
        if([soundSetting isEqualToString:@"NO"])
        {
            _isSoundOn=NO;
        }
        else 
        {
            _isSoundOn=YES;
        }
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
                [self loadIslands];
        
                
        _goBackButton=[CCSprite spriteWithSpriteFrameName:@"Button_GoBack.png"];
        [_goBackButton setPosition:ADJUST_CCP(ccp(30,455))];
        if(_isSoundOn)
        {
            _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOn.png"];
        }
        else {
            _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOff.png"];
        }
        [_soundButton setPosition:ADJUST_CCP(ccp(290,455))];
        
        //[self addChild:_title];
        [self addChild:_goBackButton];
        [self addChild:_soundButton];
        
       // [self schedule:@selector(update:)];
        /*
         
         NSString *HasName=[[GameSettings shared] getGlobalForKey:@"playerName"];
         if(![HasName isEqualToString:@"YES"]&&[gameMode isEqualToString:@"blueTooth"])
         {
         TextField *textField=[TextField textFieldWithFrame:CGRectMake(ADJUST_X(160), ADJUST_Y(240), HD_PIXELS(300), HD_PIXELS(200))];
         }
         */
        
	}
	return self;
}




-(void)loadIslands
{
    NSMutableArray *_pages = [[NSMutableArray alloc] initWithCapacity:6];
    
    NSString *medalNumberForIsland1=[[GameSettings shared] getGlobalForKey:@"MedalNumberForIsland0"];
    NSString *medalNumberForIsland2=[[GameSettings shared] getGlobalForKey:@"MedalNumberForIsland1"];
    NSString *medalNumberForIsland3=[[GameSettings shared] getGlobalForKey:@"MedalNumberForIsland2"];
    NSString *medalNumberForIsland4=[[GameSettings shared] getGlobalForKey:@"MedalNumberForIsland3"];
    NSString *medalNumberForIsland5=[[GameSettings shared] getGlobalForKey:@"MedalNumberForIsland4"];
    NSString *medalNumberForIsland6=[[GameSettings shared] getGlobalForKey:@"MedalNumberForIsland5"];
    
    if([medalNumberForIsland1 isEqualToString:@""])
    {
        medalNumberForIsland1=@"0";
    }
    if([medalNumberForIsland2 isEqualToString:@""])
    {
        medalNumberForIsland2=@"0";
    }
    if([medalNumberForIsland3 isEqualToString:@""])
    {
        medalNumberForIsland3=@"0";
    }
    if([medalNumberForIsland4 isEqualToString:@""])
    {
        medalNumberForIsland4=@"0";
    }
    if([medalNumberForIsland5 isEqualToString:@""])
    {
        medalNumberForIsland5=@"0";
    }
    if([medalNumberForIsland6 isEqualToString:@""])
    {
        medalNumberForIsland6=@"0";
    }
    
    IslandWindow *island1=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup1.png" MedalNum:medalNumberForIsland1 Score:@"0" andPosition:ADJUST_CCP(ccp(160,240))];
    IslandWindow *island2=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup2.png" MedalNum:medalNumberForIsland2 Score:@"0" andPosition:ADJUST_CCP(ccp(160,240))];
    IslandWindow *island3=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup3.png" MedalNum:medalNumberForIsland3 Score:@"0" andPosition:ADJUST_CCP(ccp(160,240))];
    IslandWindow *island4=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup4.png" MedalNum:medalNumberForIsland4 Score:@"0" andPosition:ADJUST_CCP(ccp(160,240))];
    IslandWindow *island5=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup5.png" MedalNum:medalNumberForIsland5 Score:@"0" andPosition:ADJUST_CCP(ccp(160,240))];
    IslandWindow *island6=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup6.png" MedalNum:medalNumberForIsland6 Score:@"0" andPosition:ADJUST_CCP(ccp(160,240))];
    
    [_pages addObject:island1];
    [_pages addObject:island2];
    [_pages addObject:island3];
    [_pages addObject:island4];
    [_pages addObject:island5];
    [_pages addObject:island6];

    
    _scroller = [[CCScrollLayer alloc] initWithLayers:_pages widthOffset:HD_TEXT3(80)];
    _scroller.minimumTouchLengthToChangePage = 30.0f;
    int pageNumber=[[[GameSettings shared] getGlobalForKey:@"pageNumber"] intValue];
    [_scroller moveToPage:pageNumber];
    [self addChild:_scroller];
    _scroller.showPagesIndicator=YES;
    _scroller.pagesIndicatorPosition=ADJUST_CCP(ccp(160,20));
    
    
}




-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    if (touchOrigin2.x>ADJUST_X(0) && touchOrigin2.x<ADJUST_X(50) && touchOrigin2.y>ADJUST_Y(445) && touchOrigin2.y<ADJUST_Y(480))
    {
        
       
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        
        [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[MainMenu scene]]];
        
        
    }
    
        if(touchOrigin2.x>ADJUST_X(260) && touchOrigin2.x<ADJUST_X(320) && touchOrigin2.y>ADJUST_Y(425) && touchOrigin2.y<ADJUST_Y(480))
    {
        
        if(_isSoundOn)
        {
            [_soundButton setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_SoundOff.png"]];
            _isSoundOn=NO;
            [[GameSettings shared] setGlobal:@"NO" ForKey:@"isSoundOn"];
            
        }
        else
        {
            [_soundButton setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_SoundOn.png"]];
            _isSoundOn=YES;
            [[GameSettings shared] setGlobal:@"YES" ForKey:@"isSoundOn"];
        }
    }
    if (touchOrigin2.x>ADJUST_X(50) && touchOrigin2.x<ADJUST_X(270) && touchOrigin2.y>ADJUST_Y(100) && touchOrigin2.y<ADJUST_Y(400))
    {
        [[GameSettings shared] setGlobal:[NSString stringWithFormat:@"%d",_scroller.currentScreen] ForKey:@"island"];
        NSString *pageNumber=[NSString stringWithFormat:@"%d",_scroller.currentScreen];
        [[GameSettings shared] setGlobal:pageNumber ForKey:@"pageNumber"];
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        
        [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseLevelMenu scene]]];
    }
    
   
}







- (void)dealloc
{
    [super dealloc];
 
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"chooseIslandSprite.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MenuBackground.plist"];
   // [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"Black50.plist"];
    //[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"upgradeSprite.plist"];
    
}


@end
