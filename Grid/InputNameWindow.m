//
//  InputNameWindow.m
//  Grid
//
//  Created by Song Yang on 6/6/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "InputNameWindow.h"
#import "DeviceSettings.h"
#import "MapSettings.h"
#import "ChooseLevelMenu.h"
#import "GameSettings.h"
#import "UpgradeMenu.h"
#import "SimpleAudioEngine.h"
@implementation InputNameWindow
@synthesize waitToFadeInWindow=_waitToFadeInWindow;


+(id)InputNameWindowInController:(CCLayer*)chooseLevelMenu
{
    return [[self alloc] initInController:chooseLevelMenu];
}

-(id)initInController:(CCLayer*)chooseLevelMenu
{
    if ((self=[super init])) {
        _parentController=chooseLevelMenu;
        _gameMode=[[GameSettings shared] getGlobalForKey:@"gameMode"];
        _background=[CCSprite spriteWithSpriteFrameName:@"Graphic_Black50.png"];
        _doneButton=[Button buttonAtPosition:ADJUST_CCP(ccp(160,240)) andImage:@"Button_Done.png"];
        
        [_background setPosition:ADJUST_CCP(ccp(160,240))];
        _window=[CCSprite spriteWithSpriteFrameName:@"Graphic_MessageWindow.png"];
        [_window setPosition:ADJUST_CCP(ccp(160,240))];
        
         [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES]; 
       
        [self addChild:_background];
        [self addChild:_window];
        [self addChild:_doneButton];
        [self setOpacity:0];
        //if([_gameMode isEqualToString:@"solo"]||[_gameMode isEqualToString:@"blueTooth"]||[_gameMode isEqualToString:@"network"])
        //{
        if(![_gameMode isEqualToString:@"oneDevice"])
        {_waitToShowTextField1=2.3;
     
        
        }
        //}
         if([_gameMode isEqualToString:@"oneDevice"]) {
            _waitToShowTextField2=2.3;
            _waitToShowTextField3=2.3;
        }
         
        _waitToFadeInWindow=2.5;
        
    }
    return self;
}

-(void)setOpacity:(GLubyte)opacity
{
    [_background setOpacity:opacity];
    [_window setOpacity:opacity];
    [_doneButton.buttonGraphic setOpacity:opacity];
   
}
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    if(_touchEnable)
    {
        
        if (touchOrigin2.x>ADJUST_X(50) && touchOrigin2.x<ADJUST_X(270) && touchOrigin2.y>ADJUST_Y(150) && touchOrigin2.y<ADJUST_Y(210))
        {
           
           
           
            
            
            if([_gameMode isEqualToString:@"oneDevice"])
            {
                if(!myTextField1.text||!myTextField2.text)
                {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"menuBack.wav"];
                }
                else {
                    [_doneButton playbuttonAnimation];
                    [myTextField1 removeFromSuperview];
                    [myTextField2 removeFromSuperview];
                    [self removeFromParentAndCleanup:YES];
                    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
                }

            }
            if(!myTextField1.text)
            {
                [[SimpleAudioEngine sharedEngine] playEffect:@"menuBack.wav"];
            }
            else {
                [_doneButton playbuttonAnimation];
                [myTextField1 removeFromSuperview];
                [self removeFromParentAndCleanup:YES];
                [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
            }
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
    [_doneButton update:dt];
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
            
        }
    }
    if(_waitToShowTextField1>0)
    {
        _waitToShowTextField1=_waitToShowTextField1-dt;
        
        if(_waitToShowTextField1<0)
        {
            CCLabelTTF *promt=[CCLabelTTF labelWithString:@"Please Enter a Name" fontName:@"Impact" fontSize:HD_PIXELS(24)];
            [promt setPosition:ADJUST_CCP(ccp(160,300))];
            [promt setColor:ccc3(25, 25, 25)];
            [self addChild:promt];
            myTextField1 = [[UITextField alloc] initWithFrame: CGRectMake(ADJUST_X(55) ,ADJUST_Y(220),HD_PIXELS(222), HD_PIXELS(45))];
            //[myTextField1 setBackground:[UIImage imageNamed:@"Graphic_NameBox.png"]];
            CCSprite *nameBox=[CCSprite spriteWithSpriteFrameName:@"Graphic_NameBox.png"];
            [nameBox setPosition:ADJUST_CCP(ccp(160,270))];
            [self addChild:nameBox];
            [myTextField1 setBackgroundColor: [UIColor clearColor]];
            myTextField1.delegate=self;
            
            //myTextField1.borderStyle=UITextBorderStyleRoundedRect;
            // myTextField1.font=[UIFont systemFontOfSize:HD_PIXELS(14)];
            myTextField1.font=[UIFont fontWithName:@"Impact" size:HD_PIXELS(24)];
            // myTextField1.text=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
            myTextField1.placeholder=@"Your Name";
            myTextField1.textAlignment=UITextAlignmentCenter;
            myTextField1.tag=1;
            UIView* view = [[CCDirector sharedDirector] view];
            [view addSubview:myTextField1];
            [myTextField1 becomeFirstResponder];
            

        }
    }
    if(_waitToShowTextField2>0)
    {
        _waitToShowTextField2=_waitToShowTextField2-dt;
        
        if(_waitToShowTextField2<0)
        {
            //CCLabelTTF *promt=[CCLabelTTF labelWithString:@"Please Enter a Name" fontName:@"Impact" fontSize:HD_PIXELS(24)];
            //[promt setPosition:ADJUST_CCP(ccp(160,300))];
            //[promt setColor:ccc3(25, 25, 25)];
            //[self addChild:promt];
            myTextField1 = [[UITextField alloc] initWithFrame: CGRectMake(ADJUST_X(55) ,ADJUST_Y(170),HD_PIXELS(222), HD_PIXELS(45))];
            //[myTextField1 setBackground:[UIImage imageNamed:@"Graphic_NameBox.png"]];
            CCSprite *nameBox=[CCSprite spriteWithSpriteFrameName:@"Graphic_NameBox.png"];
            [nameBox setPosition:ADJUST_CCP(ccp(160,320))];
            [self addChild:nameBox];
            [myTextField1 setBackgroundColor: [UIColor clearColor]];
            myTextField1.delegate=self;
            
            //myTextField1.borderStyle=UITextBorderStyleRoundedRect;
            // myTextField1.font=[UIFont systemFontOfSize:HD_PIXELS(14)];
            myTextField1.font=[UIFont fontWithName:@"Impact" size:HD_PIXELS(24)];
            myTextField1.text=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
            //myTextField1.placeholder=@"Player 1's Name";
            myTextField1.textAlignment=UITextAlignmentCenter;
            myTextField1.tag=1;
            UIView* view = [[CCDirector sharedDirector] view];
            [view addSubview:myTextField1];
            
            
        }
    }
    if(_waitToShowTextField3>0)
    {
        _waitToShowTextField3=_waitToShowTextField3-dt;
        
        if(_waitToShowTextField3<0)
        {
            //CCLabelTTF *promt=[CCLabelTTF labelWithString:@"Please Enter a Name" fontName:@"Impact" fontSize:HD_PIXELS(24)];
            //[promt setPosition:ADJUST_CCP(ccp(160,300))];
            //[promt setColor:ccc3(25, 25, 25)];
            //[self addChild:promt];
            myTextField2 = [[UITextField alloc] initWithFrame: CGRectMake(ADJUST_X(55) ,ADJUST_Y(230),HD_PIXELS(222), HD_PIXELS(45))];
            //[myTextField2 setBackground:[UIImage imageNamed:@"Graphic_NameBox.png"]];
            CCSprite *nameBox=[CCSprite spriteWithSpriteFrameName:@"Graphic_NameBox.png"];
            [nameBox setPosition:ADJUST_CCP(ccp(160,260))];
            [self addChild:nameBox];
            [myTextField2 setBackgroundColor: [UIColor clearColor]];
            myTextField2.delegate=self;
            
            //myTextField1.borderStyle=UITextBorderStyleRoundedRect;
            // myTextField1.font=[UIFont systemFontOfSize:HD_PIXELS(14)];
            myTextField2.font=[UIFont fontWithName:@"Impact" size:HD_PIXELS(24)];
            // myTextField1.text=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
            myTextField2.placeholder=@"Player 2's Name";
            myTextField2.textAlignment=UITextAlignmentCenter;
            myTextField2.tag=2;
            UIView* view = [[CCDirector sharedDirector] view];
            [view addSubview:myTextField2];
            [myTextField2 becomeFirstResponder];
            
            
        }
    }


}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
   
    if(textField.tag==1)
    {
        if(![textField.text isEqualToString:@""])
        {
            [[GameSettings shared] setGlobal:textField.text ForKey:@"Player1Name"];
            [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player2Name"]];
            
        }
        else {
            //[[GameSettings shared] setGlobal:@"Player1" ForKey:@"Player1Name"];
            [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player2Name"]];
        }
    }
    else if(textField.tag==2) {
        if(![textField.text isEqualToString:@""])
        {
            [[GameSettings shared] setGlobal:textField.text ForKey:@"Player2Name"];
            [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player1Name"]];
        }
        else {
            //[[GameSettings shared] setGlobal:@"Player2" ForKey:@"Player1Name"];
            [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player1Name"]];
        }
    }
    //[textField resignFirstResponder];    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField.tag==1)
    {
        if(![textField.text isEqualToString:@""])
        {
            [[GameSettings shared] setGlobal:textField.text ForKey:@"Player1Name"];
            [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player2Name"]];
        }
        else {
           // [[GameSettings shared] setGlobal:@"Player1" ForKey:@"Player1Name"];
            [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player2Name"]];
        }
    }
    else if(textField.tag==2) {
        if(![textField.text isEqualToString:@""])
        {
            [[GameSettings shared] setGlobal:textField.text ForKey:@"Player2Name"];
            [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player1Name"]];
        }
        else {
           // [[GameSettings shared] setGlobal:@"Player2" ForKey:@"Player1Name"];
            [[GameSettings shared] setGlobal:@"0" ForKey:textField.text];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"Player1Name"]];
        }
        
    }
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(textField.text.length>8 && range.length==0)
    {
        return NO;
    }
    else {
        //NSLog(@"%@",string);
        //NSLog(@"%d",range.location);
        //NSLog(@"%d",range.length);
        return YES;
    }
}

@end
