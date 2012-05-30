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
        [_background setPosition:ADJUST_CCP(ccp(160,240))];
        _page=[CCSprite spriteWithSpriteFrameName:[self getPageName]];
        [_page setPosition:ADJUST_CCP(ccp(160,240))];
                _touchEnable=NO;
        _closeButton=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6_Delete.png"];
        [_closeButton setPosition:ADJUST_CCP(ccp(160,240))];
        [self setOpacity:0];
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES]; 
        
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
         [_background setPosition:ADJUST_CCP(ccp(160,240))];
         //_closeButton=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6_Delete.png"];
         //[_closeButton setPosition:ADJUST_CCP(ccp(160,240))];
          _touchEnable=YES;
         CCSprite *page1=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_1.png"];
      
         CCSprite *page2=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_2.png"];
         CCSprite *page3=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_3.png"];
         CCSprite *page4=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_4.png"];
         CCSprite *page5=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_5.png"];
            [page1 setPosition:ADJUST_CCP(ccp(160,240))];
            [page2 setPosition:ADJUST_CCP(ccp(160,240))];
            [page3 setPosition:ADJUST_CCP(ccp(160,240))];
            [page4 setPosition:ADJUST_CCP(ccp(160,240))];
            [page5 setPosition:ADJUST_CCP(ccp(160,240))];
         
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

         CCLayer *layer1=[CCLayer node];
           CCLayer *layer2=[CCLayer node];
           CCLayer *layer3=[CCLayer node];
           CCLayer *layer4=[CCLayer node];
           CCLayer *layer5=[CCLayer node];
         [layer1 addChild:page1];
         [layer2 addChild:page2];
         [layer3 addChild:page3];
         [layer4 addChild:page4];
         [layer5 addChild:page5];
         [layer1 addChild:close1];
         [layer2 addChild:close2];
         [layer3 addChild:close3];
         [layer4 addChild:close4];
         [layer5 addChild:close5];
         
         NSArray *pageArray=[NSArray arrayWithObjects:layer1,layer2,layer4,layer3,layer5, nil];
         
         
         _scroller = [[CCScrollLayer alloc] initWithLayers:pageArray widthOffset:0];
         _scroller.minimumTouchLengthToChangePage = 30.0f;
         //int pageNumber=[[[GameSettings shared] getGlobalForKey:@"pageNumber"] intValue];
         //[_scroller moveToPage:pageNumber];
        
         _scroller.showPagesIndicator=YES;
         _scroller.pagesIndicatorPosition=ADJUST_CCP(ccp(160,20));
         //[_scroller setPosition:ADJUST_CCP(ccp(0,60))];
         //[self setOpacity:0];
         [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES]; 

         [self addChild:_background];
        

         
          [self addChild:_scroller];
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
    else  if([levelNumber isEqualToString:@"5"]){
        NSString *pageName=@"Graphic_HTP_2.png";
        return pageName;
    }
    else  if([levelNumber isEqualToString:@"9"]){
        NSString *pageName=@"Graphic_HTP_4.png";
        return pageName;
    }
    else  if([levelNumber isEqualToString:@"14"]){
        NSString *pageName=@"Graphic_HTP_3.png";
        return pageName;
    }
    else  if([levelNumber isEqualToString:@"21"]){
        NSString *pageName=@"Graphic_HTP_5.png";
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
