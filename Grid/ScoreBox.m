//
//  ScoreBox.m
//  Grid
//
//  Created by Yang Song on 4/23/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "ScoreBox.h"
#import "DeviceSettings.h"

@implementation ScoreBox
@synthesize count=_count;
+(id)ScoreBoxWithImage:(NSString *)imageName andPosition:(CGPoint)position
{
    return [[self alloc] initWithImage:imageName andPosition:position];
}

-(id)initWithImage:(NSString *)imageName andPosition:(CGPoint)position
{
    if ((self=[super init])) {
        
        
        _count=0;
        _score=[CCLabelTTF labelWithString:@"0" fontName:@"Impact" fontSize: HD_TEXT(34)];
        _box=[CCSprite spriteWithSpriteFrameName:imageName];
        [self setPosition:position];
        
       
        [self addChild:_box];
         [self addChild:_score];
    }
    return self;
}

-(void)changeScore:(int)amount
{
    _count=_count+amount;
    
    NSString *newScore=[NSString stringWithFormat:@"%d",_count];
    [_score setString:[NSString stringWithFormat:newScore]];
}

-(void)setPosition:(CGPoint)position
{
    [_box setPosition:position];
    
    //[_score setPosition:ccp(position.x,(position.y-HD_PIXELS(7)))];
    [_score setPosition:position];
}

-(void)reset
{
    [_score setString:@"0"];
    _count=0;
    
}
@end
