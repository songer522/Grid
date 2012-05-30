//
//  FlashDot.h
//  Grid
//
//  Created by Yang Song on 5/23/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GridView.h"

@interface FlashDot : CCSprite
{
    float _waitToShowDot;
    float _waitToHideDot;
}
@property float waitToShowDot;
@property float waitToHideDot;

- (void)update:(ccTime)dt;

@end