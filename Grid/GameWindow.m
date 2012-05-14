//
//  GameWindow.m
//  Grid
//
//  Created by Yang Song on 4/26/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "GameWindow.h"
#import "DeviceSettings.h"
#import "MapSettings.h"

@implementation GameWindow
@synthesize waitToFadeInTreasureBoxMessageBox=_waitToFadeInTreasureBoxMessageBox;
@synthesize waitToFadeOutTreasureBoxMessageBox=_waitToFadeOutTreasureBoxMessageBox;
+(id)GameWindowWithImage:(NSString *)imageName text:(NSString*)text number:(NSString*)number andPosition:(CGPoint)position
{
    return [[self alloc] initWithImage:imageName text:text number:number  andPosition:position];
}

-(id)initWithImage:(NSString *)imageName  text:(NSString*)text number:(NSString*)number andPosition:(CGPoint)position
{
    if ((self=[super init])) {
        
        
        _box=[CCSprite spriteWithSpriteFrameName:@"Graphic_ItemBack.png"];
         [_box setPosition:position];
        _text=[CCLabelTTF labelWithString:text fontName:@"Marker Felt" fontSize: HD_TEXT(16)];
        [_text setColor: ccBLACK];
        _number=[CCLabelTTF labelWithString:number fontName:@"Marker Felt" fontSize: HD_TEXT(28)];
        [_number setColor: ccBLACK];
        [_text setPosition:ccp(position.x+0.45*EDGE_LENGTH,position.y+0.25*EDGE_LENGTH)];
        [_number setPosition:ccp(position.x+0.45*EDGE_LENGTH,position.y-0.25*EDGE_LENGTH)];
        _Icon=[CCSprite spriteWithSpriteFrameName:imageName];
        [_Icon setPosition:ccp(position.x-0.7*EDGE_LENGTH,position.y)];

       
        
        
        [self addChild:_box];
        [self addChild:_Icon];
        [self addChild:_text];
        [super addChild:_number];
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
