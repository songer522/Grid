//
//  HowToPlayPage.h
//  Grid
//
//  Created by Song Yang on 5/20/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Button.h"
#import "GameLayer.h"
#import "CCScrollLayer.h"
#import "DlcLevelDelegate.h"

@class GameLayer;
@interface HowToPlayPage : CCLayer
{
    CCSprite *_background;
    CCSprite *_page;
    CCSprite *_closeButton;
   
    float _waitToFadeInWindow;
    float _waitToFadeOutWindow;
    GameLayer *_parentController;
    CCScrollLayer  *_scroller;
    BOOL _touchEnable;
    
}
@property float waitToFadeInWindow;
@property float waitToFadeOutTreasureBoxMessageBox;
+(id)HowToPlayPageInController:(GameLayer*)gamelayer;
+(id)HowToPlayWindowInController:(GameLayer*)gamelayer;
-(void)setOpacity:(GLubyte)opacity;
- (void)update:(ccTime)dt;

@end
