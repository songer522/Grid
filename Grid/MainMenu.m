//
//  MainMenu.m
//  Grid
//
//  Created by Yang Song on 5/8/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "MainMenu.h"
#import "DeviceSettings.h"
#import "Button.h"
#import "ChooseLevelMenu.h"
#import "ChooseIslandMenu.h"
#import "GameSettings.h"
#import "UpgradeMenu.h"
#import "SimpleAudioEngine.h"
#import "GCHelper.h"
#import "CreditsMenu.h"
#import "InAppPurchaseManager.h"
@implementation MainMenu
//@synthesize currentSession;
@synthesize picker=_picker;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init])) {
        
		
		// ask director the the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
		
        
        _waitToSwitchToSoloMode=0;
        _OneDeviceAndBlueToothButtonShowing=NO;
        _singleAndTwoPlayerButtonShowing=YES;
        _isSoundOn=YES;
         [[GameSettings shared] setGlobal:@"" ForKey:@"gameMode"];
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
         
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MainMenuSprites.plist" ];
        	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ChooseLevelSprites.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Black50.plist" ];
  
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MenuBackground.plist" ];   
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SeaSunshine.plist" ]; 
         [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        [self loadUI];
        [[InAppPurchaseManager shared] loadStoreWithDelegate:self];
        /*
        NSString *player1Name=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
        if([player1Name isEqualToString:@""])
        {
            [[GameSettings shared] setGlobal:@"Player 1" ForKey:@"Player1Name"];
        }
        NSString *player2Name=[[GameSettings shared] getGlobalForKey:@"Player2Name"];
        if([player2Name isEqualToString:@""])
        {
            [[GameSettings shared] setGlobal:@"Player 2" ForKey:@"Player2Name"];
        }
         */
    
       
          [self schedule:@selector(update:)];
      
        
        
	}
	return self;
}

- (void)loadUI
{
    CCSprite *background=[CCSprite spriteWithSpriteFrameName:@"Graphic_MainMenuBack.png"];
    [background setPosition:ADJUST_CCP(ccp(160,240))];
    
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

    if(_isSoundOn)
    {
    _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOn.png"];
        [_soundButton setOpacity:0];
    }
    else {
        _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOff.png"];
        [_soundButton setOpacity:0];
    }
 
    [_soundButton setPosition:ADJUST_CCP(ccp(290,445))];
    /*
    _light1=[CCSprite spriteWithSpriteFrameName:@"Graphic_Light_1.png"];
    [_light1 setOpacity:0];
    [_light1 setPosition:ADJUST_CCP(ccp(160,240))];
    _light2=[CCSprite spriteWithSpriteFrameName:@"Graphic_Light_2.png"];
    [_light2 setOpacity:0];
     [_light2 setPosition:ADJUST_CCP(ccp(160,240))];
   // [self addChild:_light1];
    //[self addChild:_light2];
    */
    _creditsButton=[Button buttonAtPosition:ADJUST_CCP(ccp(240,445)) andImage:@"Button_CreditsList.png"];
    [_creditsButton.buttonGraphic setOpacity:0];
    _creditsButton.waitToFadeInButton=1.5;
    _leaderboardButton=[Button buttonAtPosition:ADJUST_CCP(ccp(30,445)) andImage:@"Button_LeaderBoard.png"];
    [_leaderboardButton.buttonGraphic setOpacity:0];
    _leaderboardButton.waitToFadeInButton=1.5;
    _nameButton=[Button buttonAtPosition:ADJUST_CCP(ccp(80,445)) andImage:@"Button_Credits.png"];
    [_nameButton.buttonGraphic setOpacity:0];
    _nameButton.waitToFadeInButton=1.5;
     _waitToShowSoundButton=1.5;
    _singlePlayerButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,154)) andImage:@"Button_SoloMode.png"];
    [_singlePlayerButton.buttonGraphic setOpacity:0];
    _singlePlayerButton.waitToFadeInButton=1.5;
    _twoPlayersButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,179)) andImage:@"Button_TwoPlayers.png"];
    [_twoPlayersButton.buttonGraphic setOpacity:0];
    _twoPlayersButton.waitToFadeInButton=1.5;
    _fullVersionButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,119)) andImage:@"Button_FullVersion.png"];
    [_fullVersionButton.buttonGraphic setOpacity:0];
    _fullVersionButton.waitToFadeInButton=1.5;
    _logo=[CCSprite spriteWithSpriteFrameName:@"Graphic_MainLogo_1.png"];
    [_logo setPosition:ADJUST_CCP(ccp(160,280))];
    [_logo setOpacity:0];
    
    
    _singlePlayerIcon=[Button buttonAtPosition:ADJUST_CCP(ccp(160,234)) andImage:@"AniIcon_Icon1_1.png"];
    [_singlePlayerIcon.buttonGraphic setOpacity:0];
    _singlePlayerIcon.waitToFadeInButton=1.5;
    _twoPlayerIcon=[Button buttonAtPosition:ADJUST_CCP(ccp(160,234)) andImage:@"AniIcon_Icon2_1.png"];
    [_twoPlayerIcon.buttonGraphic setOpacity:0];
    _twoPlayerIcon.waitToFadeInButton=1.5;
    _oneDeviceIcon=[Button buttonAtPosition:ADJUST_CCP(ccp(160,234)) andImage:@"AniIcon_Icon4_1.png"];
    [_oneDeviceIcon.buttonGraphic setOpacity:0];
   // _oneDeviceIcon.waitToFadeInButton=1.5;
    _blueToothIcon=[Button buttonAtPosition:ADJUST_CCP(ccp(160,234)) andImage:@"AniIcon_Icon5_1.png"];
    [_blueToothIcon.buttonGraphic setOpacity:0];
    //_blueToothIcon.waitToFadeInButton=1.5;
    _networkIcon=[Button buttonAtPosition:ADJUST_CCP(ccp(160,234)) andImage:@"AniIcon_Icon6_1.png"];
    [_networkIcon.buttonGraphic setOpacity:0];
    //_networkIcon.waitToFadeInButton=1.5;
    _fullversionIcon=[Button buttonAtPosition:ADJUST_CCP(ccp(160,234)) andImage:@"AniIcon_Icon3_1.png"];
    [_fullversionIcon.buttonGraphic setOpacity:0];
    _fullversionIcon.waitToFadeInButton=1.5;
    
    
    
    //_logo=[Button buttonAtPosition:ADJUST_CCP(ccp(160,280)) andImage:@"Graphic_MainLogo.png"];
     //[_logo.buttonGraphic setOpacity:0];
    
    _oneDeviceButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,154)) andImage:@"Button_OneDevice.png"];
    _blueToothButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,179)) andImage:@"Button_Bluetooth.png"];
    _networkButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,119)) andImage:@"Button_NetworkMode.png"];
    
    //_faceBookIcon=[Button buttonAtPosition:ADJUST_CCP(ccp(30,455)) andImage:@"Button_Facebook.png"];
    //_twitterIcon=[Button buttonAtPosition:ADJUST_CCP(ccp(85,455)) andImage:@"Button_Twitter.png"];
    
    _goBackButton=[Button buttonAtPosition:ADJUST_CCP(ccp(30,445)) andImage:@"Button_GoBack.png"];
    [_oneDeviceButton.buttonGraphic setOpacity:0];
    [_blueToothButton.buttonGraphic setOpacity:0];
    [_networkButton.buttonGraphic setOpacity:0];
    [_goBackButton.buttonGraphic setOpacity:0];
    [self addChild:_soundButton];
    [self addChild:_singlePlayerButton];
    [self addChild:_twoPlayersButton];
    [self addChild:_singlePlayerIcon];
    [self addChild:_twoPlayerIcon];
    [self addChild:_logo];
   
    //_logo.waitToFadeInButton=1.0;
    _waitToFadeInLogo=1.0;
      
    id moveAction=[CCMoveTo actionWithDuration:1.0 position:ADJUST_CCP(ccp(160,340))];
    [_logo runAction:moveAction];
   // [[GameSettings shared] setGlobal:@"YES" ForKey:@"HasPurchased"];
 NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];
    if([hasPurchased isEqualToString:@""])
    {
    [[GameSettings shared] setGlobal:@"NO" ForKey:@"HasPurchased"];
         //[self addChild:_fullVersionButton];
    }
   // NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];
    if([hasPurchased isEqualToString:@"NO"])
    {
   // [self addChild:_fullVersionButton];
       // [self addChild:_fullversionIcon];
    }
    [self addChild:_oneDeviceButton];
    [self addChild:_blueToothButton];
    [self addChild:_networkButton];
    [self addChild:_oneDeviceIcon];
    [self addChild:_blueToothIcon];
    [self addChild:_networkIcon];
     [self addChild:_fullVersionButton];
     [self addChild:_fullversionIcon];
    //[self addChild:_faceBookIcon];
    //[self addChild:_twitterIcon];
    
    [self addChild:_creditsButton];
    [self addChild:_leaderboardButton];
    [self addChild:_nameButton];
    [self addChild:_goBackButton];
    //_waitToShowLight1=1.5;
  
       
    
    if(![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
    {
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"MenuMusic.mp3"];
    }
    NSString *player1Name=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
     if([player1Name isEqualToString:@""])
    {
        nameWindow= [InputNameWindow InputNameWindowInController:self];
        [self addChild:nameWindow];
    }
}



-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    if (touchOrigin2.x>ADJUST_X(30) && touchOrigin2.x<ADJUST_X(290) && touchOrigin2.y>ADJUST_Y(169) && touchOrigin2.y<ADJUST_Y(234))
    {
        if(_singleAndTwoPlayerButtonShowing)
        {
        [_singlePlayerButton playbuttonAnimation];
            [_singlePlayerIcon playIconAnimation];
        _singlePlayerButton.waitToFadeOutButton=1.5;
        _twoPlayersButton.waitToFadeOutButton=1.5;
        _fullVersionButton.waitToFadeOutButton=1.5;
            _singlePlayerIcon.waitToFadeOutButton=1.5;
            _twoPlayerIcon.waitToFadeOutButton=1.5;
            _fullversionIcon.waitToFadeOutButton=1.5;
           // _logo.waitToFadeOutButton=1.5;
            
        _waitToSwitchToSoloMode=0.5;
            
            [[GameSettings shared] setGlobal:@"solo" ForKey:@"gameMode"];
        }
        else if(_OneDeviceAndBlueToothButtonShowing) {
            
            [_oneDeviceButton playbuttonAnimation];
            [_oneDeviceIcon playIconAnimation];
            _oneDeviceButton.waitToFadeOutButton=1.5;
            _blueToothButton.waitToFadeOutButton=1.5;
            _oneDeviceIcon.waitToFadeOutButton=1.5;
            _blueToothIcon.waitToFadeOutButton=1.5;
            [[GameSettings shared] setGlobal:@"oneDevice" ForKey:@"gameMode"];
            _waitToSwitchToSoloMode=0.5;
            
        }
        
        
        
    }
    
    if (touchOrigin2.x>ADJUST_X(30) && touchOrigin2.x<ADJUST_X(290) && touchOrigin2.y>ADJUST_Y(114) && touchOrigin2.y<ADJUST_Y(159))
    {
        if(_singleAndTwoPlayerButtonShowing)
        {
        [_twoPlayersButton playbuttonAnimation];
            [_twoPlayerIcon playIconAnimation];
        _singlePlayerButton.waitToFadeOutButton=1.5;
        _twoPlayersButton.waitToFadeOutButton=1.5;
            _fullVersionButton.waitToFadeOutButton=1.5;
            _singlePlayerIcon.waitToFadeOutButton=1.5;
            _twoPlayerIcon.waitToFadeOutButton=1.5;
            _fullversionIcon.waitToFadeOutButton=1.5;
            //_faceBookIcon.waitToFadeOutButton=1.5;
           // _twitterIcon.waitToFadeOutButton=1.5;
            _rateButton.waitToFadeOutButton=1.5;
            _networkButton.waitToFadeInButton=1.5;
           // _logo.waitToFadeOutButton=1.5;
        _oneDeviceButton.waitToFadeInButton=1.5;
        _blueToothButton.waitToFadeInButton=1.5;
            _goBackButton.waitToFadeInButton=1.5;
            _oneDeviceIcon.waitToFadeInButton=1.5;
            _blueToothIcon.waitToFadeInButton=1.5;
            _networkIcon.waitToFadeInButton=1.5;
            _singleAndTwoPlayerButtonShowing=NO;
            _OneDeviceAndBlueToothButtonShowing=YES;

        }
        else if(_OneDeviceAndBlueToothButtonShowing)
        {
            [_blueToothButton playbuttonAnimation];
            [_blueToothIcon playIconAnimation];
            //_oneDeviceButton.waitToFadeOutButton=1.5;
            //_blueToothButton.waitToFadeOutButton=1.5;
            
            //_waitToSwitchToSoloMode=0.5;
            
           // NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];
           // if([hasPurchased isEqualToString:@"NO"])
            //{
                
            //}
            
           // else{
                [[GameSettings shared] setGlobal:@"blueTooth" ForKey:@"gameMode"];
                _waitToSwitchToBluetoothMode=0.5;
            //}
            
        }

        
       
    }
    
    if (touchOrigin2.x>ADJUST_X(30) && touchOrigin2.x<ADJUST_X(290) && touchOrigin2.y>ADJUST_Y(49) && touchOrigin2.y<ADJUST_Y(104))
    {
        
         if(_singleAndTwoPlayerButtonShowing)
         {
       // NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];
       // if([hasPurchased isEqualToString:@"NO"])
       // {
        [_fullVersionButton playbuttonAnimation];
            [_fullversionIcon playIconAnimation];
            [[InAppPurchaseManager shared] restorePurchaseWithDelegate:self];
            // [[GameSettings shared] setGlobal:@"MainMenu" ForKey:@"UpgradeMenuBackTo"];
        //CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        
        //[director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[UpgradeMenu scene]]];
       // }
             
         }
                 else if(_OneDeviceAndBlueToothButtonShowing)
         {
             [_networkButton playbuttonAnimation];
             [_networkIcon playIconAnimation];
              [[GameSettings shared] setGlobal:@"network" ForKey:@"gameMode"];
             _waitToSwitchToInternetMode=0.5;
             
         }
    }
    if (touchOrigin2.x>ADJUST_X(10) && touchOrigin2.x<ADJUST_X(50) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(465))
    {
        if(_singleAndTwoPlayerButtonShowing)
        {
            [_leaderboardButton playbuttonAnimation];
            [[GCHelper sharedInstance] showLeaderboards];
        //[_rateButton playbuttonAnimation];
       //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=528946561&onlyLatestVersion=false&type=Purple+Software"]];
        }
        else if(_OneDeviceAndBlueToothButtonShowing) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"menuBack.wav"];
            _oneDeviceButton.waitToFadeOutButton=0.5;
            _blueToothButton.waitToFadeOutButton=0.5;
            _networkButton.waitToFadeOutButton=0.5;
            _oneDeviceIcon.waitToFadeOutButton=0.5;
            _blueToothIcon.waitToFadeOutButton=0.5;
            _networkIcon.waitToFadeOutButton=0.5;
            _singlePlayerButton.waitToFadeInButton=0.5;
            _twoPlayersButton.waitToFadeInButton=0.5;
            _fullVersionButton.waitToFadeInButton=0.5;
            _singlePlayerIcon.waitToFadeInButton=0.5;
            _twoPlayerIcon.waitToFadeInButton=0.5;
            _fullversionIcon.waitToFadeInButton=0.5;
            _goBackButton.waitToFadeOutButton=0.5;
            _faceBookIcon.waitToFadeInButton=0.5;
            _twitterIcon.waitToFadeInButton=0.5;
            _rateButton.waitToFadeInButton=0.5;
            // _logo.waitToFadeInButton=0.5;
            _singleAndTwoPlayerButtonShowing=YES;
            _OneDeviceAndBlueToothButtonShowing=NO;

        }
    }
    
    if (touchOrigin2.x>ADJUST_X(220) && touchOrigin2.x<ADJUST_X(260) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(465))
    {
        [_creditsButton playbuttonAnimation];
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        
        [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[CreditsMenu scene]]];
    }
    if (touchOrigin2.x>ADJUST_X(50) && touchOrigin2.x<ADJUST_X(100) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(465))
    {
       
            [_nameButton playbuttonAnimation];
            
            nameWindow= [InputNameWindow InputNameWindowInController:self];
            [self addChild:nameWindow];
        
        
        
        
    }

    
    if (touchOrigin2.x>ADJUST_X(50) && touchOrigin2.x<ADJUST_X(90) && touchOrigin2.y>ADJUST_Y(445) && touchOrigin2.y<ADJUST_Y(465))
    {
        if(_OneDeviceAndBlueToothButtonShowing)
        {
            //[_goBackButton playbuttonAnimation];
                    }
    }
    
    if (touchOrigin2.x>ADJUST_X(260) && touchOrigin2.x<ADJUST_X(320) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(465))
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
       
    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
       
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    }
-(void)playLogoAnimation
{
    CCAnimation *logoAnimation=[CCAnimation animation];
    [logoAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_MainLogo_1.png"]];
    [logoAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_MainLogo_2.png" ]];
    [logoAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_MainLogo_3.png"]];
    [logoAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_MainLogo_2.png"]];
    
    
    //id cannonAnimationAction=[CCAnimate actionWithDuration:0.5 animation:cannonAnimation restoreOriginalFrame:NO];
    
    logoAnimation.restoreOriginalFrame=NO;
    logoAnimation.delayPerUnit=0.7/logoAnimation.frames.count;
    
    [_logo runAction:[[[CCAnimate alloc] initWithAnimation:logoAnimation] autorelease]];
    _waitToPlayLogoAnimation=0.7;

}



- (void)update:(ccTime)dt
{
    
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
    
    
    
    [_nameButton update:dt];
    [_leaderboardButton update:dt];

    [nameWindow update:dt];
    [_singlePlayerButton update:dt];
    [_twoPlayersButton update:dt];
    [_blueToothButton update:dt];
    [_oneDeviceButton update:dt];
    [_goBackButton update:dt];
    [_singlePlayerIcon update:dt];
    [_twoPlayerIcon update:dt];
    [_fullversionIcon update:dt];
    [_oneDeviceIcon update:dt];
    [_networkIcon update:dt];
    [_blueToothIcon update:dt];
    //[_twitterIcon update:dt];
    //[_faceBookIcon update:dt];
    [_networkButton update:dt];
    [_fullVersionButton update:dt];
    [_creditsButton update:dt];
    [_rateButton update:dt];
    if(_waitToSwitchToSoloMode>0)
    {
        _waitToSwitchToSoloMode=_waitToSwitchToSoloMode-dt;
       
        if(_waitToSwitchToSoloMode<0)
        {
            CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
            
            [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseIslandMenu scene]]];
        }
    }   
    if(_waitToShowSoundButton>0)
    {
        _waitToShowSoundButton=_waitToShowSoundButton-dt;
        
        if(_waitToShowSoundButton<0.5&&_waitToShowSoundButton>0)
            [_soundButton setOpacity:(0.5-_waitToShowSoundButton)*510]; 
           // [_logo setOpacity:(0.5-_waitToShowSoundButton)*510]; 
    
        if(_waitToShowSoundButton<0)
        {
            [_soundButton setOpacity:255];
           // [_logo setOpacity:255];
            //_waitToFadeOutButton=3.0;
        }

    } 
    
    if(_waitToFadeInLogo>0)
    {
        _waitToFadeInLogo=_waitToFadeInLogo-dt;
        if(_waitToFadeInLogo<0.5&&_waitToFadeInLogo>0)
            [_logo setOpacity:(0.5-_waitToFadeInLogo)*510]; 
        if(_waitToFadeInLogo<0)
        {
            [_logo setOpacity:255];
            //_waitToFadeOutButton=3.0;
            _waitToPlayLogoAnimation=1.0;
        }
    }
    
    if(_waitToPlayLogoAnimation>0)
    {
        _waitToPlayLogoAnimation=_waitToPlayLogoAnimation-dt;
        
         
        if(_waitToPlayLogoAnimation<0)
        {
           // [_logo setOpacity:255];
            //_waitToFadeOutButton=3.0;
            [self playLogoAnimation];
        }
    }
    
    if(_waitToSwitchToBluetoothMode>0)
    {
        _waitToSwitchToBluetoothMode=_waitToSwitchToBluetoothMode-dt;
        
        if(_waitToSwitchToBluetoothMode<0)
        {
            _picker = [[GKPeerPickerController alloc] init];
            _picker.delegate = self;
            _picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
            
            [_picker show];

                  }
    }
    
    if(_waitToSwitchToInternetMode>0)
    {
        _waitToSwitchToInternetMode=_waitToSwitchToInternetMode-dt;
        
        if(_waitToSwitchToInternetMode<0)
        {
            GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
            request.minPlayers = 2;
            request.maxPlayers = 2;
            
            GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
            
            mmvc.matchmakerDelegate = self;
            
            [  [CCDirector sharedDirector].parentViewController  presentModalViewController:mmvc animated:YES];          
        }
    } 
    

    
    /*
    if(_waitToShowLight1>0)
    {
        _waitToShowLight1=_waitToShowLight1-dt;
        
       
        if(_waitToShowLight1>1.2 && _waitToShowLight1<1.5)
        {
            [_light1 setOpacity:51];
            [_light2 setOpacity:204];
        }
        else if(_waitToShowLight1>0.9 && _waitToShowLight1<1.2)
        {
            [_light1 setOpacity:102];
            [_light2 setOpacity:153];
        }
        else if(_waitToShowLight1>0.6 && _waitToShowLight1<0.9)
        {
            [_light1 setOpacity:153];
            [_light2 setOpacity:102];
        }
        else if(_waitToShowLight1>0.3 && _waitToShowLight1<0.6)
        {
            [_light1 setOpacity:204];
            [_light2 setOpacity:51];
        }
        
        else if(_waitToShowLight1>0)
        {
            [_light1 setOpacity:255];
            [_light2 setOpacity:0];
           
        }
        else if(_waitToShowLight1<0)
        {
             _waitToShowLight1=1.5;
        }
        
    }
     */

}

- (void)dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MainMenuSprites.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MenuBackground.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"ChooseLevelSprites.plist" ];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"Black50.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"SeaSunshine.plist" ];
    
        [super dealloc];
  
}



- (void)peerPickerController:(GKPeerPickerController *)picker
              didConnectPeer:(NSString *)peerID
                   toSession:(GKSession *) session {
    //self.currentSession = session;
    //session.delegate = self;
    //[session setDataReceiveHandler:self withContext:nil];
    
    [[GameSettings shared] saveObj:session ForKey:@"session"];
    
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
     CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
    
    [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseIslandMenu scene]]];

}


- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    picker.delegate = nil;
    [picker autorelease];
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
          //  [self.currentSession release];
            //currentSession = nil;
            
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
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [[[CCDirector sharedDirector] parentViewController] dismissModalViewControllerAnimated:YES];
    // implement any specific code in your application here.
}
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [[[CCDirector sharedDirector] parentViewController] dismissModalViewControllerAnimated:YES];
    // Display the error to the user.
      NSLog(@"error");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Can't find internet connection"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Okay",nil];
    [alert show];
    [alert release];

}
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    [[[CCDirector sharedDirector] parentViewController] dismissModalViewControllerAnimated:YES];
    NSLog(@"find a match");
    myMatch = match; // Use a retaining property to retain the match.
    myMatch.delegate = self;
    

     [[GameSettings shared] saveObj:match ForKey:@"GKMatch"];
    CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
    
    [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseIslandMenu scene]]];
    
    //if (!self.matchStarted && match.expectedPlayerCount == 0)
    //{
      //  self.matchStarted = YES;
        // Insert application-specific code to begin the match.
    //}
}


- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    
}

#pragma mark DLC

-(void)updateDlcLevels
{
    //CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
    
    //[director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseIslandMenu scene]]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Purchases restored."
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}
-(void)restoreFails
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Purchases restored."
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)openErrorWindowCantConnectToStore
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!"
                                                    message:@"Cannot connect to the store at this time. Please try again later."
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
-(void)openErrorWindowCantMakePurchases
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!"
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




@end
