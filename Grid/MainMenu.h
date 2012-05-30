//
//  MainMenu.h
//  Grid
//
//  Created by Yang Song on 5/8/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"

@class Button;
@interface MainMenu : CCLayer<GKPeerPickerControllerDelegate,GKSessionDelegate>
{
     CCSprite *_soundButton;
    
    Button *_singlePlayerButton;
    Button *_twoPlayersButton;
    Button *_fullVersionButton;
    Button *_oneDeviceButton;
    Button *_blueToothButton;
    Button *_networkButton;
    Button *_faceBookIcon;
    Button *_twitterIcon;
    Button *_goBackButton;
    Button *_logo;
    Button *_creditsButton;
    Button *_rateButton;
    BOOL _singleAndTwoPlayerButtonShowing;
    BOOL _OneDeviceAndBlueToothButtonShowing;
    BOOL _isSoundOn;
    float _waitToSwitchToSoloMode;
    float _waitToSwitchToBluetoothMode;
    //GKSession *currentSession;
    GKPeerPickerController *_picker;
    
}
//@property (nonatomic, retain) GKSession *currentSession;
@property (nonatomic, retain) GKPeerPickerController *picker;
+(CCScene *) scene;
@end
