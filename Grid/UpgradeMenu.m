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
        [self loadUI];
        
               
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        [self schedule:@selector(update:)];
        
        
        
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
    CCSprite *fullVersionImage=[CCSprite spriteWithSpriteFrameName:@"Graphic_FullVersion.png"];
    [fullVersionImage setPosition:ADJUST_CCP(ccp(160,240))];
   
    [self addChild: background];
    [self addChild:fullVersionImage];
    
    
    
    _goBackButton=[Button buttonAtPosition:ADJUST_CCP(ccp(30,455)) andImage:@"Button_GoBack.png"];
    _upgradeButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,455)) andImage:@"Button_Upgrade.png"];
   
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
    _upgradeButton=[Button buttonAtPosition:ADJUST_CCP(ccp(130,455)) andImage:@"Button_Upgrade.png"];
    //[_upgradeButton.buttonGraphic setScale:0.8];
    
    //[self addChild:_goBackButton];
    //[self addChild:_upgradeButton];
}



-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    if (touchOrigin2.x>ADJUST_X(120) && touchOrigin2.x<ADJUST_X(320) && touchOrigin2.y>ADJUST_Y(445) && touchOrigin2.y<ADJUST_Y(465))
    {
        [_upgradeButton playbuttonAnimation];
         [[InAppPurchaseManager shared] purchaseProductId:kInAppPurchaseUpgradeToFullVersion Delegate:self];
        
    }
    if (touchOrigin2.x>ADJUST_X(10) && touchOrigin2.x<ADJUST_X(50) && touchOrigin2.y>ADJUST_Y(445) && touchOrigin2.y<ADJUST_Y(465))
    {
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        
        [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[MainMenu scene]]];
    }
    return YES;
}

- (void)update:(ccTime)dt
{
    [_upgradeButton update:dt];
}

-(void)updateDlcLevels
{
    CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
    
    [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseLevelMenu scene]]];
}
-(void)openErrorWindowCantConnectToStore
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!"
                                                    message:@"Cannot connect to the store at this time. Please try again later."
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
-(void)openErrorWindowCantMakePurchases
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!"
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
    [super dealloc];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MainMenuSprites.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MenuBackground.plist"];
}
@end
