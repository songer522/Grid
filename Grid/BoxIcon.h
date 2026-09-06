//
//  BoxIcon.h
//  Grid
//
//  Created by Yang Song on 5/2/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GridView.h"

@interface BoxIcon : CCSprite
{
     float _waitToShowBox;
}
@property float waitToShowBox;

- (void)update:(ccTime)dt;
- (void)playBreakAnimation:(BoxColor)color;
@end
