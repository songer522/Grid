//
//  GameoverWindow.h
//  Grid
//
//  Created by Yang Song on 5/18/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Button.h"
#import "GameLayer.h"
@class GameLayer;
@interface GameoverWindow : CCLayer <UIAlertViewDelegate>
{
    CCSprite *_background;
    CCSprite *_window;
    Button *_nextLevelButton;
    Button *_playAgainButton;
    Button *_mainMenuButton;
    float _waitToFadeInWindow;
    float _waitToFadeOutWindow;
    GameLayer *_parentController;
    BOOL _touchEnable;
    
}
@property float waitToFadeInWindow;
@property float waitToFadeOutTreasureBoxMessageBox;
+(id)GameWindowInController:(GameLayer*)gamelayer;

-(void)setOpacity:(GLubyte)opacity;
- (void)update:(ccTime)dt;
@end
