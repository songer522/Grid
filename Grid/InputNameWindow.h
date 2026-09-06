//
//  InputNameWindow.h
//  Grid
//
//  Created by Song Yang on 6/6/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Button.h"
#import "ChooseLevelMenu.h"
@class ChooseLevelMenu;
@interface InputNameWindow : CCLayer<UITextFieldDelegate>
{
    CCSprite *_background;
    CCSprite *_window;
    UITextField* myTextField1;
     UITextField* myTextField2;
      Button *_doneButton;
     CCLabelTTF *_score;
    float _waitToFadeInWindow;
    float _waitToFadeOutWindow;
    float _waitToShowTextField1;
    float _waitToShowTextField2;
    float _waitToShowTextField3;
    CCLayer *_parentController;
    BOOL _touchEnable;
     NSString *_gameMode;
}
@property float waitToFadeInWindow;

+(id)InputNameWindowInController:(CCLayer*)chooseLevelMenu;

-(void)setOpacity:(GLubyte)opacity;
- (void)update:(ccTime)dt;
@end

