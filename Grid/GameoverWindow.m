//
//  GameoverWindow.m
//  Grid
//
//  Created by Yang Song on 5/18/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "GameoverWindow.h"
#import "DeviceSettings.h"
#import "MapSettings.h"
#import "ChooseLevelMenu.h"
#import "GameSettings.h"
#import "UpgradeMenu.h"
@implementation GameoverWindow
@synthesize waitToFadeInWindow=_waitToFadeInWindow;
@synthesize waitToFadeOutTreasureBoxMessageBox=_waitToFadeOutWindow;
+(id)GameWindowInController:(GameLayer*)gamelayer
{
    return [[self alloc] initInController:gamelayer];
}

-(id)initInController:(GameLayer*)gamelayer
{
    if ((self=[super init])) {
        _parentController=gamelayer;
        
        _background=[CCSprite spriteWithSpriteFrameName:@"Graphic_Black50.png"];
        [_background setPosition:ADJUST_CCP(ccp(160,240))];
        _window=[CCSprite spriteWithSpriteFrameName:@"Graphic_MessageWindow.png"];
        [_window setPosition:ADJUST_CCP(ccp(160,240))];
       
        _nextLevelButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,240)) andImage:@"Button_NextLevel.png"];
        
        _playAgainButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,240)) andImage:@"Button_PlayAgain.png"];

        _mainMenuButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,240)) andImage:@"Button_MainMenu.png"];
        _touchEnable=NO;
                
        [self setOpacity:0];
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES]; 
        
        [self addChild:_background];
        [self addChild:_window];
        NSString *ClearCurrentLevel=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"ClearLevel%@",[[GameSettings shared] getGlobalForKey:@"selectedLevel"]]];
        if([ClearCurrentLevel isEqualToString:@"YES"])
        {
        [self addChild:_nextLevelButton];
        }
        [self addChild:_playAgainButton];
        [self addChild:_mainMenuButton];
        
    }
    return self;
}

-(void)setOpacity:(GLubyte)opacity
{
    [_background setOpacity:opacity];
    [_window setOpacity:opacity];
    [_nextLevelButton.buttonGraphic setOpacity:opacity];
    [_playAgainButton.buttonGraphic setOpacity:opacity];
    [_mainMenuButton.buttonGraphic setOpacity:opacity];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    if(_touchEnable)
    {
    
    if (touchOrigin2.x>ADJUST_X(60) && touchOrigin2.x<ADJUST_X(260) && touchOrigin2.y>ADJUST_Y(260) && touchOrigin2.y<ADJUST_Y(300))
    {
         
        
        NSString *ClearCurrentLevel=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"ClearLevel%@",[[GameSettings shared] getGlobalForKey:@"selectedLevel"]]];
        if([ClearCurrentLevel isEqualToString:@"YES"])
        {
        [_nextLevelButton playbuttonAnimation];
            
            int levelButtonNumber=[[[GameSettings shared] getGlobalForKey:@"levelNumberOnButton"] intValue];
            int nextLevelButtonNumber=levelButtonNumber+1;
            
            if(nextLevelButtonNumber>16)
            {
                nextLevelButtonNumber=1;
                int islandNumber=[[[GameSettings shared] getGlobalForKey:@"island"] intValue];
                int nextIslandNumber=islandNumber+2;
                [[GameSettings shared] setGlobal:[NSString stringWithFormat:@"%d",nextIslandNumber] ForKey:@"island"];
            }
            
            [[GameSettings shared] setGlobal:[NSString stringWithFormat:@"%d",nextLevelButtonNumber] ForKey:@"levelNumberOnButton"];
            
        int levelNumber= [ [[GameSettings shared] getGlobalForKey:@"selectedLevel"] intValue];
        int nextLevelNumber=levelNumber+1;
        if(nextLevelNumber>96)
        {
            nextLevelNumber=1;
        }
            NSString *hasPurchased=[[GameSettings shared] getGlobalForKey:@"HasPurchased"];
            if(nextLevelNumber==17 && [hasPurchased isEqualToString:@"NO"])
            {
                CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
                [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[UpgradeMenu scene]]]; 
                return YES;
            }
        
        NSString *nextLevelNumberString=[NSString stringWithFormat:@"%d",nextLevelNumber];
        [[GameSettings shared] setGlobal:nextLevelNumberString ForKey:@"selectedLevel"];
        if([_parentController.gameMode isEqualToString:@"solo"]||[_parentController.gameMode isEqualToString:@"oneDevice"])
        {
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[GameLayer scene]]]; 
        }
        else if ([_parentController.gameMode isEqualToString:@"blueTooth"]){
            
            [_parentController showMessage:nextLevelNumberString];
            /*
            _parentController.waitingAlert = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"waiting for response...."
                                                                       delegate:_parentController
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"Cancel",nil];
            [_parentController.waitingAlert show];
            [_parentController.waitingAlert release];
            */
            
        }
        }
        
    }
    
    if (touchOrigin2.x>ADJUST_X(60) && touchOrigin2.x<ADJUST_X(260) && touchOrigin2.y>ADJUST_Y(220) && touchOrigin2.y<ADJUST_Y(260))
    {
        [_playAgainButton playbuttonAnimation];
        
       
        if([_parentController.gameMode isEqualToString:@"solo"]||[_parentController.gameMode isEqualToString:@"oneDevice"])
        {
            [_parentController newGame];
            [self removeFromParentAndCleanup:YES];
        }
        else if ([_parentController.gameMode isEqualToString:@"blueTooth"]){
            
            [_parentController showMessage:[[GameSettings shared] getGlobalForKey:@"selectedLevel"]];
            
            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                       message:@"waiting for response...."
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"Cancel",nil];
            [alert show];
            [alert release];
            */
        }
        
          [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    }
    
    if (touchOrigin2.x>ADJUST_X(60) && touchOrigin2.x<ADJUST_X(260) && touchOrigin2.y>ADJUST_Y(180) && touchOrigin2.y<ADJUST_Y(220))
    {
        [_mainMenuButton playbuttonAnimation];
        
         //[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseLevelMenu scene]]]; 

         
        
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
    
    [_nextLevelButton update:dt];
    [_playAgainButton update:dt];
    [_mainMenuButton update:dt];
    
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[GameSettings shared] setGlobal:@"NO" ForKey:@"touchEnable"];
        NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
        [[GameSettings shared] setGlobal:playerName ForKey:@"OrangePlayer"];
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[GameLayer scene]]]; 
        [_parentController reply:@"YES"];
        
    }
    else {
        [_parentController reply:@"NO"];
    }
    
}

@end
