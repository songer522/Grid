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
@interface ChooseLevelMenu : CCLayer<GKSessionDelegate>
{
    CCLabelTTF *_title;
    CCSprite *_goBackButton;
    CCSprite *_soundButton;
    NSMutableArray *_buttonArray;
    BOOL _isSoundOn;
    GKSession *currentSession;

}

@property (nonatomic, retain) GKSession *currentSession;
+(CCScene *) scene;

@end
