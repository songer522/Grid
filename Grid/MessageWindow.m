//
//  GameWindow.m
//  Grid
//
//  Created by Yang Song on 4/26/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "MessageWindow.h"
#import "DeviceSettings.h"
#import "MapSettings.h"

@implementation MessageWindow
@synthesize waitToFadeInTreasureBoxMessageBox=_waitToFadeInTreasureBoxMessageBox;
@synthesize waitToFadeOutTreasureBoxMessageBox=_waitToFadeOutTreasureBoxMessageBox;
@synthesize Icon=_Icon;
+(id)GameWindowWithImage:(NSString *)imageName text:(NSString*)text number:(NSString*)number andPosition:(CGPoint)position
{
    return [[self alloc] initWithImage:imageName text:text number:number  andPosition:position];
}

-(id)initWithImage:(NSString *)imageName  text:(NSString*)text number:(NSString*)number andPosition:(CGPoint)position
{
    if ((self=[super init])) {
        
        
        _box=[CCSprite spriteWithSpriteFrameName:@"Graphic_ItemBack.png"];
         [_box setPosition:position];
        _text=[CCLabelTTF labelWithString:text fontName:@"Impact" fontSize: HD_TEXT(14)];
        [_text setColor: ccc3(25, 25, 25)];
        _number=[CCLabelTTF labelWithString:number fontName:@"Impact" fontSize: HD_TEXT(14)];
        [_number setColor: ccc3(25, 25, 25)];
        [_text setPosition:ccp(position.x+0.15*EDGE_LENGTH,position.y+0.20*EDGE_LENGTH)];
        [_number setPosition:ccp(position.x+1.05*EDGE_LENGTH,position.y+0.20*EDGE_LENGTH)];
        _Icon=[CCSprite spriteWithSpriteFrameName:imageName];
        [_Icon setPosition:ccp(position.x-0.2*EDGE_LENGTH,position.y)];

       
        
        
        [self addChild:_box];
        [self addChild:_Icon];
        [self addChild:_text];
        [self addChild:_number];
    }
    return self;
}

-(void)setOpacity:(GLubyte)opacity
{
    [_box setOpacity:opacity];
    [_text setOpacity:opacity];
    [_number setOpacity:opacity];
    [_Icon setOpacity:opacity];
}

-(void)setImage:(NSString *)imageName text:(NSString*)text number:(NSString*)number
{
    [_Icon setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:imageName]];
    [_text setString:text];
    [_number setString:number];
}


- (void)update:(ccTime)dt
{
if(_waitToFadeInTreasureBoxMessageBox>0)
{
    _waitToFadeInTreasureBoxMessageBox=_waitToFadeInTreasureBoxMessageBox-dt;
    [self setOpacity:(1.0-_waitToFadeInTreasureBoxMessageBox)*255]; 
    if(_waitToFadeInTreasureBoxMessageBox<0)
    {
        [self setOpacity:255];
        self.waitToFadeOutTreasureBoxMessageBox=3.0;
    }
}

if(_waitToFadeOutTreasureBoxMessageBox>0)
{
    _waitToFadeOutTreasureBoxMessageBox=_waitToFadeOutTreasureBoxMessageBox-dt;
    if(_waitToFadeOutTreasureBoxMessageBox<0.5 && _waitToFadeOutTreasureBoxMessageBox>0)
    {
        [self setOpacity:_waitToFadeOutTreasureBoxMessageBox*510];
    }
    
    if(_waitToFadeOutTreasureBoxMessageBox<0)
    {
        [self setOpacity:0];
    }
    
}
}

@end
