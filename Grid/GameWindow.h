//
//  GameWindow.h
//  Grid
//
//  Created by Yang Song on 4/26/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface GameWindow : CCSprite
{
    CCSprite *_box;
    CCSprite *_Icon;
    CCLabelTTF *_text;
    CCLabelTTF *_number;
    float _waitToFadeInTreasureBoxMessageBox;
    float _waitToFadeOutTreasureBoxMessageBox;

}
@property float waitToFadeInTreasureBoxMessageBox;
@property float waitToFadeOutTreasureBoxMessageBox;
+(id)GameWindowWithImage:(NSString *)imageName text:(NSString*)text number:(NSString*)number andPosition:(CGPoint)position;
-(void)setImage:(NSString *)imageName text:(NSString*)text number:(NSString*)number;
-(void)setOpacity:(GLubyte)opacity;
- (void)update:(ccTime)dt;
@end
