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
#import "SimpleAudioEngine.h"
#import "ChooseIslandMenu.h"
#import "FullScreenBackground.h"
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
            
        _gameMode=[[GameSettings shared] getGlobalForKey:@"gameMode"];
        _background=[CCSprite spriteWithSpriteFrameName:@"Graphic_Black50.png"];
        [FullScreenBackground stretchSpriteToFillScene:_background];
        _window=[CCSprite spriteWithSpriteFrameName:@"Graphic_MessageWindow.png"];
        [_window setPosition:ADJUST_CCP(ccp(160,240))];
        _scoreWindow=[CCSprite spriteWithSpriteFrameName:@"Graphic_FinalScoreBack.png"];
        [_scoreWindow setPosition:ADJUST_CCP(ccp(160,240))];
       
                
        _playAgainButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,170)) andImage:@"Button_NewGameL.png"];

        _mainMenuButton=[Button buttonAtPosition:ADJUST_CCP(ccp(95,170)) andImage:@"Button_MenuL.png"];
        NSString *ClearCurrentLevel=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"ClearLevel%@",[[GameSettings shared] getGlobalForKey:@"selectedLevel"]]];
        
        if([ClearCurrentLevel isEqualToString:@"YES"]||![_gameMode isEqualToString:@"solo"])
        {
            _nextLevelButton=[Button buttonAtPosition:ADJUST_CCP(ccp(225,170)) andImage:@"Button_NextLevel.png"];
        }
        else {
            _nextLevelButton=[Button buttonAtPosition:ADJUST_CCP(ccp(225,170)) andImage:@"Button_NextLevel_Grey.png"];
        }

        _touchEnable=NO;
                
        [self setOpacity:0];
        [self setScale:0];
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES]; 
        
        [self addChild:_background];
        [self addChild:_window];
        [self addChild:_scoreWindow];
        
        if([_gameMode isEqualToString:@"solo"])
        {
            
        NSString *WonGameOrNot=[[GameSettings shared] getGlobalForKey:@"WonGame"];
        if([WonGameOrNot isEqualToString:@"YES"])
        {
        
            int levelNumber= [ [[GameSettings shared] getGlobalForKey:@"selectedLevel"] intValue];
            int remain=levelNumber%16;
            if(!remain==0)
            {

            _resultInfo=[CCSprite spriteWithSpriteFrameName:@"Graphic_LevelCleared.png"];
            }
            else {
                _resultInfo=[CCSprite spriteWithSpriteFrameName:@"Graphic_IslandCleared.png"];
                 [_nextLevelButton.buttonGraphic setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_NextLevel_Grey.png"]];
                
            }
            [_resultInfo setPosition:ADJUST_CCP(ccp(160,240))];
            [self addChild:_resultInfo];
        }
        else if([WonGameOrNot isEqualToString:@"NO"]){
            _resultInfo=[CCSprite spriteWithSpriteFrameName:@"Graphic_LevelFailed.png"];
            [_resultInfo setPosition:ADJUST_CCP(ccp(160,240))];
            [self addChild:_resultInfo];
        }
          NSString *levelNumber=[[GameSettings shared] getGlobalForKey:@"selectedLevel"];
        
        
        NSString *currentScore=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"currentScoreLevel%@",levelNumber]];
        NSString *bestScore=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"bestScoreLevel%@",levelNumber]];
        NSString *isNewRecord=[[GameSettings shared] getGlobalForKey:@"isNewBestSocre"];
        
        //_score=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Score: %@",currentScore] fntFile:@"EndGame5.fnt"];
        _score=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %@",currentScore] dimensions:CGSizeMake(HD_PIXELS(100), HD_PIXELS(100)) alignment:UITextAlignmentLeft fontName:@"Impact" fontSize:HD_PIXELS(18)];
        [_score setPosition:ADJUST_CCP(ccp(125,219))];
        [_score setColor:ccc3(25, 25, 25)];
        [_score setOpacity:0];
        [self addChild: _score];
        _bestScore=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Best Score: %@",bestScore] dimensions:CGSizeMake(HD_PIXELS(200), HD_PIXELS(100)) alignment:UITextAlignmentLeft fontName:@"Impact" fontSize:HD_PIXELS(18)];
        [_bestScore setColor:ccc3(25, 25, 25)];
        [_bestScore setPosition:ADJUST_CCP(ccp(175,189))];
        [_bestScore setOpacity:0];
        [self addChild:_bestScore];
        _newRecord =[CCSprite spriteWithSpriteFrameName:@"Graphic_NewRecord.png"];
        [_newRecord setPosition:ADJUST_CCP(ccp(160,240))];
        if([isNewRecord isEqualToString:@"YES"])
        {
            
            [self addChild: _newRecord];
              [_newRecord setOpacity:0];
        }
        }
        
        else 
        {
            _resultInfo=[CCSprite spriteWithSpriteFrameName:@"Graphic_GameOver.png"];
            [_resultInfo setPosition:ADJUST_CCP(ccp(160,240))];
            [self addChild:_resultInfo];
            NSString *player1Score=@"";
            NSString *player1Name=@"";
            
            NSString *player2Score=@"";
            NSString *player2Name=@"";
            if([_gameMode isEqualToString:@"oneDevice"])
            {
          player1Score=[[GameSettings shared] getGlobalForKey:[[GameSettings shared] getGlobalForKey:@"Player1Name"]];
           player1Name=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
            
            player2Score=[[GameSettings shared] getGlobalForKey:[[GameSettings shared] getGlobalForKey:@"Player2Name"]];
            player2Name=[[GameSettings shared] getGlobalForKey:@"Player2Name"];
                
            }
            else if([_gameMode isEqualToString:@"blueTooth"])
            {
               player1Score=[[GameSettings shared] getGlobalForKey:[[GameSettings shared] getGlobalForKey:@"BluePlayer"]];
                player1Name=[[GameSettings shared] getGlobalForKey:@"BluePlayer"];
                
              player2Score=[[GameSettings shared] getGlobalForKey:[[GameSettings shared] getGlobalForKey:@"OrangePlayer"]];
               player2Name=[[GameSettings shared] getGlobalForKey:@"OrangePlayer"];
            }
            else {
              player1Score=[[GameSettings shared] getGlobalForKey:[[GameSettings shared] getGlobalForKey:@"BluePlayer"]];
                player1Name=[[GameSettings shared] getGlobalForKey:@"BluePlayer"];
                
                player2Score=[[GameSettings shared] getGlobalForKey:[[GameSettings shared] getGlobalForKey:@"OrangePlayer"]];
               player2Name=[[GameSettings shared] getGlobalForKey:@"OrangePlayer"];
            }
            
           if([player1Score isEqualToString:@""])
           {
               player1Score=@"0";
           }
            if([player2Score isEqualToString:@""])
            {
                player2Score=@"0";
            }
            
            if(player1Name.length>8)
            {
                player1Name= [[player1Name substringToIndex:7] stringByAppendingFormat:@".."];
            }
            if(player2Name.length>8)
            {
                player2Name= [[player2Name substringToIndex:7] stringByAppendingFormat:@".."];
            }
            
            _player1Tally=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@  %@ :",player1Name,player1Score] dimensions:CGSizeMake(HD_PIXELS(100), HD_PIXELS(100)) alignment:UITextAlignmentRight fontName:@"Impact" fontSize:HD_PIXELS(18)];
            [_player1Tally setColor:ccc3(25, 25, 25)];
            [_player1Tally setPosition:ADJUST_CCP(ccp(115,219))];
            _player2Tally=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@  %@",player2Score,player2Name] dimensions:CGSizeMake(HD_PIXELS(100), HD_PIXELS(100)) alignment:UITextAlignmentLeft fontName:@"Impact" fontSize:HD_PIXELS(18)];
            [_player2Tally setColor:ccc3(25, 25, 25)];
             [_player2Tally setPosition:ADJUST_CCP(ccp(218,219))];
            [self addChild:_player1Tally];
            [self addChild:_player2Tally];
            [_player1Tally setOpacity:0];
            [_player2Tally setOpacity:0];
            
            NSString *WinnerName=[[GameSettings shared] getGlobalForKey:@"WinnerName"];
            if(![WinnerName isEqualToString:@""])
            {
                _tallyResult=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ Won",WinnerName] dimensions:CGSizeMake(HD_PIXELS(200), HD_PIXELS(100)) alignment:UITextAlignmentCenter fontName:@"Impact" fontSize:HD_PIXELS(18)];
            }
            else {
                _tallyResult=[CCLabelTTF labelWithString:@"Tie Game" dimensions:CGSizeMake(HD_PIXELS(100), HD_PIXELS(100)) alignment:UITextAlignmentCenter fontName:@"Impact" fontSize:HD_PIXELS(18)];
            }
            [_tallyResult setColor:ccc3(25, 25, 25)];
            [_tallyResult setPosition:ADJUST_CCP(ccp(160,189))];
            [_tallyResult setOpacity:0];
            [self addChild:_tallyResult];
        }
        
        _close=[CCSprite spriteWithSpriteFrameName:@"Graphic_HTP_6_Delete.png"];
        [_close setPosition:ADJUST_CCP(ccp(160,240))];
        
        [self setOpacity:0];
        [self setScale:0];
        [_nextLevelButton setScale:0];
        [_playAgainButton setScale:0];
        [_mainMenuButton setScale:0];
      
        [self addChild:_nextLevelButton];
        [self addChild:_playAgainButton];
        [self addChild:_mainMenuButton];
        [self addChild:_close];
        
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
    [_scoreWindow setOpacity:opacity];
    [_resultInfo setOpacity:opacity];
    [_close setOpacity:opacity];

}
-(void)setScale:(float)scale
{
    [_window setScale:scale];
    [_close setScale:scale];
   // [_nextLevelButton setScale:scale];
    //[_playAgainButton setScale:scale];
    //[_mainMenuButton setScale:scale];
    [_scoreWindow setScale:scale];
    [_resultInfo setScale:scale];
   
    
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
            return YES;
        }

        
        
        
    if (touchOrigin2.x>ADJUST_X(200) && touchOrigin2.x<ADJUST_X(250) && touchOrigin2.y>ADJUST_Y(145) && touchOrigin2.y<ADJUST_Y(195))
    {
        NSString *isHost=[[GameSettings shared] getGlobalForKey:@"isHost"];
        if([isHost isEqualToString:@"NO"]&&[_parentController.gameMode isEqualToString:@"network"])
        {
            return YES;
        }
        
        NSString *ClearCurrentLevel=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"ClearLevel%@",[[GameSettings shared] getGlobalForKey:@"selectedLevel"]]];
         int levelNumber= [ [[GameSettings shared] getGlobalForKey:@"selectedLevel"] intValue];
        int remain=levelNumber%16;
        //if([ClearCurrentLevel isEqualToString:@"YES"]&&!remain==0)
        if(([ClearCurrentLevel isEqualToString:@"YES"]&&!remain==0&&[_gameMode isEqualToString:@"solo"])||![_gameMode isEqualToString:@"solo"])
        {
        [_nextLevelButton playbuttonAnimation];
             [[SimpleAudioEngine sharedEngine] playEffect:@"menuForward.mp3"];
            _parentController.gridView.waitToPlayBackgroundMusic=2.0;
            int levelButtonNumber=[[[GameSettings shared] getGlobalForKey:@"levelNumberOnButton"] intValue];
            int nextLevelButtonNumber=levelButtonNumber+1;
            
            if(nextLevelButtonNumber>16)
            {
                nextLevelButtonNumber=1;
                int islandNumber=[[[GameSettings shared] getGlobalForKey:@"island"] intValue];
                int nextIslandNumber=islandNumber+1;
                [[GameSettings shared] setGlobal:[NSString stringWithFormat:@"%d",nextIslandNumber] ForKey:@"island"];
            }
            
            [[GameSettings shared] setGlobal:[NSString stringWithFormat:@"%d",nextLevelButtonNumber] ForKey:@"levelNumberOnButton"];
            
       
        int nextLevelNumber=levelNumber+1;
        if(nextLevelNumber>96)
        {
            nextLevelNumber=96;
        }
            NSString *hasPurchased=[[GameSettings shared] getGlobalForKey:@"HasPurchased"];
            if(nextLevelNumber==49 && [hasPurchased isEqualToString:@"NO"])
            {
                [[GameSettings shared] setGlobal:@"3" ForKey:@"pageNumber"];
                CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
                [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseIslandMenu scene]]]; 
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
            
            _parentController.waitingAlert = [[AlertView alloc] initWithTitle:@""
                                                                        message:@"waiting for response...."
                                                                       delegate:_parentController
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"Cancel",nil];
            _parentController.waitingAlert.tag=2;
            [_parentController.waitingAlert show];
            
           // [_parentController.waitingAlert release];
            
            
        }
            else if([_parentController.gameMode isEqualToString:@"network"])
            {
                [_parentController networkShowMessage:nextLevelNumberString];
                _parentController.waitingAlert = [[AlertView alloc] initWithTitle:@""
                                                                            message:@"waiting for response...."
                                                                           delegate:_parentController
                                                                  cancelButtonTitle:nil
                                                                  otherButtonTitles:@"Cancel",nil];
                _parentController.waitingAlert.tag=2;
                [_parentController.waitingAlert show];
               // [_parentController.waitingAlert release];

            }
        }
        
    }
    
    if (touchOrigin2.x>ADJUST_X(135) && touchOrigin2.x<ADJUST_X(185) && touchOrigin2.y>ADJUST_Y(145) && touchOrigin2.y<ADJUST_Y(195))
    {
        NSString *isHost=[[GameSettings shared] getGlobalForKey:@"isHost"];
        if([isHost isEqualToString:@"NO"]&&[_parentController.gameMode isEqualToString:@"network"])
        {
            return YES;
        }
        
        [_playAgainButton playbuttonAnimation];
         [[SimpleAudioEngine sharedEngine] playEffect:@"menuForward.mp3"];
       _parentController.gridView.waitToPlayBackgroundMusic=2.0;
        if([_parentController.gameMode isEqualToString:@"solo"]||[_parentController.gameMode isEqualToString:@"oneDevice"])
        {
            [_parentController newGame];
            [self removeFromParentAndCleanup:YES];
              [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
        }
        else if ([_parentController.gameMode isEqualToString:@"blueTooth"]){
            
            [_parentController showMessage:[[GameSettings shared] getGlobalForKey:@"selectedLevel"]];
            
            _parentController.waitingAlert = [[AlertView alloc] initWithTitle:@""
                                                                        message:@"waiting for response...."
                                                                       delegate:_parentController
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"Cancel",nil];
            _parentController.waitingAlert.tag=2;
            [_parentController.waitingAlert show];             
            
        }
        else if ([_parentController.gameMode isEqualToString:@"network"]){
            
            [_parentController networkShowMessage:[[GameSettings shared] getGlobalForKey:@"selectedLevel"]];
            
            _parentController.waitingAlert = [[AlertView alloc] initWithTitle:@""
                                                                        message:@"waiting for response...."
                                                                       delegate:_parentController
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"Cancel",nil];
            _parentController.waitingAlert.tag=2;
            [_parentController.waitingAlert show];         
             
        }

        
        
    }
    
    if (touchOrigin2.x>ADJUST_X(70) && touchOrigin2.x<ADJUST_X(120) && touchOrigin2.y>ADJUST_Y(145) && touchOrigin2.y<ADJUST_Y(195))
    {
       
        [_mainMenuButton playbuttonAnimation];
         [[SimpleAudioEngine sharedEngine] playEffect:@"menuForward.mp3"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"MenuMusic.mp3"];
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
            [self setScale:(0.5-_waitToFadeInWindow)*2];
        }
        if(_waitToFadeInWindow<0)
        {
            [self setOpacity:255];
               [self setScale:1];
            if([_gameMode isEqualToString:@"solo"])
            {
            [_bestScore setOpacity:255];
            [_score setOpacity:255];
            NSString *isNewRecord=[[GameSettings shared] getGlobalForKey:@"isNewBestSocre"];
            if([isNewRecord isEqualToString:@"YES"])
            {
            [_newRecord setOpacity:255];
            }
                
              
            }
            else {
                [_player1Tally setOpacity:255];
                [_player2Tally setOpacity:255];
                [_tallyResult setOpacity:255];
            }
            _touchEnable=YES;
            [_nextLevelButton setScale:1];
            [_playAgainButton setScale:1];
            [_mainMenuButton setScale:1];
            
            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
            
            if(_parentController.winOrLose)
            {
            [[SimpleAudioEngine sharedEngine] playEffect:@"wonGame.wav"];
            }
            else {
                 [[SimpleAudioEngine sharedEngine] playEffect:@"lostGame.wav"];
            }
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
- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1)
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
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
        [_parentController reply:@"NO"];
    }
    }
    else {
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
    }
    
}

@end
