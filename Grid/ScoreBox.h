//
//  ScoreBox.h
//  Grid
//
//  Created by Yang Song on 4/23/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoreBox : CCLayer
{
    CCSprite *_box;
    CCLabelTTF *_score;
    int _count;
    
}
@property int count;
+(id)ScoreBoxWithImage:(NSString *)imageName andPosition:(CGPoint)position;
-(void)changeScore:(int)amount;
-(void)setPosition:(CGPoint)position;
-(void)reset;
@end
