//
//  IslandWindow.m
//  Grid
//
//  Created by Yang Song on 5/29/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "IslandWindow.h"
#import "DeviceSettings.h"
#import "MapSettings.h"
@implementation IslandWindow
+(id)IslandWindowWithImage:(NSString *)windowImage MedalNum:(NSString *)num Score:(NSString *)score andPosition:(CGPoint)position
{
    return [[self alloc] initWithImage:windowImage MedalNum:num Score:score andPosition:position];
}

-(id)initWithImage:(NSString *)windowImage MedalNum:(NSString *)num Score:(NSString *)score andPosition:(CGPoint)position
{
   if ((self=[super init])) {

       
       _window=[CCSprite spriteWithSpriteFrameName:@"Button_LevelGroup_Back.png"];
       [_window setPosition:position];
       _island=[CCSprite spriteWithSpriteFrameName:windowImage];
       [_island setPosition:position];
       CCSprite *medal=[CCSprite spriteWithSpriteFrameName:@"Graphic_LevelGroup_Medal.png"];
       [medal setPosition:position];
       
       _medalNum=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ / 16",num ] fontName:@"Impact" fontSize:HD_TEXT(24)];
       [_medalNum setColor:ccWHITE];
              _score=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %@",score ] fontName:@"Impact" fontSize:HD_TEXT(24)];
       [_score setColor:ccWHITE];
      // _medalNum=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%@ / 16",num ] fntFile:@"ImpactEdited.fnt"];
       //_score=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Score: %@",score ] fntFile:@"ImpactEdited.fnt"];
       
       [_medalNum setPosition:ccp(position.x+HD_PIXELS(10),position.y-HD_PIXELS(57))];
       [_score setPosition:ccp(position.x,position.y-HD_PIXELS(107))];
       if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && [[UIScreen mainScreen] scale] == 2.0)
       {
           [_medalNum setPosition:ccp(position.x+HD_PIXELS(10),position.y-HD_PIXELS(62))];
           [_score setPosition:ccp(position.x,position.y-HD_PIXELS(115))];

       }
       [self addChild:_window];
       [self addChild:_island];
       [self addChild:_medalNum];
       [self addChild:_score];
       [self addChild:medal];

   }
    return self;
}

+(id)IslandWindowWithImage:(NSString *)windowImage andPosition:(CGPoint)position
{
    return [[self alloc] initWithImage:windowImage andPosition:position];
}

-(id)initWithImage:(NSString *)windowImage andPosition:(CGPoint)position
{
    if ((self=[super init])) {
        
        
        _window=[CCSprite spriteWithSpriteFrameName:@"Button_LevelGroup_Back.png"];
        [_window setPosition:position];
        _island=[CCSprite spriteWithSpriteFrameName:windowImage];
        [_island setPosition:position];
        CCSprite *lock=[CCSprite spriteWithSpriteFrameName:@"Graphic_LevelGroup_Lock.png"];
        [lock setPosition:position];
        
        _medalNum=[CCLabelTTF labelWithString:@"Locked" fontName:@"Impact" fontSize:HD_TEXT(24)];
        [_medalNum setColor:ccWHITE];
        _score=[CCLabelTTF labelWithString:@"Upgrade Now!" fontName:@"Impact" fontSize:HD_TEXT(24)];
        [_score setColor:ccWHITE];
        // _medalNum=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%@ / 16",num ] fntFile:@"ImpactEdited.fnt"];
        //_score=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Score: %@",score ] fntFile:@"ImpactEdited.fnt"];
        
        [_medalNum setPosition:ccp(position.x+HD_PIXELS(10),position.y-HD_PIXELS(57))];
        [_score setPosition:ccp(position.x,position.y-HD_PIXELS(107))];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && [[UIScreen mainScreen] scale] == 2.0)
        {
            [_medalNum setPosition:ccp(position.x+HD_PIXELS(10),position.y-HD_PIXELS(62))];
            [_score setPosition:ccp(position.x,position.y-HD_PIXELS(115))];
            
        }
        [self addChild:_window];
        [self addChild:_island];
        [self addChild:_medalNum];
        [self addChild:_score];
        [self addChild:lock];
        
    }
    return self;
}


@end
