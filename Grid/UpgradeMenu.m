//
//  UpgradeMenu.m
//  Grid
//
//  Created by Yang Song on 5/21/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "UpgradeMenu.h"
#import "GameSettings.h"
#import "DeviceSettings.h"
#import "ChooseLevelMenu.h"
#import "MainMenu.h"
#import "Button.h"
#import "InAppPurchaseManager.h"
#import "SimpleAudioEngine.h"
#import "ChooseIslandMenu.h"
@implementation UpgradeMenu
@synthesize upgradeButton=_upgradeButton;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	UpgradeMenu *layer = [UpgradeMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+(id)UpgradeMenuLayer
{
    return [[self alloc] initLayer];
}




-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init])) {
        
		
		// ask director the the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
		
        
      		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"upgradeSprite.plist" ];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MenuBackground.plist" ];      
        [[InAppPurchaseManager shared] loadStoreWithDelegate:self];
      
        
               
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        [self schedule:@selector(update:)];
          [self loadUI];
        
        
	}
	return self;
}

-(id) initLayer
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init])) {
        
		
		// ask director the the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
		
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"upgradeSprite.plist" ];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MenuBackground.plist" ];      
        
        [self loadUIForLayer];
        
        
        //[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        [self schedule:@selector(update:)];
        
        
        
	}
	return self;
}

- (void)loadUI
{
    CCSprite *background=[CCSprite spriteWithSpriteFrameName:@"Graphic_MainMenuBack.png"];
    [background setPosition:ADJUST_CCP(ccp(160,240))];

    _fullVersionImage=[Button buttonAtPosition:ADJUST_CCP(ccp(160,200)) andImage:@"Graphic_ScreenShots.png"];
    [_fullVersionImage.buttonGraphic setOpacity:0];
    _fullVersionText=[Button buttonAtPosition:ADJUST_CCP(ccp(160,200)) andImage:@"Graphic_FullVersionText.png"];
   // _fullVersionText=[CCSprite spriteWithSpriteFrameName:@"Graphic_FullVersionText.png"];
    //[_fullVersionText setPosition:ADJUST_CCP(ccp(160,240))];
    [_fullVersionText.buttonGraphic setOpacity:0];
  
   
  
    id moveAction=[CCMoveTo actionWithDuration:1.0 position:ADJUST_CCP(ccp(160,240))];
    id moveAction2=[CCMoveTo actionWithDuration:1.0 position:ADJUST_CCP(ccp(160,240))];

   
    [self addChild: background];
    [self addChild:_fullVersionImage];
    [self addChild:_fullVersionText];
    _captainAndSailor=[CCSprite spriteWithSpriteFrameName:@"Graphic_CaptainL_1.png"];
    [_captainAndSailor setOpacity:0];
    [_captainAndSailor setPosition:ADJUST_CCP(ccp(160,240))];
    [self addChild:_captainAndSailor];

    _waitToShowCaptainAndSailor=1.5;
    _fullVersionText.waitToFadeInButton=1.0;
    _fullVersionImage.waitToFadeInButton=1.0;
    [_fullVersionImage runAction:moveAction];
    [_fullVersionText runAction:moveAction2];
   // [_fullVersionText runAction:moveAction];
    
    
    _goBackButton=[Button buttonAtPosition:ADJUST_CCP(ccp(30,445)) andImage:@"Button_GoBack.png"];
    _upgradeButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,125)) andImage:@"Button_Upgrade.png"];
    [_goBackButton.buttonGraphic setOpacity:0];
    [_upgradeButton.buttonGraphic setOpacity:0];
    _upgradeButton.waitToFadeInButton=1.5;
    _goBackButton.waitToFadeInButton=1.5;
    [self addChild:_goBackButton];
    [self addChild:_upgradeButton];
}

- (void)loadUIForLayer
{
    //CCSprite *background=[CCSprite spriteWithSpriteFrameName:@"Graphic_MainMenuBack.png"];
    //[background setPosition:ADJUST_CCP(ccp(160,240))];
    CCSprite *fullVersionImage=[CCSprite spriteWithSpriteFrameName:@"Graphic_FullVersion.png"];
    [fullVersionImage setPosition:ADJUST_CCP(ccp(160,240))];

    
    //[self addChild: background];
    [self addChild:fullVersionImage];
    
    
    
    //_goBackButton=[Button buttonAtPosition:ADJUST_CCP(ccp(30,455)) andImage:@"Button_GoBack.png"];
    _upgradeButton=[Button buttonAtPosition:ADJUST_CCP(ccp(130,445)) andImage:@"Button_Upgrade.png"];
    //[_upgradeButton.buttonGraphic setScale:0.8];
    
    //[self addChild:_goBackButton];
    //[self addChild:_upgradeButton];
}



-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    if (touchOrigin2.x>ADJUST_X(50) && touchOrigin2.x<ADJUST_X(270) && touchOrigin2.y>ADJUST_Y(55) && touchOrigin2.y<ADJUST_Y(110))
    {
        [_upgradeButton playbuttonAnimation];
         [[InAppPurchaseManager shared] purchaseProductId:kInAppPurchaseUpgradeToFullVersion Delegate:self];
        
    }
    if (touchOrigin2.x>ADJUST_X(10) && touchOrigin2.x<ADJUST_X(50) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(465))
    {
         [[SimpleAudioEngine sharedEngine] playEffect:@"menuBack.wav"];
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        NSString *backTo= [[GameSettings shared] getGlobalForKey:@"UpgradeMenuBackTo"]; 
        if([backTo isEqualToString:@"MainMenu"])
        {
        [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[MainMenu scene]]];
        }
        else if([backTo isEqualToString:@"ChooseIslandMenu"]) {
             [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseIslandMenu scene]]];
            
        }
    }
    return YES;
}

-(void)captainAndSailorPlayAnimation
{
    CCAnimation *OpenAnimation=[CCAnimation animation];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_CaptainL_1.png"]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_CaptainL_2.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_CaptainL_1.png"]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_CaptainL_2.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_CaptainL_1.png"]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_CaptainL_2.png" ]];
        [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_CaptainL_1.png"]];

    //id OpenAnimationAction=[CCAnimate actionWithDuration:0.5 animation:OpenAnimation restoreOriginalFrame:NO];
    OpenAnimation.restoreOriginalFrame=NO;
    OpenAnimation.delayPerUnit=1.0 / OpenAnimation.frames.count;
    [_captainAndSailor runAction:[[[CCAnimate alloc] initWithAnimation:OpenAnimation] autorelease]];
    
    _waitToPlayCaptainAndSailorAnimation=3.3;
}




- (void)update:(ccTime)dt
{
    [_upgradeButton update:dt];
    [_fullVersionText update:dt];
    [_fullVersionImage update:dt];
    [_goBackButton update:dt];
    if(_waitToShowCaptainAndSailor>0)
    {
        _waitToShowCaptainAndSailor=_waitToShowCaptainAndSailor-dt;
        if(_waitToShowCaptainAndSailor<0.5 && _waitToShowCaptainAndSailor>0)
        {
            [_captainAndSailor setOpacity:((0.5-_waitToShowCaptainAndSailor)*510) ];
            
            
        }
        
        if(_waitToShowCaptainAndSailor<0)
        {
                       [_captainAndSailor setOpacity:255];
           
            _waitToPlayCaptainAndSailorAnimation=1.0;
        }
        
    }
    
    if(_waitToPlayCaptainAndSailorAnimation>0)
    {
        _waitToPlayCaptainAndSailorAnimation=_waitToPlayCaptainAndSailorAnimation-dt;
        if(_waitToPlayCaptainAndSailorAnimation<0)
        {
            [self captainAndSailorPlayAnimation];
        }
    }

}

-(void)updateDlcLevels
{
    CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
    
    [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[MainMenu scene]]];
}
-(void)restoreFails
{
}
-(void)openErrorWindowCantConnectToStore
{
    AlertView *alert = [[AlertView alloc] initWithTitle:@"ERROR!"
                                                    message:@"Cannot connect to the store at this time. Please try again later."
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
-(void)openErrorWindowCantMakePurchases
{
    AlertView *alert = [[AlertView alloc] initWithTitle:@"ERROR!"
                                                    message:@"Cannot make purchase at this time. Please try again later or make sure to have in app purchases enabled in Settings>General>Restrictions."
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)setCantConnectToStore:(BOOL)CantConnectToStore
{
    
}
-(void)setCantMakePurchases:(BOOL)CantMakePurchases
{
       
}



- (void)dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MainMenuSprites.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MenuBackground.plist"];

    [super dealloc];
  }
@end
