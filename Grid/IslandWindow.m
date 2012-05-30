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
       //_medalNum=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ / 16",num ] dimensions:CGSizeMake(50,100 ) alignment:UITextAlignmentRight fontName:@"Impact" fontSize:HD_TEXT(14)];
       _medalNum=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ / 16",num ] fontName:@"Impact" fontSize:HD_TEXT(24)];
       [_medalNum setColor:ccWHITE];
       //_score=[CCLabelTTF labelWithString:score dimensions:CGSizeMake(50,100 ) alignment:UITextAlignmentRight fontName:@"Impact" fontSize:HD_TEXT(14)];
        _score=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %@",score ] fontName:@"Impact" fontSize:HD_TEXT(24)];
       [_score setColor:ccWHITE];
       
       [_medalNum setPosition:ccp(position.x+HD_PIXELS(10),position.y-HD_PIXELS(57))];
       [_score setPosition:ccp(position.x,position.y-HD_PIXELS(107))];
       [self addChild:_window];
       [self addChild:_island];
       [self addChild:_medalNum];
       [self addChild:_score];

   }
    return self;
}
@end
