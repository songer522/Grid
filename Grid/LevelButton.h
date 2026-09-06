//
//  LevelButton.h
//  Grid
//
//  Created by Yang Song on 5/3/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface LevelButton : CCLayer
{
    CCSprite *_buttonGraphic;
    CGPoint _buttonPosition;
    CCSprite *_medal;
    CCSprite *_bars;
    CCLabelTTF *_levelNumber;
    int _buttonId;
    BOOL _hasMedal;
}
@property int buttonId;
@property BOOL hasMedal;
@property (retain,nonatomic) CCLabelTTF *levelNumber;
+(id)levelButtonWithId:(int)buttonId;

-(id)initWithId:(int)buttonId;

-(void)initButton;

-(void)setPosition:(CGPoint)position;
-(BOOL)ButtonPressed;
-(BOOL)checkTouchAtPosition:(CGPoint)point;

@end
