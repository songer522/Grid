//
//  GameoverWindow.h
//  Grid
//
//  Created by Yang Song on 5/18/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertView.h"
#import "cocos2d.h"
#import "Button.h"
#import "GameLayer.h"
@class GameLayer;
@interface GameoverWindow : CCLayer <AlertViewDelegate>
{
    CCSprite *_background;
    CCSprite *_window;
    CCSprite *_resultInfo;
    CCSprite *_scoreWindow;
    Button *_nextLevelButton;
    Button *_playAgainButton;
    Button *_mainMenuButton;
    CCSprite *_close;
   // CCLabelBMFont *_score;
   // CCLabelBMFont *_bestScore;
    NSString *_gameMode;
    CCLabelTTF *_score;
    CCLabelTTF *_bestScore;
    
    CCLabelTTF *_player1Tally;
    CCLabelTTF *_player2Tally;
    CCLabelTTF *_tallyResult;
    CCSprite *_newRecord;
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
