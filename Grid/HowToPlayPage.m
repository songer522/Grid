//
//  HowToPlayPage.m
//  Grid
//
//  Created by Song Yang on 5/20/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "HowToPlayPage.h"
#import "DeviceSettings.h"
#import "MapSettings.h"
#import "ChooseLevelMenu.h"
#import "GameSettings.h"
#import "InAppPurchaseManager.h"
#import "SimpleAudioEngine.h"
#import "FullScreenBackground.h"
@implementation HowToPlayPage
@synthesize waitToFadeInWindow=_waitToFadeInWindow;
@synthesize waitToFadeOutTreasureBoxMessageBox=_waitToFadeOutWindow;
+(id)HowToPlayPageInController:(GameLayer*)gamelayer
{
    return [[self alloc] initPageInController:gamelayer];
}

+(id)HowToPlayWindowInController:(GameLayer*)gamelayer
{
    return [[self alloc] initWindowInController:gamelayer];
}

-(id)initPageInController:(GameLayer*)gamelayer
{
    if ((self=[super init])) {
        _parentController=gamelayer;
         
        _background=[CCSprite spriteWithSpriteFrameName:@"Graphic_Black50.png"];
        [FullScreenBackground stretchSpriteToFillScene:_background];
        _page=[CCSprite spriteWithSpriteFrameName:[self getPageName]];
        [_page setPosition:ADJUST_CCP(ccp(160,240))];
                _touchEnable=NO;
        _closeButton=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6_Delete.png"];
        [_closeButton setPosition:ADJUST_CCP(ccp(160,240))];
        [self setOpacity:0];
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES]; 
           _isTutorialPages=NO; 
        [self addChild:_background];
        [self addChild:_page];
        [self addChild:_closeButton];
            
    }
    return self;
}


-(id)initWindowInController:(GameLayer*)gamelayer
{
     if ((self=[super init])) {
         _parentController=gamelayer;
         
         _background=[CCSprite spriteWithSpriteFrameName:@"Graphic_Black50.png"];
         [FullScreenBackground stretchSpriteToFillScene:_background];
         //_closeButton=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6_Delete.png"];
         //[_closeButton setPosition:ADJUST_CCP(ccp(160,240))];
          _touchEnable=YES;
            _isTutorialPages=YES; 
         CCSprite *page1=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_1.png"];
      
         CCSprite *page2=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_2.png"];
         CCSprite *page3=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_3.png"];
         CCSprite *page4=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_4.png"];
         CCSprite *page5=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_5.png"];
         CCSprite *page6=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6.png"];
         CCSprite *page7=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_7.png"];
         CCSprite *page8=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_8.png"];
            [page1 setPosition:ADJUST_CCP(ccp(160,240))];
            [page2 setPosition:ADJUST_CCP(ccp(160,240))];
            [page3 setPosition:ADJUST_CCP(ccp(160,240))];
            [page4 setPosition:ADJUST_CCP(ccp(160,240))];
            [page5 setPosition:ADJUST_CCP(ccp(160,240))];
          [page6 setPosition:ADJUST_CCP(ccp(160,240))];
          [page7 setPosition:ADJUST_CCP(ccp(160,240))];
          [page8 setPosition:ADJUST_CCP(ccp(160,240))];
         
         
         CCSprite *close1=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6_Delete.png"];
         [close1 setPosition:ADJUST_CCP(ccp(160,240))];
         CCSprite *close2=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6_Delete.png"];
         [close2 setPosition:ADJUST_CCP(ccp(160,240))];
         CCSprite *close3=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6_Delete.png"];
         [close3 setPosition:ADJUST_CCP(ccp(160,240))];
         CCSprite *close4=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6_Delete.png"];
         [close4 setPosition:ADJUST_CCP(ccp(160,240))];
         CCSprite *close5=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6_Delete.png"];
         [close5 setPosition:ADJUST_CCP(ccp(160,240))];
         CCSprite *close6=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6_Delete.png"];
         [close6 setPosition:ADJUST_CCP(ccp(160,240))];
         CCSprite *close7=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6_Delete.png"];
         [close7 setPosition:ADJUST_CCP(ccp(160,240))];
         CCSprite *close8=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6_Delete.png"];
         [close8 setPosition:ADJUST_CCP(ccp(160,240))];

         CCLayer *layer1=[CCLayer node];
           CCLayer *layer2=[CCLayer node];
           CCLayer *layer3=[CCLayer node];
           CCLayer *layer4=[CCLayer node];
           CCLayer *layer5=[CCLayer node];
         CCLayer *layer6=[CCLayer node];
         CCLayer *layer7=[CCLayer node];
         CCLayer *layer8=[CCLayer node];
         
         [layer1 addChild:page1];
         [layer2 addChild:page2];
         [layer3 addChild:page3];
         [layer4 addChild:page4];
         [layer5 addChild:page5];
          [layer6 addChild:page6];
          [layer7 addChild:page7];
          [layer8 addChild:page8];
         [layer1 addChild:close1];
         [layer2 addChild:close2];
         [layer3 addChild:close3];
         [layer4 addChild:close4];
         [layer5 addChild:close5];
         [layer6 addChild:close6];
         [layer7 addChild:close7];
         [layer8 addChild:close8];
         
         NSArray *pageArray=[NSArray arrayWithObjects:layer1,layer2,layer4,layer3,layer5,layer6,layer7,layer8, nil];
         
         
         _scroller = [[CCScrollLayer alloc] initWithLayers:pageArray widthOffset:0];
         _scroller.minimumTouchLengthToChangePage = 30.0f;
         //int pageNumber=[[[GameSettings shared] getGlobalForKey:@"pageNumber"] intValue];
         //[_scroller moveToPage:pageNumber];
        
         _scroller.showPagesIndicator=NO;
         _scroller.pagesIndicatorPosition=BOTTOM_CCP(160,20);
         _dotIndicator =[skullDotIndicator skullDotIndicatorWithNumberOfDots:8 AndPosition:BOTTOM_CCP(160,40) CurrentPage:_scroller.currentScreen];
         //[_scroller setPosition:ADJUST_CCP(ccp(0,60))];
         //[self setOpacity:0];
         [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES]; 

         [self addChild:_background];
        

         
          [self addChild:_scroller];
         [self addChild:_dotIndicator];
         // [self addChild:_closeButton];
     }
    return self;
}

-(NSString *)getPageName
{
    NSString *levelNumber=[[GameSettings shared] getGlobalForKey:@"selectedLevel"];
    if([levelNumber isEqualToString:@"1"])
    {
        NSString *pageName=@"Graphic_HTP_1.png";
        return pageName;
    }
    else  if([levelNumber isEqualToString:@"2"]){
        NSString *pageName=@"Graphic_HTP_2.png";
        return pageName;
    }
    else  if([levelNumber isEqualToString:@"3"]){
        NSString *pageName=@"Graphic_HTP_3.png";
        return pageName;
    }
    else  if([levelNumber isEqualToString:@"5"]){
        NSString *pageName=@"Graphic_HTP_4.png";
        return pageName;
    }
    else  if([levelNumber isEqualToString:@"8"]){
        NSString *pageName=@"Graphic_HTP_5.png";
        return pageName;
    }
    else  if([levelNumber isEqualToString:@"12"]){
        NSString *pageName=@"Graphic_HTP_6.png";
        return pageName;
    }
    else  if([levelNumber isEqualToString:@"17"]){
        NSString *pageName=@"Graphic_HTP_7.png";
        return pageName;
    }
    else  if([levelNumber isEqualToString:@"19"]){
        NSString *pageName=@"Graphic_HTP_8.png";
        return pageName;
    }
    else {
        return nil;
    }
}

-(void)setOpacity:(GLubyte)opacity
{
    [_background setOpacity:opacity];
    [_page setOpacity:opacity];
    [_closeButton setOpacity:opacity];

   }

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    if(_touchEnable)
    {
        
        if (touchOrigin2.x>ADJUST_X(260) && touchOrigin2.x<ADJUST_X(300) && touchOrigin2.y>ADJUST_Y(310) && touchOrigin2.y<ADJUST_Y(360))
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"menuBack.wav"];
            
            [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
           [self removeFromParentAndCleanup:YES];            
            
        }
        
            }
    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
}



- (void)update:(ccTime)dt
{
    
  if(_isTutorialPages)
  {
    [_dotIndicator changeDotForPage:_scroller.currentScreen];
  }
    
    
    if(_waitToFadeInWindow>0)
    {
        _waitToFadeInWindow=_waitToFadeInWindow-dt;
        
        if(_waitToFadeInWindow<0.5&&_waitToFadeInWindow>0)
        {
            [self setOpacity:(0.5-_waitToFadeInWindow)*510]; 
        }
        if(_waitToFadeInWindow<0)
        {
            [self setOpacity:255];
            _touchEnable=YES;
            //self.waitToFadeOutTreasureBoxMessageBox=3.0;
        }
    }
    
    if(_waitToFadeOutWindow>0)
    {
        _waitToFadeOutWindow=_waitToFadeOutWindow-dt;
        if(_waitToFadeOutWindow<0.5 && _waitToFadeOutWindow>0)
        {
            [self setOpacity:_waitToFadeOutWindow*510];
        }
        
        if(_waitToFadeOutWindow<0)
        {
            [self setOpacity:0];
        }
        
    }
}



@end
