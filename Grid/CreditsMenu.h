//
//  CreditsMenu.h
//  Grid
//
//  Created by Song Yang on 6/17/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Button.h"
@class Button;
@interface CreditsMenu : CCLayer
{
    Button *_goBackButton;
   
    Button *_creditsImage;
    //Button *_fullVersionText;
    //CCSprite *_captainAndSailor;
    //float _waitToShowCaptainAndSailor;
    //float _waitToPlayCaptainAndSailorAnimation;
    float _waitToShowSunshine1;
    float _waitToShowSunshine2;
    float _waitToShowSunshine3;
    CCSprite *_sunshine1;
    CCSprite *_sunshine2;
    CCSprite *_sunshine3;
}
+(CCScene *) scene;
@end
