//
//  ChooseIslandMenu.h
//  Grid
//
//  Created by Yang Song on 5/29/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"
@class Button;
@interface ChooseIslandMenu : CCLayer<GKSessionDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
CCLabelTTF *_title;
CCSprite *_goBackButton;
CCSprite *_soundButton;
Button *_upgradeButton;

NSString *_maxName;

BOOL _isSoundOn;

NSString *gameMode;
CCScrollLayer  *_scroller;
UIAlertView *_waitingAlert;

float _waitToShowTextField1;
float _waitToShowTextField2;
float _waitToShowTextfield3;
BOOL _isEditing;

}


+(CCScene *) scene;


@end
