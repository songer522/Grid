//
//  ChooseIslandMenu.h
//  Grid
//
//  Created by Yang Song on 5/29/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertView.h"
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"
#import "DlcLevelDelegate.h"
#import "skullDotIndicator.h"
@class Button;
@interface ChooseIslandMenu : CCLayer<GKSessionDelegate,AlertViewDelegate,UITextFieldDelegate,GKMatchDelegate,DlcLevelDelegate>
{
CCLabelTTF *_title;
CCSprite *_goBackButton;
CCSprite *_soundButton;
Button *_upgradeButton;

NSString *_maxName;

BOOL _isSoundOn;
GKSession *currentSession;
    GKMatch *myMatch;
NSString *gameMode;
CCScrollLayer  *_scroller;
skullDotIndicator *_dotIndicator;
AlertView *_waitingAlert;
    BOOL _touchEnable;

float _waitToShowTextField1;
float _waitToShowTextField2;
float _waitToShowTextfield3;
    CCSprite *_sunshine1;
    CCSprite *_sunshine2;
    CCSprite *_sunshine3;
    
    float _waitToShowSunshine1;
    float _waitToShowSunshine2;
    float _waitToShowSunshine3;
BOOL _isEditing;
    int coinNumber;
}

@property (nonatomic, retain) GKSession *currentSession;
+(CCScene *) scene;


@end
