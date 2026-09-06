//
//  EdgeGraphic.m
//  Grid
//
//  Created by Yang Song on 5/2/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "EdgeGraphic.h"

@implementation EdgeGraphic
@synthesize  waitToShowEdge=_waitToShowEdge;
- (void)update:(ccTime)dt {
    if(_waitToShowEdge>0)
    {
        _waitToShowEdge=_waitToShowEdge-dt;
        [self setScale:(1-5*_waitToShowEdge)];
        if(_waitToShowEdge<0)
        {
            [self setScale:1];
        }
    }
}
@end
