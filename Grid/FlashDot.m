//
//  FlashDot.m
//  Grid
//
//  Created by Yang Song on 5/23/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "FlashDot.h"

@implementation FlashDot
@synthesize waitToShowDot=_waitToShowDot;
@synthesize waitToHideDot=_waitToHideDot;

- (void)update:(ccTime)dt {
    if(_waitToShowDot>0)
    {
        _waitToShowDot=_waitToShowDot-dt;
        if(_waitToShowDot<0.75&&_waitToShowDot>0)
        {//[self setScale:(1-5*_waitToShowDot)];
            [self setOpacity:(0.75-_waitToShowDot)*340];
        }
        if(_waitToShowDot<0)
        {
            [self setOpacity:255];
            _waitToHideDot=1.5;
        }
    }
    
    if(_waitToHideDot>0)
    {
        _waitToHideDot=_waitToHideDot-dt;
        if(_waitToHideDot<0.75&&_waitToHideDot>0)
        {//[self setScale:(1-5*_waitToShowDot)];
            [self setOpacity:_waitToHideDot*340];
        }
        if(_waitToHideDot<0)
        {
            [self setOpacity:0];
            _waitToShowDot=1.5;
           
        }
    }

    
    
}

@end
