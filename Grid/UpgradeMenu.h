//
//  UpgradeMenu.h
//  Grid
//
//  Created by Yang Song on 5/21/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DlcLevelDelegate.h"
#import "AlertView.h"
#import "Button.h"
@class Button;

@interface UpgradeMenu : CCLayer <DlcLevelDelegate,AlertViewDelegate>
{
    Button *_goBackButton;
    Button *_upgradeButton;
    Button *_fullVersionImage;
    Button *_fullVersionText;
    CCSprite *_captainAndSailor;
    float _waitToShowCaptainAndSailor;
    float _waitToPlayCaptainAndSailorAnimation;
}
@property (nonatomic,retain)Button *upgradeButton;
+(CCScene *) scene;
+(id)UpgradeMenuLayer;
@end
