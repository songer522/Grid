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
@class Button;

@interface UpgradeMenu : CCLayer <DlcLevelDelegate>
{
    Button *_goBackButton;
    Button *_upgradeButton;
}
@property (nonatomic,retain)Button *upgradeButton;
+(CCScene *) scene;
+(id)UpgradeMenuLayer;
@end
