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
#import "SimpleAudioEngine.h"
#import "UpgradeMenu.h"

@implementation ChooseIslandMenu
@synthesize currentSession;

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
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SeaSunshine.plist" ]; 
       // [[InAppPurchaseManager shared] loadStoreWithDelegate:self];
        CCSprite *background=[CCSprite spriteWithSpriteFrameName:@"Graphic_MainMenuBack.png"];
        
        [background setPosition:ADJUST_CCP(ccp(160,240))];
           //[[InAppPurchaseManager shared] purchaseProductId:kInAppPurchaseUpgradeToFullVersion Delegate:self];    
         [[InAppPurchaseManager shared] loadStoreWithDelegate:self];
        [self addChild: background];
        _sunshine1=[CCSprite spriteWithSpriteFrameName:@"Graphic_SeaShine_1.png"];
        _sunshine2=[CCSprite spriteWithSpriteFrameName:@"Graphic_SeaShine_2.png"];
        _sunshine3=[CCSprite spriteWithSpriteFrameName:@"Graphic_SeaShine_3.png"];
        [_sunshine1 setOpacity:255];
        [_sunshine2 setOpacity:0];
        [_sunshine3 setOpacity:0];
        [_sunshine1 setPosition:ADJUST_CCP(ccp(160,240))];
        [_sunshine2 setPosition:ADJUST_CCP(ccp(160,240))];
        [_sunshine3 setPosition:ADJUST_CCP(ccp(160,240))];
        [self addChild:_sunshine1];
        [self addChild:_sunshine2];
        [self addChild:_sunshine3];
        
        _waitToShowSunshine1=1.0;
       
        _isSoundOn=YES;
        _touchEnable=YES;
       
        NSString *soundSetting=[[GameSettings shared] getGlobalForKey:@"isSoundOn"];
        if([soundSetting isEqualToString:@"NO"])
        {
            _isSoundOn=NO;
              [[SimpleAudioEngine sharedEngine] setMute:YES];
        }
        else 
        {
            _isSoundOn=YES;
              [[SimpleAudioEngine sharedEngine] setMute:NO];
        }
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];
        if([hasPurchased isEqualToString:@"YES"])
        {

        
                [self loadIslands];
        }
        else {
            [self loadIslandsBeforeGettingDLC];
        }
                
        _goBackButton=[CCSprite spriteWithSpriteFrameName:@"Button_GoBack.png"];
        [_goBackButton setPosition:ADJUST_CCP(ccp(30,445))];
        if(_isSoundOn)
        {
            _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOn.png"];
        }
        else {
            _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOff.png"];
        }
        [_soundButton setPosition:ADJUST_CCP(ccp(290,445))];
        
        //[self addChild:_title];
        [self addChild:_goBackButton];
        [self addChild:_soundButton];
         [self schedule:@selector(update:)];
       // [self schedule:@selector(update:)];
        /*
         
         NSString *HasName=[[GameSettings shared] getGlobalForKey:@"playerName"];
         if(![HasName isEqualToString:@"YES"]&&[gameMode isEqualToString:@"blueTooth"])
         {
         TextField *textField=[TextField textFieldWithFrame:CGRectMake(ADJUST_X(160), ADJUST_Y(240), HD_PIXELS(300), HD_PIXELS(200))];
         }
         */
        if([gameMode isEqualToString:@"blueTooth"])
        {
            [self setupBluetoothSession];
           
        }
        
    if([gameMode isEqualToString:@"network"])
    {
        [self setupNetworkSession];
        
        if(!myMatch.expectedPlayerCount==0)
        {
        _touchEnable=NO;
       _waitingAlert = [[AlertView alloc] initWithTitle:@""
                                                        message:@"Deciding who gets to choose the level..............."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
        [_waitingAlert show];
        }
        NSString *showNotHost=[[GameSettings shared] getGlobalForKey:@"ShowNotHostWindow"];
        if([showNotHost isEqualToString:@"NO"])
        {
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"ShowNotHostWindow"];
        [_waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
        AlertView *alert = [[AlertView alloc] initWithTitle:@""
                                                        message:@"Your friend gets to pick the level. Please wait for their decision."
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        alert.tag=2;
        [alert show];
        [alert release];
        _touchEnable=YES;
        }
        
    }
        
	}
	return self;
}

-(void)setupBluetoothSession
{
    currentSession=[[GameSettings shared] getObjForKey:@"session"];
    currentSession.delegate=self;
    [currentSession setDataReceiveHandler:self withContext:nil];
}
-(void)setupNetworkSession
{
    myMatch=[[GameSettings shared] getObjForKey:@"GKMatch"];
    myMatch.delegate=self;
   // NSLog(@"%@",[myMatch.playerIDs objectAtIndex:0]);
    //[currentSession setDataReceiveHandler:self withContext:nil];

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
    
    NSString *totalScoreForIsland1=[[GameSettings shared] getGlobalForKey:@"island0Score"];
    NSString *totalScoreForIsland2=[[GameSettings shared] getGlobalForKey:@"island1Score"];
    NSString *totalScoreForIsland3=[[GameSettings shared] getGlobalForKey:@"island2Score"];
    NSString *totalScoreForIsland4=[[GameSettings shared] getGlobalForKey:@"island3Score"];
    NSString *totalScoreForIsland5=[[GameSettings shared] getGlobalForKey:@"island4Score"];
    NSString *totalScoreForIsland6=[[GameSettings shared] getGlobalForKey:@"island5Score"];
    
    
    if([totalScoreForIsland1 isEqualToString:@""])
    {
        totalScoreForIsland1=@"0";
    }
    if([totalScoreForIsland2 isEqualToString:@""])
    {
        totalScoreForIsland2=@"0";
    }
    if([totalScoreForIsland3 isEqualToString:@""])
    {
        totalScoreForIsland3=@"0";
    }
    if([totalScoreForIsland4 isEqualToString:@""])
    {
        totalScoreForIsland4=@"0";
    }
    if([totalScoreForIsland5 isEqualToString:@""])
    {
        totalScoreForIsland5=@"0";
    }
    if([totalScoreForIsland6 isEqualToString:@""])
    {
        totalScoreForIsland6=@"0";
    }
    IslandWindow *island1=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup1.png" MedalNum:medalNumberForIsland1 Score:totalScoreForIsland1 andPosition:ADJUST_CCP(ccp(160,240))];
    NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];
    if([hasPurchased isEqualToString:@"YES"])
    {
        IslandWindow *island2=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup2.png" MedalNum:medalNumberForIsland2 Score:totalScoreForIsland2 andPosition:ADJUST_CCP(ccp(160,240))];
        
        IslandWindow *island3=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup3.png" MedalNum:medalNumberForIsland3 Score:totalScoreForIsland3 andPosition:ADJUST_CCP(ccp(160,240))];
        IslandWindow *island4=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup4.png" MedalNum:medalNumberForIsland4 Score:totalScoreForIsland4 andPosition:ADJUST_CCP(ccp(160,240))];
        IslandWindow *island5=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup5.png" MedalNum:medalNumberForIsland5 Score:totalScoreForIsland5 andPosition:ADJUST_CCP(ccp(160,240))];
        IslandWindow *island6=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup6.png" MedalNum:medalNumberForIsland6 Score:totalScoreForIsland6 andPosition:ADJUST_CCP(ccp(160,240))];
        [_pages addObject:island1];
        [_pages addObject:island2];
        [_pages addObject:island3];
        [_pages addObject:island4];
        [_pages addObject:island5];
        [_pages addObject:island6];
    
    }
    /*
    else {
       
        IslandWindow *island2=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup2.png" andPosition:ADJUST_CCP(ccp(160,240))];
        IslandWindow *island3=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup3.png" andPosition:ADJUST_CCP(ccp(160,240))];
        IslandWindow *island4=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup4.png" andPosition:ADJUST_CCP(ccp(160,240))];
        IslandWindow *island5=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup5.png" andPosition:ADJUST_CCP(ccp(160,240))];
        IslandWindow *island6=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup6.png" andPosition:ADJUST_CCP(ccp(160,240))];
        [_pages addObject:island1];
        [_pages addObject:island2];
        [_pages addObject:island3];
        [_pages addObject:island4];
        [_pages addObject:island5];
        [_pages addObject:island6];
    }
     */
    
    
 

    
    _scroller = [[CCScrollLayer alloc] initWithLayers:_pages widthOffset:HD_TEXT3(80)];
    _scroller.minimumTouchLengthToChangePage = 30.0f;
    int pageNumber=[[[GameSettings shared] getGlobalForKey:@"pageNumber"] intValue];
    [_scroller moveToPage:pageNumber];
    _dotIndicator =[skullDotIndicator skullDotIndicatorWithNumberOfDots:6 AndPosition:ADJUST_CCP(ccp(160,40)) CurrentPage:pageNumber];
    [self addChild:_scroller];
    [self addChild:_dotIndicator];
    _scroller.showPagesIndicator=NO;
    //_scroller.pagesIndicatorPosition=ADJUST_CCP(ccp(160,20));
    
    
}


-(void)loadIslandsBeforeGettingDLC
{
    NSMutableArray *_pages = [[NSMutableArray alloc] initWithCapacity:6];
    
    NSString *medalNumberForIsland1=[[GameSettings shared] getGlobalForKey:@"MedalNumberForIsland0"];
    NSString *medalNumberForIsland2=[[GameSettings shared] getGlobalForKey:@"MedalNumberForIsland1"];
    NSString *medalNumberForIsland3=[[GameSettings shared] getGlobalForKey:@"MedalNumberForIsland2"];
    //NSString *medalNumberForIsland4=[[GameSettings shared] getGlobalForKey:@"MedalNumberForIsland3"];
    //NSString *medalNumberForIsland5=[[GameSettings shared] getGlobalForKey:@"MedalNumberForIsland4"];
    //NSString *medalNumberForIsland6=[[GameSettings shared] getGlobalForKey:@"MedalNumberForIsland5"];
    
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
        
    NSString *totalScoreForIsland1=[[GameSettings shared] getGlobalForKey:@"island0Score"];
    NSString *totalScoreForIsland2=[[GameSettings shared] getGlobalForKey:@"island1Score"];
    NSString *totalScoreForIsland3=[[GameSettings shared] getGlobalForKey:@"island2Score"];
    
    
    
    if([totalScoreForIsland1 isEqualToString:@""])
    {
        totalScoreForIsland1=@"0";
    }
    if([totalScoreForIsland2 isEqualToString:@""])
    {
        totalScoreForIsland2=@"0";
    }
    if([totalScoreForIsland3 isEqualToString:@""])
    {
        totalScoreForIsland3=@"0";
    }
    
       IslandWindow *island1=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup1.png" MedalNum:medalNumberForIsland1 Score:totalScoreForIsland1 andPosition:ADJUST_CCP(ccp(160,240))];
 
        IslandWindow *island2=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup2.png" MedalNum:medalNumberForIsland2 Score:totalScoreForIsland2 andPosition:ADJUST_CCP(ccp(160,240))];
        
        IslandWindow *island3=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup3.png" MedalNum:medalNumberForIsland3 Score:totalScoreForIsland3 andPosition:ADJUST_CCP(ccp(160,240))];
        //IslandWindow *island4=[IslandWindow IslandWindowWithImage:@"Button_LevelGroup4.png" andPosition:ADJUST_CCP(ccp(160,240))];
    CCSprite *promotionPage=[CCSprite spriteWithSpriteFrameName:@"Button_Unlock3Islands.png"];
    [promotionPage setPosition:ADJUST_CCP(ccp(170,240))];
    CCSprite *parentlayer=[[CCSprite alloc] init];
    [parentlayer addChild:promotionPage];
    
    
        [_pages addObject:island1];
        [_pages addObject:island2];
        [_pages addObject:island3];
        [_pages addObject:parentlayer];
    [parentlayer release];
   
    
    
    
    
    
    
    
    
    _scroller = [[CCScrollLayer alloc] initWithLayers:_pages widthOffset:HD_TEXT3(80)];
    _scroller.minimumTouchLengthToChangePage = 30.0f;
    int pageNumber=[[[GameSettings shared] getGlobalForKey:@"pageNumber"] intValue];
    [_scroller moveToPage:pageNumber];
    _dotIndicator =[skullDotIndicator skullDotIndicatorWithNumberOfDots:4 AndPosition:ADJUST_CCP(ccp(160,40)) CurrentPage:pageNumber];
    [self addChild:_scroller];
    [self addChild:_dotIndicator];
    _scroller.showPagesIndicator=NO;
    //_scroller.pagesIndicatorPosition=ADJUST_CCP(ccp(160,20));
    
    
}








- (NSString *)getIslandName:(NSString *)islandNumber
{
    if([islandNumber isEqualToString:@"0"])
    {
        return @"Cabin Boy";
    }
    else if([islandNumber isEqualToString:@"1"])
    {
        return @"Swabbie";
    }
    else if([islandNumber isEqualToString:@"2"])
    {
        return @"Deckhand";
    }
    else if([islandNumber isEqualToString:@"3"])
    {
        return @"Helmsman";
    }
    else if([islandNumber isEqualToString:@"4"])
    {
        return @"Captain";
    }
    else if([islandNumber isEqualToString:@"5"])
    {
        return @"Pirate King";
    }
    else {
        return nil;
    }
    
}


-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    if (touchOrigin2.x>ADJUST_X(0) && touchOrigin2.x<ADJUST_X(50) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(465))
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"menuBack.wav"];
       
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        
        [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[MainMenu scene]]];
        if([gameMode isEqualToString:@"network"])
        {
        [myMatch disconnect];
        }
        if([gameMode isEqualToString:@"blueTooth"])
        {
            [currentSession disconnectFromAllPeers];;
        }
        
        
    }
    
        if(touchOrigin2.x>ADJUST_X(260) && touchOrigin2.x<ADJUST_X(320) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(465))
    {
        NSLog(@"%@",myMatch.playerIDs);
        if(_isSoundOn)
        {
            [_soundButton setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_SoundOff.png"]];
            _isSoundOn=NO;
              [[SimpleAudioEngine sharedEngine] setMute:YES];
            [[GameSettings shared] setGlobal:@"NO" ForKey:@"isSoundOn"];
            
        }
        else
        {
            [_soundButton setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_SoundOn.png"]];
            _isSoundOn=YES;
              [[SimpleAudioEngine sharedEngine] setMute:NO];
            [[GameSettings shared] setGlobal:@"YES" ForKey:@"isSoundOn"];
        }
    }
    if (touchOrigin2.x>ADJUST_X(50) && touchOrigin2.x<ADJUST_X(270) && touchOrigin2.y>ADJUST_Y(100) && touchOrigin2.y<ADJUST_Y(400))
    {
        NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];
        if([hasPurchased isEqualToString:@"YES"])
        {
            if([gameMode isEqualToString:@"network"]&&!_touchEnable)
            {
                return;
            }
        [[GameSettings shared] setGlobal:[NSString stringWithFormat:@"%d",_scroller.currentScreen] ForKey:@"island"];
        NSString *pageNumber=[NSString stringWithFormat:@"%d",_scroller.currentScreen];
        [[GameSettings shared] setGlobal:pageNumber ForKey:@"pageNumber"];
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        [[SimpleAudioEngine sharedEngine] playEffect:@"menuForward.mp3"];
        [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseLevelMenu scene]]];
        }
        else {
            if(_scroller.currentScreen==0||_scroller.currentScreen==1||_scroller.currentScreen==2)
            {
                [[GameSettings shared] setGlobal:[NSString stringWithFormat:@"%d",_scroller.currentScreen] ForKey:@"island"];
                NSString *pageNumber=[NSString stringWithFormat:@"%d",_scroller.currentScreen];
                [[GameSettings shared] setGlobal:pageNumber ForKey:@"pageNumber"];
                CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
                [[SimpleAudioEngine sharedEngine] playEffect:@"menuForward.mp3"];
                [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseLevelMenu scene]]];

            }
            else if(_scroller.currentScreen==3) {
                /*
                [[GameSettings shared] setGlobal:@"ChooseIslandMenu" ForKey:@"UpgradeMenuBackTo"];
                CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
                [[SimpleAudioEngine sharedEngine] playEffect:@"menuForward.mp3"];

                [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[UpgradeMenu scene]]];
                 */
                
                 [[SimpleAudioEngine sharedEngine] playEffect:@"menuForward.mp3"];
                [[InAppPurchaseManager shared] purchaseProductId:kInAppPurchaseUpgradeToFullVersion Delegate:self];
            }
        }
    }
    
   
}


- (void)update:(ccTime)dt
{
    [_dotIndicator changeDotForPage:_scroller.currentScreen];
    if(_waitToShowSunshine1>0)
    {
        _waitToShowSunshine1=_waitToShowSunshine1-dt;
        
        [_sunshine1 setOpacity:_waitToShowSunshine1*255] ;
        [_sunshine2 setOpacity:(1-_waitToShowSunshine1)*255];
        
        if(_waitToShowSunshine1<0)
        {
            [_sunshine1 setOpacity:0];
            [_sunshine2 setOpacity:255];
            _waitToShowSunshine2=1.0;
        }
        
        
    }
    
    if(_waitToShowSunshine2>0)
    {
        _waitToShowSunshine2=_waitToShowSunshine2-dt;
        
        [_sunshine2 setOpacity:_waitToShowSunshine2*255] ;
        [_sunshine3 setOpacity:(1-_waitToShowSunshine2)*255];
        
        if(_waitToShowSunshine2<0)
        {
            [_sunshine2 setOpacity:0];
            [_sunshine3 setOpacity:255];
            _waitToShowSunshine3=1.0;
        }
        
        
    }
    if(_waitToShowSunshine3>0)
    {
        _waitToShowSunshine3=_waitToShowSunshine3-dt;
        
        [_sunshine3 setOpacity:_waitToShowSunshine3*255] ;
        [_sunshine1 setOpacity:(1-_waitToShowSunshine3)*255];
        
        if(_waitToShowSunshine3<0)
        {
            [_sunshine3 setOpacity:0];
            [_sunshine1 setOpacity:255];
            _waitToShowSunshine1=1.0;
        }
        
        
    }
    

}








#pragma mark DLC

-(void)updateDlcLevels
{
    CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
    
    [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseIslandMenu scene]]];
}
-(void)restoreFails
{
}
-(void)openErrorWindowCantConnectToStore
{
    AlertView *alert = [[AlertView alloc] initWithTitle:@"ERROR!"
                                                    message:@"Cannot connect to the store at this time. Please try again later."
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
-(void)openErrorWindowCantMakePurchases
{
    AlertView *alert = [[AlertView alloc] initWithTitle:@"ERROR!"
                                                    message:@"Cannot make purchase at this time. Please try again later or make sure to have in app purchases enabled in Settings>General>Restrictions."
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)setCantConnectToStore:(BOOL)CantConnectToStore
{
    
}
-(void)setCantMakePurchases:(BOOL)CantMakePurchases
{
    
}


#pragma mark Bluetooth


- (void) mySendDataToPeers:(NSMutableData *) data
{
    if (currentSession)
        [self.currentSession sendDataToAllPeers:data
                                   withDataMode:GKSendDataReliable
                                          error:nil];
}
- (void)session:(GKSession *)session
           peer:(NSString *)peerID
 didChangeState:(GKPeerConnectionState)state {
    switch (state)
    {
        case GKPeerStateConnected:
            NSLog(@"connected");
            break;
        case GKPeerStateDisconnected:
            NSLog(@"disconnected");
            //[self.currentSession release];
            [currentSession disconnectFromAllPeers];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"BluePlayer"]];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"OrangePlayer"]];
            AlertView *alert = [[AlertView alloc] initWithTitle:@""
                                                            message:@"The connection with the other player has been lost"
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
            alert.tag=3;
            [alert show];
            [alert release];

            
            break;
        case GKPeerStateAvailable:
            NSLog(@"available");
            break;
        case GKPeerStateConnecting:
            NSLog(@"connecting");
            break;
        case GKPeerStateUnavailable:
            NSLog(@"unavailable");
            break;
            
    }
}


- (void)showMessage:(NSString *)buttonID
{
    
    //NSString *str=@"hellohello";
    NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
    NSString *islandNumber=[[GameSettings shared] getGlobalForKey:@"island"];
    NSString *newIslandName=[self getIslandName:islandNumber];
    NSString *levelNumberOnButton=[[GameSettings shared] getGlobalForKey:@"levelNumberOnButton"];
    NSString *invatationText = [NSString stringWithFormat:  @"%@ would like to play %@ level %@", playerName,newIslandName,levelNumberOnButton];
    NSString *levelNumber=buttonID;
    //[[GameSettings shared] setGlobal:playerName ForKey:@"BluePlayer"];
    //[[GameSettings shared] setGlobal:@"YES" ForKey:@"touchEnable"];
    NSString *isInvitation=@"YES";
    NSString *isReply=@"NO";
    NSArray *valueArray=[NSArray arrayWithObjects:playerName,levelNumber,invatationText,isInvitation,isReply,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"PlayerName"], [NSString stringWithFormat:@"LevelNumber"],[NSString stringWithFormat:@"Text"],[NSString stringWithFormat:@"isInvation"],[NSString stringWithFormat:@"isReply"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    
    //data = [str dataUsingEncoding: NSASCIIStringEncoding];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    [self mySendDataToPeers:data];
    [data release];
}

-(void)reply:(NSString *)yesOrNo
{
    NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
    NSString *isInvitation=@"NO";
    NSString *isReply=@"YES";
    NSString *answer=yesOrNo;
    NSArray *valueArray=[NSArray arrayWithObjects:isInvitation,isReply,answer,playerName, nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isInvation"],[NSString stringWithFormat:@"isReply"],[NSString stringWithFormat:@"answer"],[NSString stringWithFormat:@"PlayerName"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    
    //data = [str dataUsingEncoding: NSASCIIStringEncoding];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    [self mySendDataToPeers:data];
    [data release];
    
}
-(void)reply:(NSString *)yesOrNo AndColor:(NSString *)color
{
    NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
    NSString *isInvitation=@"NO";
    NSString *isReply=@"YES";
    
    NSString *answer=yesOrNo;
    NSArray *valueArray=[NSArray arrayWithObjects:isInvitation,isReply,answer,playerName,color,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isInvation"],[NSString stringWithFormat:@"isReply"],[NSString stringWithFormat:@"answer"],[NSString stringWithFormat:@"PlayerName"],[NSString stringWithFormat:@"opponentColor"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    
    //data = [str dataUsingEncoding: NSASCIIStringEncoding];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    [self mySendDataToPeers:data];
    [data release];
    
}

- (void) receiveData:(NSMutableData *)data
            fromPeer:(NSString *)peer
           inSession:(GKSession *)session
             context:(void *)context {
    //---convert the NSData to NSString---
    
    NSMutableData *newData = data;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:newData];
    NSDictionary *infoList = [unarchiver decodeObjectForKey:@"Data"] ;
    [unarchiver finishDecoding];
    [unarchiver release];
    //[newData release];
    
    
    NSString *isInvation=[infoList objectForKey:@"isInvation"];
    NSString *isReply=[infoList objectForKey:@"isReply"];
    NSString *receiveInvite=[[GameSettings shared] getGlobalForKey:@"receiveInvite"];
    if([isInvation isEqualToString:@"YES"]&&[isReply isEqualToString:@"NO"]&&![receiveInvite isEqualToString:@"NO"])
    {
        NSString *text=[infoList objectForKey:@"Text"];
        NSString *playerName=[infoList objectForKey:@"PlayerName"];
       [[GameSettings shared] setGlobal:playerName ForKey:@"OpponentName"];
        NSString *islandNumber=[infoList objectForKey:@"islandNumber"];
        NSString *levelNumberOnButton=[infoList objectForKey:@"levelnumberOnButton"];
        [[GameSettings shared] setGlobal:islandNumber ForKey:@"island"];
        [[GameSettings shared] setGlobal:levelNumberOnButton ForKey:@"levelNumberOnButton"];
        NSString *levelNumber=[infoList objectForKey:@"LevelNumber"];
        [[GameSettings shared] setGlobal:levelNumber ForKey:@"selectedLevel"];
        AlertView *alert = [[AlertView alloc] initWithTitle:@""
                                                        message:text
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"YES",nil];
        [alert show];
        [alert release];
    }
    else if([isInvation isEqualToString:@"NO"]&&[isReply isEqualToString:@"YES"])
    {
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
        NSString *answer=[infoList objectForKey:@"answer"];
        if([answer isEqualToString:@"YES"])
        {
            NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
            NSString *opponentName=[infoList objectForKey:@"PlayerName"];
            NSString *opponentColor=[infoList objectForKey:@"opponentColor"];
            
            if([opponentColor isEqualToString:@"orange"])
            {
                
                
                [[GameSettings shared] setGlobal:opponentName ForKey:@"OrangePlayer"];
                [[GameSettings shared] setGlobal:playerName ForKey:@"BluePlayer"];
                [[GameSettings shared] setGlobal:@"YES" ForKey:@"touchEnable"];
            }
            else if([opponentColor isEqualToString:@"blue"])
            {
                [[GameSettings shared] setGlobal:opponentName ForKey:@"BluePlayer"];
                [[GameSettings shared] setGlobal:playerName ForKey:@"OrangePlayer"];
                [[GameSettings shared] setGlobal:@"NO" ForKey:@"touchEnable"];
            }
            [_waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
            // [myTextField1 removeFromSuperview];
            // [myTextField2 removeFromSuperview];
            CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
            [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[GameLayer scene]]]; 
            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        }
        else {
            if(_waitingAlert.isVisible)
            {
                [_waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
            }
            /*
             AlertView *alert = [[AlertView alloc] initWithTitle:@""
             message:@"invatition rejected"
             delegate:self
             cancelButtonTitle:nil
             otherButtonTitles:@"Okay",nil];
             [alert show];
             [alert release];
             */
        }
    }
}
- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
if(alertView.tag==3)
{
    [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
   // CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
    //[director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[MainMenu scene]]];
}
else if (alertView.tag==2) {
    
}
else {
    

    if (buttonIndex==1) {
        
        NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
        // [[GameSettings shared] setGlobal:playerName ForKey:@"OrangePlayer"];
       // int yesOrNo = arc4random() % 2;
         int yesOrNo=1;
        if(yesOrNo)
        {
            
            [[GameSettings shared] setGlobal: [[GameSettings shared] getGlobalForKey:@"OpponentName"] ForKey:@"BluePlayer"];
            [[GameSettings shared] setGlobal:@"NO" ForKey:@"touchEnable"];
            if([gameMode isEqualToString:@"blueTooth"])
            {
                [[GameSettings shared] setGlobal:playerName ForKey:@"OrangePlayer"]; 
                [self reply:@"YES" AndColor:@"orange"];
            }
            else if([gameMode isEqualToString:@"network"]) {
                NSString *playerName2=[[GKLocalPlayer localPlayer] alias];
                [[GameSettings shared] setGlobal:playerName2 ForKey:@"OrangePlayer"];
                [self networkReply:@"YES" AndColor:@"orange"];
            }
        }        else {
            
            [[GameSettings shared] setGlobal:playerName ForKey:@"BluePlayer"]; 
            [[GameSettings shared] setGlobal: [[GameSettings shared] getGlobalForKey:@"OpponentName"] ForKey:@"OrangePlayer"];
            [[GameSettings shared] setGlobal:@"YES" ForKey:@"touchEnable"];
            if([gameMode isEqualToString:@"blueTooth"])
            {
                [self reply:@"YES" AndColor:@"blue"];
            }
            else if([gameMode isEqualToString:@"network"]) {
                [self networkReply:@"YES" AndColor:@"blue"];
            }
            
        }
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[GameLayer scene]]]; 
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        
        
    }

    else {
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
        if([gameMode isEqualToString:@"blueTooth"])
        {
            [self reply:@"NO"];
        }
        else if([gameMode isEqualToString:@"network"]) {
            [self netWorkReply:@"NO"];
        }
    }
}    
    
}


#pragma mark Internet



- (void)sendTossCoin:(NSString *)coin
{
    
    NSString *isTossCoin=@"YES";
    
    // NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
       NSArray *valueArray=[NSArray arrayWithObjects:isTossCoin,coin,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isTossCoin"],[NSString stringWithFormat:@"coinNumber"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    
    //data = [str dataUsingEncoding: NSASCIIStringEncoding];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    //[self mySendDataToPeers:data];
    [myMatch sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:nil];
    [data release];
}




- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
    switch (state)
    {
        case GKPlayerStateConnected:
            // handle a new player connection.
         coinNumber = arc4random() % 10000;
            NSString *coinNumberString=[NSString stringWithFormat:@"%d",coinNumber];
            [self sendTossCoin:coinNumberString];
            
            break;
        case GKPlayerStateDisconnected:
            [myMatch disconnect];
             [[GameSettings shared] setGlobal:@"YES" ForKey:@"isHost"];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"BluePlayer"]];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"OrangePlayer"]];
            AlertView *alert = [[AlertView alloc] initWithTitle:@""
                                                            message:@"The connection with the other player has been lost"
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
            alert.tag=3;
            [alert show];
            [alert release];
            
            break;
    }
    
}

- (void)match:(GKMatch *)match didReceiveData:(NSMutableData *)data fromPlayer:(NSString *)playerID
{
    NSLog(@"%@",match.playerIDs); 
    NSLog(@"%@",playerID);
    
    NSMutableData *newData = data;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:newData];
    NSDictionary *infoList = [unarchiver decodeObjectForKey:@"Data"] ;
    [unarchiver finishDecoding];
    [unarchiver release];
    //[newData release];
    NSString *isTossCoin=[infoList objectForKey:@"isTossCoin"];
    NSString *opponentCoins=[infoList objectForKey:@"coinNumber"];
    if([isTossCoin isEqualToString:@"YES"])
    {
        int opponentCointNumber=[opponentCoins intValue];
        if(opponentCointNumber>coinNumber)
        {
            [[GameSettings shared] setGlobal:@"NO" ForKey:@"isHost"];
             [_waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
            AlertView *alert = [[AlertView alloc] initWithTitle:@""
                                                            message:@"The other player gets to pick the level this time. Please wait for their decision."
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
            alert.tag=2;
            [alert show];
            [alert release];
            _touchEnable=YES;
        }
        else if(opponentCointNumber<coinNumber) 
        {
             [[GameSettings shared] setGlobal:@"YES" ForKey:@"isHost"];
             [_waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
            AlertView *alert = [[AlertView alloc] initWithTitle:@""
                                                            message:@"You have been chosen! Please pick which level to play."
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
            alert.tag=2;
            [alert show];
            [alert release];
            _touchEnable=YES;
        }
        else {
            [myMatch disconnect];
        }
    }
    
    NSString *isInvation=[infoList objectForKey:@"isInvation"];
    NSString *isReply=[infoList objectForKey:@"isReply"];
    NSString *receiveInvite=[[GameSettings shared] getGlobalForKey:@"receiveInvite"];
    if([isInvation isEqualToString:@"YES"]&&[isReply isEqualToString:@"NO"]&&![receiveInvite isEqualToString:@"NO"])
    {
        NSString *text=[infoList objectForKey:@"Text"];
        NSString *playerName=[infoList objectForKey:@"PlayerName"];
       [[GameSettings shared] setGlobal:playerName ForKey:@"OpponentName"];
        NSString *islandNumber=[infoList objectForKey:@"islandNumber"];
        NSString *levelNumberOnButton=[infoList objectForKey:@"levelnumberOnButton"];
        [[GameSettings shared] setGlobal:islandNumber ForKey:@"island"];
        [[GameSettings shared] setGlobal:levelNumberOnButton ForKey:@"levelNumberOnButton"];
        NSString *levelNumber=[infoList objectForKey:@"LevelNumber"];
        [[GameSettings shared] setGlobal:levelNumber ForKey:@"selectedLevel"];
        AlertView *alert = [[AlertView alloc] initWithTitle:@""
                                                        message:text
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"YES",nil];
        [alert show];
        [alert release];
    }
    else if([isInvation isEqualToString:@"NO"]&&[isReply isEqualToString:@"YES"])
    {
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
        NSString *answer=[infoList objectForKey:@"answer"];
        
        if([answer isEqualToString:@"YES"])
        {
            //NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
             NSString *playerName=[[GKLocalPlayer localPlayer] alias];
            NSString *opponentName=[infoList objectForKey:@"PlayerName"];
            NSString *opponentColor=[infoList objectForKey:@"opponentColor"];
            
            if([opponentColor isEqualToString:@"orange"])
            {
                
                
                [[GameSettings shared] setGlobal:opponentName ForKey:@"OrangePlayer"];
                [[GameSettings shared] setGlobal:playerName ForKey:@"BluePlayer"];
                [[GameSettings shared] setGlobal:@"YES" ForKey:@"touchEnable"];
            }
            else if([opponentColor isEqualToString:@"blue"])
            {
                [[GameSettings shared] setGlobal:opponentName ForKey:@"BluePlayer"];
                [[GameSettings shared] setGlobal:playerName ForKey:@"OrangePlayer"];
                [[GameSettings shared] setGlobal:@"NO" ForKey:@"touchEnable"];
            }
            [_waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
            // [myTextField1 removeFromSuperview];
            // [myTextField2 removeFromSuperview];
            CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
            [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[GameLayer scene]]]; 
            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        }
        else {
            if(_waitingAlert.isVisible)
            {
                [_waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
            }
            /*
             AlertView *alert = [[AlertView alloc] initWithTitle:@""
             message:@"invatition rejected"
             delegate:self
             cancelButtonTitle:nil
             otherButtonTitles:@"Okay",nil];
             [alert show];
             [alert release];
             */
        }
    }

}
- (BOOL)match:(GKMatch *)match shouldReinvitePlayer:(NSString *)playerID
{
    return NO;
}

-(void)netWorkReply:(NSString *)yesOrNo
{
    //NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
         NSString *playerName=	[[GKLocalPlayer localPlayer] alias];
    NSString *isInvitation=@"NO";
    NSString *isReply=@"YES";
    NSString *answer=yesOrNo;
    NSArray *valueArray=[NSArray arrayWithObjects:isInvitation,isReply,answer,playerName, nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isInvation"],[NSString stringWithFormat:@"isReply"],[NSString stringWithFormat:@"answer"],[NSString stringWithFormat:@"PlayerName"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    
    //data = [str dataUsingEncoding: NSASCIIStringEncoding];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    //[self mySendDataToPeers:data];
    [myMatch sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:nil];
    [data release];
    
}
-(void)networkReply:(NSString *)yesOrNo AndColor:(NSString *)color
{
   // NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
     NSString *playerName=	[[GKLocalPlayer localPlayer] alias];
   
    NSString *isInvitation=@"NO";
    NSString *isReply=@"YES";
    
    NSString *answer=yesOrNo;
    NSArray *valueArray=[NSArray arrayWithObjects:isInvitation,isReply,answer,playerName,color,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isInvation"],[NSString stringWithFormat:@"isReply"],[NSString stringWithFormat:@"answer"],[NSString stringWithFormat:@"PlayerName"],[NSString stringWithFormat:@"opponentColor"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    
    //data = [str dataUsingEncoding: NSASCIIStringEncoding];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    [myMatch sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:nil];
    [data release];
    
}

- (void)dealoc
{
  
 
    
    [[CCSpriteFrameCache  sharedSpriteFrameCache] removeSpriteFramesFromFile:@"chooseIslandSprite.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MenuBackground.plist"];
      [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"SeaSunshine.plist" ];
    [_waitingAlert release];
   // [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"Black50.plist"];
    //[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"upgradeSprite.plist"];
      [super dealloc];
    
}


@end
