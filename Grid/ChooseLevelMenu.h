//
//  ChooseLevelMenu.h
//  Grid
//
//  Created by Yang Song on 5/3/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"
#import "DlcLevelDelegate.h"
#import "InputNameWindow.h"
@class Button;
@class InputNameWindow;
@interface ChooseLevelMenu : CCLayer<GKSessionDelegate,UIAlertViewDelegate,UITextFieldDelegate,DlcLevelDelegate,GKMatchDelegate>
{
    CCLabelTTF *_title;
    CCSprite *_goBackButton;
    CCSprite *_soundButton;
       Button *_upgradeButton;
    Button *_nameButton;
    CCLabelTTF  *player1;
    CCLabelTTF  *player2;
    NSString *_maxName;
    NSMutableArray *_buttonArray1;
    NSMutableArray *_buttonArray2;
    NSMutableArray *_buttonArray3;
    BOOL _isSoundOn;
    GKSession *currentSession;
     GKMatch *myMatch;
    NSString *gameMode;
    CCScrollLayer  *_scroller;
    UIAlertView *_waitingAlert;
    //UITextField* myTextField1;
    //UITextField* myTextField2;
    float _waitToShowTextField1;
    float _waitToShowTextField2;
    float _waitToShowTextfield3;
    BOOL _isEditing;
    InputNameWindow *nameWindow;
    CCSprite *_sunshine1;
    CCSprite *_sunshine2;
    CCSprite *_sunshine3;
    float _waitToShowSunshine1;
    float _waitToShowSunshine2;
    float _waitToShowSunshine3;

}

@property (nonatomic, retain) GKSession *currentSession;
+(CCScene *) scene;

@end
