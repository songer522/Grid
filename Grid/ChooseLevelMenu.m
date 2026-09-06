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
#import "TextField.h"
#import "MainMenu.h"
#import "UpgradeMenu.h"
#import "GameLayer.h"
#import "InAppPurchaseManager.h"
#import "ChooseIslandMenu.h"
#import "SimpleAudioEngine.h"
#import "InputNameWindow.h"
#import "GCHelper.h"

@implementation ChooseLevelMenu
@synthesize currentSession;
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
		gameMode=[[GameSettings shared] getGlobalForKey:@"gameMode"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ChooseLevelSprites.plist" ];
       
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MenuBackground.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"upgradeSprite.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Black50.plist" ];
      //[[InAppPurchaseManager shared] loadStoreWithDelegate:self];
        CCSprite *background=[CCSprite spriteWithSpriteFrameName:@"Graphic_MainMenuBack.png"];
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SeaSunshine.plist" ]; 
        
        [background setPosition:ADJUST_CCP(ccp(160,240))];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level1"];
        /*
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level2"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level3"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level4"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level5"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level6"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level7"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level8"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level9"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level10"];
        
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level11"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level12"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level13"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level14"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level15"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level16"];
         */
        
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level17"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level33"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level49"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level65"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level81"];
        /*
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level18"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level19"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level20"];
        
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level21"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level22"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level23"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level24"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level25"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level26"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level27"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level28"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level29"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level30"];
        
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level31"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level32"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level33"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level34"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level35"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level36"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level37"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level38"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level39"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level40"];
        

        
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level41"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level42"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level43"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level44"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level45"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level46"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level47"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level48"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level49"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level50"];
         
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level51"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level52"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level53"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level54"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level55"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level56"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level57"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level58"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level59"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level60"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level61"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level62"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level63"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level64"];
        
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level65"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level66"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level67"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level68"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level69"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level70"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level71"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level72"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level73"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level74"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level75"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level76"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level77"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level78"];
        
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level79"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level80"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level81"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level82"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level83"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level84"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level85"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level86"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level87"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level88"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level89"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level90"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level91"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level92"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level93"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level94"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level95"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level96"];
                */
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
        _buttonArray1=[[NSMutableArray alloc] init];
        _buttonArray2=[[NSMutableArray alloc] init];
        _buttonArray3=[[NSMutableArray alloc] init];
        _isSoundOn=YES;
        _isEditing=NO;
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
        
        if([gameMode isEqualToString:@"blueTooth"])
        {
       [self setupBluetoothSession];
            _waitToShowTextfield3=0.6;
        }
        if([gameMode isEqualToString:@"network"])
        {
            [self setupNetworkSession];
            
        }
        [self loadButton];
        
        //_title=[CCLabelTTF labelWithString:@"Level Select" fontName:@"Marker Felt" fontSize:HD_TEXT(38)];
        //[_title setPosition:ADJUST_CCP(ccp(160,450))];
        if([gameMode isEqualToString:@"oneDevice"])
        {
        _waitToShowTextField1=0.6;
        _waitToShowTextField2=0.6;
        }
        if([gameMode isEqualToString:@"solo"])
        {
           _waitToShowTextfield3=0.6;
        }
        _nameButton=[Button buttonAtPosition:ADJUST_CCP(ccp(80,445)) andImage:@"Button_Credits.png"];
                
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
        if([gameMode isEqualToString:@"oneDevice"])
        {
        [self addChild:_nameButton];
        }
       [self schedule:@selector(update:)];
        if([gameMode isEqualToString:@"solo"])
        {
        [self getMedalNumbers];
        }
        [self getTotalScore];
        /*
        
        NSString *HasName=[[GameSettings shared] getGlobalForKey:@"playerName"];
        if(![HasName isEqualToString:@"YES"]&&[gameMode isEqualToString:@"blueTooth"])
        {
            TextField *textField=[TextField textFieldWithFrame:CGRectMake(ADJUST_X(160), ADJUST_Y(240), HD_PIXELS(300), HD_PIXELS(200))];
        }
        */
        NSString *player1Name=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
        NSString *player2Name=[[GameSettings shared] getGlobalForKey:@"Player2Name"];
        if(([player1Name isEqualToString:@""]||[player2Name isEqualToString:@""])&&[gameMode isEqualToString:@"oneDevice"])
        {
        nameWindow= [InputNameWindow InputNameWindowInController:self];
        [self addChild:nameWindow];
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
    //[currentSession setDataReceiveHandler:self withContext:nil];
    
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


-(void)loadButton
{
    /*
   NSMutableArray *_pages = [[NSMutableArray alloc] initWithCapacity:3];
    CCLayer *_layer=[CCLayer node];
    for (int i=1; i<6; i++) {
        for (int j=1; j<5; j++) {
            LevelButton *button=[LevelButton levelButtonWithId:(j+(i-1)*4)];
            [button setPosition:ADJUST_CCP(ccp(40+80*(j-1),380-70*(i-1)))];
            [_layer addChild:button];
            [_buttonArray1 addObject:button];
        }
    }
    
    CCLayer *_layer2=[CCLayer node];
    for (int i=1; i<6; i++) {
        for (int j=1; j<5; j++) {
            LevelButton *button=[LevelButton levelButtonWithId:(j+(i-1)*4)+20];
            [button setPosition:ADJUST_CCP(ccp(40+80*(j-1),380-70*(i-1)))];
            [_layer2 addChild:button];
            [_buttonArray2 addObject:button];
        }
    }
    
    CCLayer *_layer3=[CCLayer node];
    for (int i=1; i<6; i++) {
        for (int j=1; j<5; j++) {
            LevelButton *button=[LevelButton levelButtonWithId:(j+(i-1)*4)+40];
            [button setPosition:ADJUST_CCP(ccp(40+80*(j-1),380-70*(i-1)))];
            [_layer3 addChild:button];
            [_buttonArray3 addObject:button];
        }
    }
    
    
   [_pages addObject:_layer];
    
    NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];
    if([hasPurchased isEqualToString:@"YES"])
    {
 [_pages addObject:_layer2];
[_pages addObject:_layer3];
    }
    else {
        UpgradeMenu *menu=[UpgradeMenu UpgradeMenuLayer];
         _upgradeButton=[Button buttonAtPosition:ADJUST_CCP(ccp(130,455)) andImage:@"Button_Upgrade.png"];
        [_upgradeButton setScale:0.8];
        [menu addChild:_upgradeButton];
        [_pages addObject:menu];
    }
_scroller = [[CCScrollLayer alloc] initWithLayers:_pages widthOffset: 0];
_scroller.minimumTouchLengthToChangePage = 30.0f;
    int pageNumber=[[[GameSettings shared] getGlobalForKey:@"pageNumber"] intValue];
    [_scroller moveToPage:pageNumber];
[self addChild:_scroller];
_scroller.showPagesIndicator=YES;
    _scroller.pagesIndicatorPosition=ADJUST_CCP(ccp(160,20));

*/
    
NSString *islandNum=[[GameSettings shared] getGlobalForKey:@"island"];

int page=[islandNum intValue];

CCLayer *_layer=[CCLayer node];
for (int i=1; i<5; i++) {
    for (int j=1; j<5; j++) {
        LevelButton *button=[LevelButton levelButtonWithId:((j+(i-1)*4)+page*16)];
        [button setPosition:ADJUST_CCP(ccp(45+75*(j-1),360-70*(i-1)))];
        [_layer addChild:button];
        [_buttonArray1 addObject:button];
    }
}
[self addChild:_layer];

}


-(void)getMedalNumbers
{
    int totalMedal=0;
    for(LevelButton *obj in _buttonArray1)
    {
        if(obj.hasMedal==YES)
        {
            totalMedal++;
        }
    }
    NSString *islandNumber= [[GameSettings shared] getGlobalForKey:@"island"];
    [[GameSettings shared] setGlobal:[NSString stringWithFormat:@"%d",totalMedal] ForKey:[NSString stringWithFormat:@"MedalNumberForIsland%@",islandNumber]];
}

-(void)getTotalScore
{
    NSString *islandNum=[[GameSettings shared] getGlobalForKey:@"island"];
    int totalScore=0;
    int page=[islandNum intValue];
    
    for (int i=1; i<5; i++) 
    {
        for (int j=1; j<5; j++) 
        {
     NSString *score=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"bestScoreLevel%d",((j+(i-1)*4)+page*16)]];
            totalScore=totalScore+[score intValue];
        }
    }
    NSString *totalScoreString=[NSString stringWithFormat:@"%d",totalScore];
   // float totalScorefloat=[totalScoreString floatValue];
    
    
    //[[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland1Score score:totalScorefloat];
        [[GameSettings shared] setGlobal:totalScoreString ForKey:[NSString stringWithFormat:@"island%@Score",islandNum]];

    
}

-(NSMutableArray*)getCurrentArray
{
    NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];

    

    
    
    if(_scroller.currentScreen==0)
    {
        return _buttonArray1;
    }
else if(_scroller.currentScreen==1&&[hasPurchased isEqualToString:@"YES"]){
    return _buttonArray2;
}
else if(_scroller.currentScreen==2)
{
    return _buttonArray3;  
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
    if (touchOrigin2.x>ADJUST_X(0) && touchOrigin2.x<ADJUST_X(50) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(460))
    {
        
        //[myTextField1 removeFromSuperview];
        //[myTextField2 removeFromSuperview];
        [[SimpleAudioEngine sharedEngine] playEffect:@"menuBack.wav"];
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        
        [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseIslandMenu scene]]];
        
        
    }
    if (touchOrigin2.x>ADJUST_X(50) && touchOrigin2.x<ADJUST_X(100) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(465))
    {
        if([gameMode isEqualToString:@"oneDevice"])
        {
        [_nameButton playbuttonAnimation];
     
            nameWindow= [InputNameWindow InputNameWindowInController:self];
            [self addChild:nameWindow];
        }
        

    
    }
    
    if (touchOrigin2.x>ADJUST_X(50) && touchOrigin2.x<ADJUST_X(250) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(465))
    {
        NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];
        
        if(_scroller.currentScreen==1&&[hasPurchased isEqualToString:@"NO"])
        {
            [_upgradeButton playbuttonAnimation];
             [[InAppPurchaseManager shared] purchaseProductId:kInAppPurchaseUpgradeToFullVersion Delegate:self];
         
        }
    }
    if(touchOrigin2.x>ADJUST_X(260) && touchOrigin2.x<ADJUST_X(320) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(465))
    {
        
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
    //NSMutableArray *_buttonArray=[self getCurrentArray];
    
    for(LevelButton *obj in _buttonArray1)
    {
        if([obj checkTouchAtPosition:touchOrigin2]&&!_isEditing)
        {
            if([gameMode isEqualToString:@"blueTooth"])
            {
                
               // NSString *unlockedValue = [[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"level%d",obj.buttonId]];
                
                
                if(obj.buttonId==1||obj.buttonId==2)
                {
                    return;
                }
                
               // if ([unlockedValue isEqualToString:@"YES"])
                    
                //{
                    
                     [[SimpleAudioEngine sharedEngine] playEffect:@"menuForward.mp3"];
                    NSString *levelNumber=[NSString stringWithFormat:@"%d",obj.buttonId];
                    [[GameSettings shared] setGlobal:levelNumber ForKey:@"selectedLevel"];
                    NSString *buttonNumber=obj.levelNumber.string;
                    if(buttonNumber)
                    {

                    [[GameSettings shared] setGlobal:buttonNumber ForKey:@"levelNumberOnButton"];
                    }
                   // NSString *pageNumber=[NSString stringWithFormat:@"%d",_scroller.currentScreen];
                    //[[GameSettings shared] setGlobal:pageNumber ForKey:@"pageNumber"];
                    [self showMessage:[NSString stringWithFormat:@"%d", obj.buttonId]];
                    _waitingAlert = [[AlertView alloc] initWithTitle:@""
                                                               message:@"waiting for response...."
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Cancel",nil];
                    _waitingAlert.tag=2;
                    [_waitingAlert show];
                    //[_waitingAlert release];
               // }
                
            }
            else if([gameMode isEqualToString:@"network"])
            {
                
               // NSString *unlockedValue = [[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"level%d",obj.buttonId]];
                
                
                
                
               // if ([unlockedValue isEqualToString:@"YES"])
                    
                //{
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"menuForward.mp3"];
                
                NSString *isHost=[[GameSettings shared] getGlobalForKey:@"isHost"];
                if([isHost isEqualToString:@"NO"])
                {
                    return;
                }
                
               
                    if(obj.buttonId==1||obj.buttonId==2)
                    {
                        return;
                    }
                
                
                    NSString *levelNumber=[NSString stringWithFormat:@"%d",obj.buttonId];
                    [[GameSettings shared] setGlobal:levelNumber ForKey:@"selectedLevel"];
                    NSString *buttonNumber=obj.levelNumber.string;
                    if(buttonNumber)
                    {
                        
                        [[GameSettings shared] setGlobal:buttonNumber ForKey:@"levelNumberOnButton"];
                    }
                    // NSString *pageNumber=[NSString stringWithFormat:@"%d",_scroller.currentScreen];
                    //[[GameSettings shared] setGlobal:pageNumber ForKey:@"pageNumber"];
                    [self networkShowMessage:[NSString stringWithFormat:@"%d", obj.buttonId]];
                    _waitingAlert = [[AlertView alloc] initWithTitle:@""
                                                               message:@"waiting for response...."
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Cancel",nil];
                    _waitingAlert.tag=2;
                    [_waitingAlert show];
                    //[_waitingAlert release];
               // }
                
            }
            else
            {
                //NSString *pageNumber=[NSString stringWithFormat:@"%d",_scroller.currentScreen];
               // [[GameSettings shared] setGlobal:pageNumber ForKey:@"pageNumber"];
                if([obj ButtonPressed])
                {
                    //[myTextField1 removeFromSuperview];
                    //[myTextField2 removeFromSuperview];
                }
                
                
            }
        }
    }
}


- (void)update:(ccTime)dt
{
    /*
    if(_waitToShowTextField1>0)
    {
        _waitToShowTextField1=_waitToShowTextField1-dt;
        
        if(_waitToShowTextField1<0)
        {
            player1=[CCLabelTTF labelWithString:@"Player 1" fontName:@"Impact" fontSize:HD_TEXT(16)];
            [player1 setPosition:ADJUST_CCP(ccp(100,467))];
            
            [self addChild:player1];
            
            myTextField1 = [[UITextField alloc] initWithFrame: CGRectMake(ADJUST_X(60) ,ADJUST_Y(25),HD_PIXELS(80), HD_PIXELS(25))];
            //[myTextField setBackground:[UIImage imageNamed:@"Black50.png"]];
            [myTextField1 setBackgroundColor: [UIColor whiteColor]];
            myTextField1.delegate=self;
        
            myTextField1.borderStyle=UITextBorderStyleRoundedRect;
           // myTextField1.font=[UIFont systemFontOfSize:HD_PIXELS(14)];
            myTextField1.font=[UIFont fontWithName:@"Impact" size:HD_TEXT2(14)];
            myTextField1.text=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
            myTextField1.textAlignment=UITextAlignmentCenter;
            myTextField1.tag=1;

            UIView* view = [[CCDirector sharedDirector] view];
            [view addSubview:myTextField1];

        }
    }
    if(_waitToShowTextField2>0)
    {
        _waitToShowTextField2=_waitToShowTextField2-dt;
        
        if(_waitToShowTextField2<0)
        {
            player2=[CCLabelTTF labelWithString:@"Player 2" fontName:@"Impact" fontSize:HD_TEXT(16)];
            [player2 setPosition:ADJUST_CCP(ccp(220,467))];
            [self addChild:player2];
            
            myTextField2 = [[UITextField alloc] initWithFrame: CGRectMake(ADJUST_X(180) ,ADJUST_Y(25),HD_PIXELS(80), HD_PIXELS(25))];
            //[myTextField setBackground:[UIImage imageNamed:@"Black50.png"]];
            [myTextField2 setBackgroundColor: [UIColor whiteColor]];
            myTextField2.delegate=self;
            myTextField2.borderStyle=UITextBorderStyleRoundedRect;
             //myTextField2.font=[UIFont systemFontOfSize:HD_PIXELS(14)];
            myTextField2.font=[UIFont fontWithName:@"Impact" size:HD_TEXT2(14)];
           myTextField2.text=[[GameSettings shared] getGlobalForKey:@"Player2Name"];
            myTextField2.textAlignment=UITextAlignmentCenter;
            myTextField2.tag=2;
            UIView* view = [[CCDirector sharedDirector] view];
            [view addSubview:myTextField2];
            
        }
    } 
    if(_waitToShowTextfield3>0)
    {
        _waitToShowTextfield3=_waitToShowTextfield3-dt;
        
        if(_waitToShowTextfield3<0)
        {
            player2=[CCLabelTTF labelWithString:@"Your Name" fontName:@"Impact" fontSize:HD_TEXT(16)];
            [player2 setPosition:ADJUST_CCP(ccp(160,467))];
            [self addChild:player2];
            
            myTextField1 = [[UITextField alloc] initWithFrame: CGRectMake(ADJUST_X(120) ,ADJUST_Y(25),HD_PIXELS(80), HD_PIXELS(25))];
            //[myTextField setBackground:[UIImage imageNamed:@"Black50.png"]];
            [myTextField1 setBackgroundColor: [UIColor whiteColor]];
            myTextField1.delegate=self;
            myTextField1.borderStyle=UITextBorderStyleRoundedRect;
             //myTextField1.font=[UIFont systemFontOfSize:HD_PIXELS(14)];
            myTextField1.font=[UIFont fontWithName:@"Impact" size:HD_TEXT2(14)];
          myTextField1.text=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
            myTextField1.textAlignment=UITextAlignmentCenter;
          myTextField1.tag=1;
            UIView* view = [[CCDirector sharedDirector] view];
            [view addSubview:myTextField1];
            
        }
    }    
     */
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
    

    
    
    
    [_upgradeButton update:dt];
    [nameWindow update:dt];
    
    NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];
    if([hasPurchased isEqualToString:@"NO"]&&_scroller.currentScreen==1)
    {
        //[myTextField1 setHidden:YES];
        //[myTextField2 setHidden:YES];
        //[player1 setVisible:NO];
        //[player2 setVisible:NO];
    }
    
    if([hasPurchased isEqualToString:@"NO"]&&_scroller.currentScreen==0)
    {
        //[myTextField1 setHidden:NO];
        //[myTextField2 setHidden:NO];
        //[player1 setVisible:YES];
        //[player2 setVisible:YES];
    }
}





- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    picker.delegate = nil;
    [picker autorelease];
}

-(IBAction) btnDisconnect:(id) sender {
    //[self.currentSession disconnectFromAllPeers];
    //[self.currentSession release];
    //currentSession = nil;
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
              [currentSession disconnectFromAllPeers];
            currentSession = nil;
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
- (void) session:(GKSession *)session didFailWithError:(NSError *)error
{
    
}

- (void) mySendDataToPeers:(NSMutableData *) data
{
    if (currentSession)
        [self.currentSession sendDataToAllPeers:data
                                   withDataMode:GKSendDataReliable
                                          error:nil];
}

- (void)showMessage:(NSString *)buttonID
{
     NSString *receiveInvite=[[GameSettings shared] getGlobalForKey:@"receiveInvite"];
    if([receiveInvite isEqualToString:@"NO"])
    {
        return;
    }
    
    
    [[GameSettings shared] setGlobal:@"NO" ForKey:@"receiveInvite"];
   // _receiveInvite=NO;
   //NSString *str=@"hellohello";

     NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
    NSString *islandNumber=[[GameSettings shared] getGlobalForKey:@"island"];
    NSString *newIslandName=[self getIslandName:islandNumber];
    NSString *levelNumberOnButton=[[GameSettings shared] getGlobalForKey:@"levelNumberOnButton"];
     NSString *invatationText = [NSString stringWithFormat:  @"%@ would like to play %@ level %@", playerName,newIslandName,levelNumberOnButton];
     NSString *levelNumber=buttonID;
   // [[GameSettings shared] setGlobal:playerName ForKey:@"BluePlayer"];
    [[GameSettings shared] setGlobal:@"YES" ForKey:@"touchEnable"];
    NSString *isInvitation=@"YES";
    NSString *isReply=@"NO";
    NSArray *valueArray=[NSArray arrayWithObjects:playerName,levelNumber,invatationText,isInvitation,isReply,islandNumber,levelNumberOnButton,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"PlayerName"], [NSString stringWithFormat:@"LevelNumber"],[NSString stringWithFormat:@"Text"],[NSString stringWithFormat:@"isInvation"],[NSString stringWithFormat:@"isReply"],[NSString stringWithFormat:@"islandNumber"],[NSString stringWithFormat:@"levelnumberOnButton"],nil];
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
        alert.tag=1;
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
           
            AlertView *alert = [[AlertView alloc] initWithTitle:@""
                                                            message:@"Seems your opponent doesn't like that level, please select another one."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Okay",nil];
            alert.tag=2;
            [alert show];
            [alert release];
            
        }
    }
}


- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag==3)
    {
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[MainMenu scene]]];
    }
    
    else if(alertView.tag==1)
    {
    if (buttonIndex==1) {
      
        NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
       // [[GameSettings shared] setGlobal:playerName ForKey:@"OrangePlayer"];
        //int yesOrNo = arc4random() % 2;
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
        }
        else {
            
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
            [self networkReply:@"NO"];
        }
    }
    }
    else {
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _isEditing=YES;
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
     _isEditing=NO;
    if(textField.tag==1)
    {
        if(![textField.text isEqualToString:@""])
        {
        [[GameSettings shared] setGlobal:textField.text ForKey:@"Player1Name"];
            [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player2Name"]];
            
        }
        else {
            [[GameSettings shared] setGlobal:@"Player1" ForKey:@"Player1Name"];
             [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
              [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player2Name"]];
        }
    }
    else if(textField.tag==2) {
        if(![textField.text isEqualToString:@""])
        {
        [[GameSettings shared] setGlobal:textField.text ForKey:@"Player2Name"];
             [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
              [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player1Name"]];
        }
        else {
            [[GameSettings shared] setGlobal:@"Player2" ForKey:@"Player1Name"];
             [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
              [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player1Name"]];
        }
    }
    //[textField resignFirstResponder];    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _isEditing=NO;
    if(textField.tag==1)
    {
        if(![textField.text isEqualToString:@""])
        {
            [[GameSettings shared] setGlobal:textField.text ForKey:@"Player1Name"];
             [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
              [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player2Name"]];
        }
        else {
            [[GameSettings shared] setGlobal:@"Player1" ForKey:@"Player1Name"];
             [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
              [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player2Name"]];
        }
    }
    else if(textField.tag==2) {
        if(![textField.text isEqualToString:@""])
        {
            [[GameSettings shared] setGlobal:textField.text ForKey:@"Player2Name"];
             [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
              [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player1Name"]];
        }
        else {
            [[GameSettings shared] setGlobal:@"Player2" ForKey:@"Player1Name"];
             [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
              [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player1Name"]];
        }
        
    }
   [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   
    if(textField.text.length>8 && range.length==0)
    {
        return NO;
    }
    else {
        //NSLog(@"%@",string);
        //NSLog(@"%d",range.location);
        //NSLog(@"%d",range.length);
        return YES;
    }
}

-(void)updateDlcLevels
{
    CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
    
    [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseLevelMenu scene]]];
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

- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state
{
    switch (state)
    {
        case GKPlayerStateConnected:
            // handle a new player connection.
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
- (BOOL)match:(GKMatch *)match shouldReinvitePlayer:(NSString *)playerID
{
    return NO;
}
- (void)match:(GKMatch *)match didReceiveData:(NSMutableData *)data fromPlayer:(NSString *)playerID
{
    NSMutableData *newData = data;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:newData];
    NSDictionary *infoList = [unarchiver decodeObjectForKey:@"Data"] ;
    [unarchiver finishDecoding];
    [unarchiver release];
    //[newData release];
    
    
    NSString *isInvation=[infoList objectForKey:@"isInvation"];
    NSString *isReply=[infoList objectForKey:@"isReply"];
    NSString *receiveInvite=[[GameSettings shared] getGlobalForKey:@"receiveInvite"];
    if([isInvation isEqualToString:@"YES"]&&[isReply isEqualToString:@"NO"]&&![receiveInvite isEqualToString:@"NO"])    {
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
        alert.tag=1;
        [alert show];
        [alert release];
    }
    else if([isInvation isEqualToString:@"NO"]&&[isReply isEqualToString:@"YES"])
    {
          [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
        NSString *answer=[infoList objectForKey:@"answer"];
        
        if([answer isEqualToString:@"YES"])
        {
           // NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
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
            
             AlertView *alert = [[AlertView alloc] initWithTitle:@""
             message:@"Seems your opponent doesn't like that level, please select another one."
             delegate:self
             cancelButtonTitle:nil
             otherButtonTitles:@"Okay",nil];
            alert.tag=2;
             [alert show];
             [alert release];
             
        }
    }
 
}
- (void)networkShowMessage:(NSString *)buttonID
{
    NSString *receiveInvite=[[GameSettings shared] getGlobalForKey:@"receiveInvite"];
    if([receiveInvite isEqualToString:@"NO"])
    {
        return;
    }
  
    [[GameSettings shared] setGlobal:@"NO" ForKey:@"receiveInvite"];
    //_receiveInvite=NO;
    //NSString *str=@"hellohello";

   // NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
    NSString *playerName=	[[GKLocalPlayer localPlayer] alias];
    NSString *islandNumber=[[GameSettings shared] getGlobalForKey:@"island"];
    NSString *newIslandName=[self getIslandName:islandNumber];
    NSString *levelNumberOnButton=[[GameSettings shared] getGlobalForKey:@"levelNumberOnButton"];
    NSString *invatationText = [NSString stringWithFormat:  @"%@ would like to play %@ level %@", playerName,newIslandName,levelNumberOnButton];
    NSString *levelNumber=buttonID;
   // [[GameSettings shared] setGlobal:playerName ForKey:@"BluePlayer"];
    [[GameSettings shared] setGlobal:@"YES" ForKey:@"touchEnable"];
    NSString *isInvitation=@"YES";
    NSString *isReply=@"NO";
    NSArray *valueArray=[NSArray arrayWithObjects:playerName,levelNumber,invatationText,isInvitation,isReply,islandNumber,levelNumberOnButton,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"PlayerName"], [NSString stringWithFormat:@"LevelNumber"],[NSString stringWithFormat:@"Text"],[NSString stringWithFormat:@"isInvation"],[NSString stringWithFormat:@"isReply"],[NSString stringWithFormat:@"islandNumber"],[NSString stringWithFormat:@"levelnumberOnButton"],nil];
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
-(void)networkReply:(NSString *)yesOrNo
{
   // NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
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
    //NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
       NSString *playerName=[[GKLocalPlayer localPlayer] alias];
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

- (void)dealloc
{
    [_buttonArray1 release];
    [_buttonArray2 release];
    [_buttonArray3 release];
    [_waitingAlert release];
      [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"SeaSunshine.plist" ];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"ChooseLevelSprites.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MenuBackground.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"Black50.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"upgradeSprite.plist"];
    [super dealloc];
    
    
}

@end
