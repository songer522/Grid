//
//  CreditsMenu.m
//  Grid
//
//  Created by Song Yang on 6/17/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "CreditsMenu.h"
#import "GameSettings.h"
#import "DeviceSettings.h"
#import "Button.h"
#import "MainMenu.h"
#import "SimpleAudioEngine.h"
@implementation CreditsMenu
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreditsMenu *layer = [CreditsMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init])) {
        
		
		// ask director the the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
		
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"CreditsMenu.plist" ];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MenuBackground.plist" ];      
                
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SeaSunshine.plist" ]; 
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        [self schedule:@selector(update:)];
        [self loadUI];
        
        
	}
	return self;
}

- (void)loadUI
{
    CCSprite *background=[CCSprite spriteWithSpriteFrameName:@"Graphic_MainMenuBack.png"];
    [background setPosition:ADJUST_CCP(ccp(160,240))];
    
    _creditsImage=[Button buttonAtPosition:ADJUST_CCP(ccp(160,240)) andImage:@"Graphic_Credits.png"];
    [_creditsImage.buttonGraphic setOpacity:0];
        
    
    
    //id moveAction=[CCMoveTo actionWithDuration:1.0 position:ADJUST_CCP(ccp(160,240))];
    //id moveAction2=[CCMoveTo actionWithDuration:1.0 position:ADJUST_CCP(ccp(160,240))];
    
    
    [self addChild: background];
    _sunshine1=[CCSprite spriteWithSpriteFrameName:@"Graphic_SeaShine_1.png"];
    _sunshine2=[CCSprite spriteWithSpriteFrameName:@"Graphic_SeaShine_2.png"];
    _sunshine3=[CCSprite spriteWithSpriteFrameName:@"Graphic_SeaShine_3.png"];
    [_sunshine1 setOpacity:255];
    [_sunshine2 setOpacity:0];
    [_sunshine3 setOpacity:0];
    [_sunshine1 setPosition:ADJUST_CCP(ccp(160,240))];
    [_sunshine2 setPosition:ADJUST_CCP(ccp(160,240))];
    [_sunshine3 setPosition:ADJUST_CCP(ccp(160,240))];
    [self addChild:_sunshine1];
    [self addChild:_sunshine2];
    [self addChild:_sunshine3];
    
    _waitToShowSunshine1=1.0;
    
    
    [self addChild:_creditsImage];
        
    
    _creditsImage.waitToFadeInButton=1.5;
    
    
    
    _goBackButton=[Button buttonAtPosition:ADJUST_CCP(ccp(30,445)) andImage:@"Button_GoBack.png"];
   
    [_goBackButton.buttonGraphic setOpacity:0];
 
    _goBackButton.waitToFadeInButton=1.5;
    [self addChild:_goBackButton];

}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    
    if (touchOrigin2.x>ADJUST_X(10) && touchOrigin2.x<ADJUST_X(50) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(465))
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"menuBack.wav"];
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
       
            [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[MainMenu scene]]];
       
                        
        
    }
    return YES;
}

- (void)update:(ccTime)dt
{
    if(_waitToShowSunshine1>0)
    {
        _waitToShowSunshine1=_waitToShowSunshine1-dt;
        
        [_sunshine1 setOpacity:_waitToShowSunshine1*255] ;
        [_sunshine2 setOpacity:(1-_waitToShowSunshine1)*255];
        
        if(_waitToShowSunshine1<0)
        {
            [_sunshine1 setOpacity:0];
            [_sunshine2 setOpacity:255];
            _waitToShowSunshine2=1.0;
        }
        
        
    }
    
    if(_waitToShowSunshine2>0)
    {
        _waitToShowSunshine2=_waitToShowSunshine2-dt;
        
        [_sunshine2 setOpacity:_waitToShowSunshine2*255] ;
        [_sunshine3 setOpacity:(1-_waitToShowSunshine2)*255];
        
        if(_waitToShowSunshine2<0)
        {
            [_sunshine2 setOpacity:0];
            [_sunshine3 setOpacity:255];
            _waitToShowSunshine3=1.0;
        }
        
        
    }
    if(_waitToShowSunshine3>0)
    {
        _waitToShowSunshine3=_waitToShowSunshine3-dt;
        
        [_sunshine3 setOpacity:_waitToShowSunshine3*255] ;
        [_sunshine1 setOpacity:(1-_waitToShowSunshine3)*255];
        
        if(_waitToShowSunshine3<0)
        {
            [_sunshine3 setOpacity:0];
            [_sunshine1 setOpacity:255];
            _waitToShowSunshine1=1.0;
        }
        
        
    }
    

    [_goBackButton update:dt];
    [_creditsImage update:dt];
        
}
- (void)dealloc
{
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MenuBackground.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"CreditsMenu.plist"];
      [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"SeaSunshine.plist" ];
  
    [super dealloc];
}


@end
