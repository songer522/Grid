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
#import "GameSettings.h"
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
        
        NSString *soundSetting=[[GameSettings shared] getGlobalForKey:@"isSoundOn"];
        if([soundSetting isEqualToString:@"NO"])
        {
            _isSoundOn=NO;
        }
        else 
        {
            _isSoundOn=YES;
        }
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MainMenuSprites.plist" ];
  
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MenuBackground.plist" ];      
        
        [self loadUI];
         [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
          [self schedule:@selector(update:)];
      
        
        
	}
	return self;
}

- (void)loadUI
{
    CCSprite *background=[CCSprite spriteWithSpriteFrameName:@"Graphic_MainMenuBack.png"];
    [background setPosition:ADJUST_CCP(ccp(160,240))];
    
    [self addChild: background];
    
    if(_isSoundOn)
    {
    _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOn.png"];
    }
    else {
        _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOff.png"];
    }
    [_soundButton setPosition:ADJUST_CCP(ccp(290,455))];
    
    _singlePlayerButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,205)) andImage:@"Button_SoloMode.png"];
    _twoPlayersButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,205)) andImage:@"Button_TwoPlayers.png"];
    
    _oneDeviceButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,205)) andImage:@"Button_OneDevice.png"];
    _blueToothButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,205)) andImage:@"Button_Bluetooth.png"];
    
    _faceBookIcon=[Button buttonAtPosition:ADJUST_CCP(ccp(30,455)) andImage:@"Button_Facebook.png"];
    _twitterIcon=[Button buttonAtPosition:ADJUST_CCP(ccp(85,455)) andImage:@"Button_Twitter.png"];
    
    _goBackButton=[Button buttonAtPosition:ADJUST_CCP(ccp(30,455)) andImage:@"Button_GoBack.png"];
    [_oneDeviceButton.buttonGraphic setOpacity:0];
    [_blueToothButton.buttonGraphic setOpacity:0];
    [_goBackButton.buttonGraphic setOpacity:0];
    [self addChild:_soundButton];
    [self addChild:_singlePlayerButton];
    [self addChild:_twoPlayersButton];
    [self addChild:_oneDeviceButton];
    [self addChild:_blueToothButton];
    [self addChild:_faceBookIcon];
    [self addChild:_twitterIcon];
    [self addChild:_goBackButton];
}



-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    if (touchOrigin2.x>ADJUST_X(30) && touchOrigin2.x<ADJUST_X(290) && touchOrigin2.y>ADJUST_Y(215) && touchOrigin2.y<ADJUST_Y(290))
    {
        if(_singleAndTwoPlayerButtonShowing)
        {
        [_singlePlayerButton playbuttonAnimation];
        _singlePlayerButton.waitToFadeOutButton=1.5;
        _twoPlayersButton.waitToFadeOutButton=1.5;
        
        _waitToSwitchToSoloMode=0.5;
            
            [[GameSettings shared] setGlobal:@"solo" ForKey:@"gameMode"];
        }
        else if(_OneDeviceAndBlueToothButtonShowing) {
            
            [_oneDeviceButton playbuttonAnimation];
            _oneDeviceButton.waitToFadeOutButton=1.5;
            _blueToothButton.waitToFadeOutButton=1.5;
            [[GameSettings shared] setGlobal:@"oneDevice" ForKey:@"gameMode"];
            _waitToSwitchToSoloMode=0.5;
            
        }
        
        
        
    }
    
    if (touchOrigin2.x>ADJUST_X(30) && touchOrigin2.x<ADJUST_X(290) && touchOrigin2.y>ADJUST_Y(130) && touchOrigin2.y<ADJUST_Y(205))
    {
        if(_singleAndTwoPlayerButtonShowing)
        {
        [_twoPlayersButton playbuttonAnimation];
        
        _singlePlayerButton.waitToFadeOutButton=1.5;
        _twoPlayersButton.waitToFadeOutButton=1.5;
            _faceBookIcon.waitToFadeOutButton=1.5;
            _twitterIcon.waitToFadeOutButton=1.5;
        _oneDeviceButton.waitToFadeInButton=1.5;
        _blueToothButton.waitToFadeInButton=1.5;
            _goBackButton.waitToFadeInButton=1.5;
            _singleAndTwoPlayerButtonShowing=NO;
            _OneDeviceAndBlueToothButtonShowing=YES;

        }
        
        else if(_OneDeviceAndBlueToothButtonShowing)
        {
            [_blueToothButton playbuttonAnimation];
            //_oneDeviceButton.waitToFadeOutButton=1.5;
            //_blueToothButton.waitToFadeOutButton=1.5;
            
            //_waitToSwitchToSoloMode=0.5;
            [[GameSettings shared] setGlobal:@"blueTooth" ForKey:@"gameMode"];
            _waitToSwitchToBluetoothMode=0.5;
        }
    }
    
    if (touchOrigin2.x>ADJUST_X(10) && touchOrigin2.x<ADJUST_X(50) && touchOrigin2.y>ADJUST_Y(445) && touchOrigin2.y<ADJUST_Y(465))
    {
        if(_OneDeviceAndBlueToothButtonShowing)
        {
            //[_goBackButton playbuttonAnimation];
            _oneDeviceButton.waitToFadeOutButton=0.5;
            _blueToothButton.waitToFadeOutButton=0.5;
            _singlePlayerButton.waitToFadeInButton=0.5;
            _twoPlayersButton.waitToFadeInButton=0.5;
            _goBackButton.waitToFadeOutButton=0.5;
            _faceBookIcon.waitToFadeInButton=0.5;
            _twitterIcon.waitToFadeInButton=0.5;
            _singleAndTwoPlayerButtonShowing=YES;
            _OneDeviceAndBlueToothButtonShowing=NO;
        }
    }
    
    if (touchOrigin2.x>ADJUST_X(260) && touchOrigin2.x<ADJUST_X(320) && touchOrigin2.y>ADJUST_Y(425) && touchOrigin2.y<ADJUST_Y(480))
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
       
    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
       
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    }




- (void)update:(ccTime)dt
{
    [_singlePlayerButton update:dt];
    [_twoPlayersButton update:dt];
    [_blueToothButton update:dt];
    [_oneDeviceButton update:dt];
    [_goBackButton update:dt];
    [_twitterIcon update:dt];
    [_faceBookIcon update:dt];
    if(_waitToSwitchToSoloMode>0)
    {
        _waitToSwitchToSoloMode=_waitToSwitchToSoloMode-dt;
       
        if(_waitToSwitchToSoloMode<0)
        {
            CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
            
            [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseLevelMenu scene]]];
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

}

- (void)dealloc
{
    [super dealloc];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MainMenuSprites.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MenuBackground.plist"];
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
    
    [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseLevelMenu scene]]];

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
          //  [self.currentSession release];
            //currentSession = nil;
            
            break;
    }
}
- (void) session:(GKSession *)session didFailWithError:(NSError *)error
{
    
}
@end
