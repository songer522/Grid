//
//  Button.h
//  Grid
//
//  Created by Yang Song on 5/8/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
@interface Button : CCSprite
{
    CCSprite *_buttonGraphic;
    CGPoint _buttonPosition;
    float _waitToFadeOutButton;
    float _waitToFadeInButton;

    NSString *_imageName;
}

@property CGPoint buttonPosition;
@property (retain,nonatomic)CCSprite *buttonGraphic;
@property float waitToFadeOutButton;
@property float waitToFadeInButton;

+ (id)buttonAtPosition:(CGPoint)position andImage:(NSString*)image;
- (void)playbuttonAnimation;
- (void)playIconAnimation;
- (void)update:(ccTime)dt;


@end
