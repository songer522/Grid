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
    CCLabelTTF *_levelNumber;
    int _buttonId;
}
@property int buttonId;
+(id)levelButtonWithId:(int)buttonId;

-(id)initWithId:(int)buttonId;

-(void)initButton;

-(void)setPosition:(CGPoint)position;
-(void)ButtonPressed;
-(BOOL)checkTouchAtPosition:(CGPoint)point;

@end
