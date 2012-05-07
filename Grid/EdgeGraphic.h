//
//  EdgeGraphic.h
//  Grid
//
//  Created by Yang Song on 5/2/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface EdgeGraphic : CCSprite
{
    float _waitToShowEdge;
}
@property float waitToShowEdge;
- (void)update:(ccTime)dt;
@end
