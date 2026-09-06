//
//  MainMenu.h
//  Grid
//
//  Created by Yang Song on 5/8/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "InputNameWindow.h"
#import "DlcLevelDelegate.h"

@class Button;
@interface MainMenu : CCLayer<GKPeerPickerControllerDelegate,GKSessionDelegate,GKMatchDelegate,GKMatchmakerViewControllerDelegate,DlcLevelDelegate>
{
     CCSprite *_soundButton;
    CCSprite *_light1;
    CCSprite *_light2;
    
    
    Button *_singlePlayerIcon;
    Button *_twoPlayerIcon;
    Button *_oneDeviceIcon;
    Button *_blueToothIcon;
    Button *_networkIcon;
    Button *_fullversionIcon;
    
    
    
    Button *_singlePlayerButton;
    Button *_twoPlayersButton;
    Button *_fullVersionButton;
    Button *_oneDeviceButton;
    Button *_blueToothButton;
    Button *_networkButton;
    Button *_faceBookIcon;
    Button *_twitterIcon;
    Button *_goBackButton;
    CCSprite *_logo;
    Button *_creditsButton;
    Button *_rateButton;
    Button *_leaderboardButton;
    Button *_nameButton;
    
    CCSprite *_sunshine1;
    CCSprite *_sunshine2;
    CCSprite *_sunshine3;
    BOOL _singleAndTwoPlayerButtonShowing;
    BOOL _OneDeviceAndBlueToothButtonShowing;
    BOOL _isSoundOn;
    float _waitToSwitchToSoloMode;
    float _waitToSwitchToBluetoothMode;
    float _waitToSwitchToInternetMode;
    float _waitToShowLight1;
    float _waitToShowSoundButton;
    float _waitToFadeInLogo;
    float _waitToShowSunshine1;
    float _waitToShowSunshine2;
    float _waitToShowSunshine3;
 
    float _waitToPlayLogoAnimation;
    //GKSession *currentSession;
    GKPeerPickerController *_picker;
    GKMatch *myMatch;
     InputNameWindow *nameWindow;
    
}
//@property (nonatomic, retain) GKSession *currentSession;
@property (nonatomic, retain) GKPeerPickerController *picker;
+(CCScene *) scene;
@end
