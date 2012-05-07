//
//  BoxIcon.m
//  Grid
//
//  Created by Yang Song on 5/2/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "BoxIcon.h"

@implementation BoxIcon
@synthesize waitToShowBox=_waitToShowBox;
- (void)playBreakAnimation:(BoxColor)color
{
    
        CCAnimation *breakAnimation=[CCAnimation animation];
    if(color==BLUE_BOX){

        [breakAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_BlueBox.png"]];
        [breakAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_BlueBox.png" ]];
        [breakAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_BlueBox_Break1.png"]];
        [breakAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_BlueBox_Break2.png" ]];
    }
    else if (color==ORANGE_BOX){
        [breakAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_OrangeBox.png"]];
        [breakAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_OrangeBox.png" ]];
        [breakAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_OrangeBox_Break1.png"]];
        [breakAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_OrangeBox_Break2.png" ]];
    }
                //id OpenAnimationAction=[CCAnimate actionWithDuration:0.5 animation:OpenAnimation restoreOriginalFrame:NO];
        breakAnimation.restoreOriginalFrame=NO;
        breakAnimation.delayPerUnit=1.0 / breakAnimation.frames.count;
        [self runAction:[[[CCAnimate alloc] initWithAnimation:breakAnimation] autorelease]];
        
        //[_boxGraphic setVisible:NO];
        
    
}

- (void)update:(ccTime)dt {
    if(_waitToShowBox>0)
    {
        _waitToShowBox=_waitToShowBox-dt;
        if(_waitToShowBox<0.2&&_waitToShowBox>0)
        {[self setScale:(1-5*_waitToShowBox)];
        }
        if(_waitToShowBox<0)
        {
            [self setScale:1];
        }
    }
}
@end
