//
//  IslandWindow.h
//  Grid
//
//  Created by Yang Song on 5/29/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface IslandWindow : CCSprite
{
    CCSprite *_island;
    CCSprite *_window;

    CCLabelTTF *_medalNum;
    CCLabelTTF *_score;
}
+(id)IslandWindowWithImage:(NSString *)windowImage MedalNum:(NSString *)num Score:(NSString *)score andPosition:(CGPoint)position;

@end
