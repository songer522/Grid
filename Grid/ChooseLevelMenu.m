//
//  ChooseLevelMenu.m
//  Grid
//
//  Created by Yang Song on 5/3/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "ChooseLevelMenu.h"
#import "DeviceSettings.h"
#import "LevelButton.h"
#import "GameSettings.h"
#import "TextField.h"
#import "MainMenu.h"
#import "UpgradeMenu.h"
#import "GameLayer.h"
#import "InAppPurchaseManager.h"
#import "ChooseIslandMenu.h"

@implementation ChooseLevelMenu
@synthesize currentSession;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ChooseLevelMenu *layer = [ChooseLevelMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init])) {

		
		// ask director the the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
		gameMode=[[GameSettings shared] getGlobalForKey:@"gameMode"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ChooseLevelSprites.plist" ];
       
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MenuBackground.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"upgradeSprite.plist" ];
      [[InAppPurchaseManager shared] loadStoreWithDelegate:self];
        CCSprite *background=[CCSprite spriteWithSpriteFrameName:@"Graphic_MainMenuBack.png"];
        
        [background setPosition:ADJUST_CCP(ccp(160,240))];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level1"];
        
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level2"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level3"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level4"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level5"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level6"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level7"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level8"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level9"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level10"];
        
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level11"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level12"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level13"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level14"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level15"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level16"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level17"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level18"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level19"];
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"level20"];
        
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level21"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level22"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level23"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level24"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level25"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level26"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level27"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level28"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level29"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level30"];
        
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level31"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level32"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level33"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level34"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level35"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level36"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level37"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level38"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level39"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level40"];
        
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level51"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level52"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level53"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level54"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level55"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level56"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level57"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level58"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level59"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level60"];
        
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level41"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level42"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level43"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level44"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level45"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level46"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level47"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level48"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level49"];
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"level50"];
         
         
        [self addChild: background];
     
        _buttonArray1=[[NSMutableArray alloc] init];
        _buttonArray2=[[NSMutableArray alloc] init];
        _buttonArray3=[[NSMutableArray alloc] init];
        _isSoundOn=YES;
        _isEditing=NO;
        NSString *soundSetting=[[GameSettings shared] getGlobalForKey:@"isSoundOn"];
        if([soundSetting isEqualToString:@"NO"])
        {
            _isSoundOn=NO;
        }
        else 
        {
            _isSoundOn=YES;
        }

        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        if([gameMode isEqualToString:@"blueTooth"])
        {
       [self setupBluetoothSession];
            _waitToShowTextfield3=0.6;
        }
        [self loadButton];
        
        //_title=[CCLabelTTF labelWithString:@"Level Select" fontName:@"Marker Felt" fontSize:HD_TEXT(38)];
        //[_title setPosition:ADJUST_CCP(ccp(160,450))];
        if([gameMode isEqualToString:@"oneDevice"])
        {
        _waitToShowTextField1=0.6;
        _waitToShowTextField2=0.6;
        }
        if([gameMode isEqualToString:@"solo"])
        {
           _waitToShowTextfield3=0.6;
        }
        
                
        _goBackButton=[CCSprite spriteWithSpriteFrameName:@"Button_GoBack.png"];
        [_goBackButton setPosition:ADJUST_CCP(ccp(30,455))];
        if(_isSoundOn)
        {
            _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOn.png"];
        }
        else {
            _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOff.png"];
        }
        [_soundButton setPosition:ADJUST_CCP(ccp(290,455))];
        
        //[self addChild:_title];
        [self addChild:_goBackButton];
        [self addChild:_soundButton];
        
       [self schedule:@selector(update:)];
        [self getMedalNumbers];
        /*
        
        NSString *HasName=[[GameSettings shared] getGlobalForKey:@"playerName"];
        if(![HasName isEqualToString:@"YES"]&&[gameMode isEqualToString:@"blueTooth"])
        {
            TextField *textField=[TextField textFieldWithFrame:CGRectMake(ADJUST_X(160), ADJUST_Y(240), HD_PIXELS(300), HD_PIXELS(200))];
        }
        */
		        
	}
	return self;
}


-(void)setupBluetoothSession
{
    currentSession=[[GameSettings shared] getObjForKey:@"session"];
    currentSession.delegate=self;
    [currentSession setDataReceiveHandler:self withContext:nil];
}

-(void)loadButton
{
    /*
   NSMutableArray *_pages = [[NSMutableArray alloc] initWithCapacity:3];
    CCLayer *_layer=[CCLayer node];
    for (int i=1; i<6; i++) {
        for (int j=1; j<5; j++) {
            LevelButton *button=[LevelButton levelButtonWithId:(j+(i-1)*4)];
            [button setPosition:ADJUST_CCP(ccp(40+80*(j-1),380-70*(i-1)))];
            [_layer addChild:button];
            [_buttonArray1 addObject:button];
        }
    }
    
    CCLayer *_layer2=[CCLayer node];
    for (int i=1; i<6; i++) {
        for (int j=1; j<5; j++) {
            LevelButton *button=[LevelButton levelButtonWithId:(j+(i-1)*4)+20];
            [button setPosition:ADJUST_CCP(ccp(40+80*(j-1),380-70*(i-1)))];
            [_layer2 addChild:button];
            [_buttonArray2 addObject:button];
        }
    }
    
    CCLayer *_layer3=[CCLayer node];
    for (int i=1; i<6; i++) {
        for (int j=1; j<5; j++) {
            LevelButton *button=[LevelButton levelButtonWithId:(j+(i-1)*4)+40];
            [button setPosition:ADJUST_CCP(ccp(40+80*(j-1),380-70*(i-1)))];
            [_layer3 addChild:button];
            [_buttonArray3 addObject:button];
        }
    }
    
    
   [_pages addObject:_layer];
    
    NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];
    if([hasPurchased isEqualToString:@"YES"])
    {
 [_pages addObject:_layer2];
[_pages addObject:_layer3];
    }
    else {
        UpgradeMenu *menu=[UpgradeMenu UpgradeMenuLayer];
         _upgradeButton=[Button buttonAtPosition:ADJUST_CCP(ccp(130,455)) andImage:@"Button_Upgrade.png"];
        [_upgradeButton setScale:0.8];
        [menu addChild:_upgradeButton];
        [_pages addObject:menu];
    }
_scroller = [[CCScrollLayer alloc] initWithLayers:_pages widthOffset: 0];
_scroller.minimumTouchLengthToChangePage = 30.0f;
    int pageNumber=[[[GameSettings shared] getGlobalForKey:@"pageNumber"] intValue];
    [_scroller moveToPage:pageNumber];
[self addChild:_scroller];
_scroller.showPagesIndicator=YES;
    _scroller.pagesIndicatorPosition=ADJUST_CCP(ccp(160,20));

*/
    
NSString *islandNum=[[GameSettings shared] getGlobalForKey:@"island"];

int page=[islandNum intValue];

CCLayer *_layer=[CCLayer node];
for (int i=1; i<5; i++) {
    for (int j=1; j<5; j++) {
        LevelButton *button=[LevelButton levelButtonWithId:((j+(i-1)*4)+page*16)];
        [button setPosition:ADJUST_CCP(ccp(40+80*(j-1),380-70*(i-1)))];
        [_layer addChild:button];
        [_buttonArray1 addObject:button];
    }
}
[self addChild:_layer];

}


-(void)getMedalNumbers
{
    int totalMedal=0;
    for(LevelButton *obj in _buttonArray1)
    {
        if(obj.hasMedal==YES)
        {
            totalMedal++;
        }
    }
    NSString *islandNumber= [[GameSettings shared] getGlobalForKey:@"island"];
    [[GameSettings shared] setGlobal:[NSString stringWithFormat:@"%d",totalMedal] ForKey:[NSString stringWithFormat:@"MedalNumberForIsland%@",islandNumber]];
}

-(NSMutableArray*)getCurrentArray
{
    NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];

    

    
    
    if(_scroller.currentScreen==0)
    {
        return _buttonArray1;
    }
else if(_scroller.currentScreen==1&&[hasPurchased isEqualToString:@"YES"]){
    return _buttonArray2;
}
else if(_scroller.currentScreen==2)
{
    return _buttonArray3;  
}
else {
    return nil;
}
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{

    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    if (touchOrigin2.x>ADJUST_X(0) && touchOrigin2.x<ADJUST_X(50) && touchOrigin2.y>ADJUST_Y(445) && touchOrigin2.y<ADJUST_Y(480))
    {
        
        [myTextField1 removeFromSuperview];
        [myTextField2 removeFromSuperview];
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        
        [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseIslandMenu scene]]];
        
        
    }
    
    if (touchOrigin2.x>ADJUST_X(50) && touchOrigin2.x<ADJUST_X(250) && touchOrigin2.y>ADJUST_Y(425) && touchOrigin2.y<ADJUST_Y(480))
    {
        NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];
        
        if(_scroller.currentScreen==1&&[hasPurchased isEqualToString:@"NO"])
        {
            [_upgradeButton playbuttonAnimation];
             [[InAppPurchaseManager shared] purchaseProductId:kInAppPurchaseUpgradeToFullVersion Delegate:self];
         
        }
    }
    if(touchOrigin2.x>ADJUST_X(260) && touchOrigin2.x<ADJUST_X(320) && touchOrigin2.y>ADJUST_Y(425) && touchOrigin2.y<ADJUST_Y(480))
    {
        
        if(_isSoundOn)
        {
            [_soundButton setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_SoundOff.png"]];
            _isSoundOn=NO;
            [[GameSettings shared] setGlobal:@"NO" ForKey:@"isSoundOn"];
            
        }
        else
        {
            [_soundButton setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_SoundOn.png"]];
            _isSoundOn=YES;
            [[GameSettings shared] setGlobal:@"YES" ForKey:@"isSoundOn"];
        }
    }
    //NSMutableArray *_buttonArray=[self getCurrentArray];
    
    for(LevelButton *obj in _buttonArray1)
    {
        if([obj checkTouchAtPosition:touchOrigin2]&&!_isEditing)
        {
            if([gameMode isEqualToString:@"blueTooth"])
            {
                
                NSString *unlockedValue = [[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"level%d",obj.buttonId]];
                
                
                
                
                if ([unlockedValue isEqualToString:@"YES"])
                    
                {
                    
                    
                    NSString *levelNumber=[NSString stringWithFormat:@"%d",obj.buttonId];
                    [[GameSettings shared] setGlobal:levelNumber ForKey:@"selectedLevel"];
                    NSString *buttonNumber=obj.levelNumber.string;
                    if(buttonNumber)
                    {

                    [[GameSettings shared] setGlobal:buttonNumber ForKey:@"levelNumberOnButton"];
                    }
                   // NSString *pageNumber=[NSString stringWithFormat:@"%d",_scroller.currentScreen];
                    //[[GameSettings shared] setGlobal:pageNumber ForKey:@"pageNumber"];
                    [self showMessage:[NSString stringWithFormat:@"%d", obj.buttonId]];
                    _waitingAlert = [[UIAlertView alloc] initWithTitle:@""
                                                               message:@"waiting for response...."
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"Cancel",nil];
                    [_waitingAlert show];
                    [_waitingAlert release];
                }
                
            }
            else
            {
                //NSString *pageNumber=[NSString stringWithFormat:@"%d",_scroller.currentScreen];
               // [[GameSettings shared] setGlobal:pageNumber ForKey:@"pageNumber"];
                if([obj ButtonPressed])
                {
                    [myTextField1 removeFromSuperview];
                    [myTextField2 removeFromSuperview];
                }
                
                
            }
        }
    }
}


- (void)update:(ccTime)dt
{
    if(_waitToShowTextField1>0)
    {
        _waitToShowTextField1=_waitToShowTextField1-dt;
        
        if(_waitToShowTextField1<0)
        {
            player1=[CCLabelTTF labelWithString:@"Player 1" fontName:@"Impact" fontSize:HD_TEXT(16)];
            [player1 setPosition:ADJUST_CCP(ccp(100,467))];
            
            [self addChild:player1];
            myTextField1 = [[UITextField alloc] initWithFrame: CGRectMake(ADJUST_X(60) ,ADJUST_Y(25),HD_PIXELS(80), HD_PIXELS(25))];
            //[myTextField setBackground:[UIImage imageNamed:@"Black50.png"]];
            [myTextField1 setBackgroundColor: [UIColor whiteColor]];
            myTextField1.delegate=self;
        
            myTextField1.borderStyle=UITextBorderStyleRoundedRect;
           // myTextField1.font=[UIFont systemFontOfSize:HD_PIXELS(14)];
            myTextField1.font=[UIFont fontWithName:@"Impact" size:HD_TEXT2(14)];
            myTextField1.text=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
            myTextField1.textAlignment=UITextAlignmentCenter;
            myTextField1.tag=1;

            UIView* view = [[CCDirector sharedDirector] view];
            [view addSubview:myTextField1];

        }
    }
    if(_waitToShowTextField2>0)
    {
        _waitToShowTextField2=_waitToShowTextField2-dt;
        
        if(_waitToShowTextField2<0)
        {
            player2=[CCLabelTTF labelWithString:@"Player 2" fontName:@"Impact" fontSize:HD_TEXT(16)];
            [player2 setPosition:ADJUST_CCP(ccp(220,467))];
            [self addChild:player2];
            
            myTextField2 = [[UITextField alloc] initWithFrame: CGRectMake(ADJUST_X(180) ,ADJUST_Y(25),HD_PIXELS(80), HD_PIXELS(25))];
            //[myTextField setBackground:[UIImage imageNamed:@"Black50.png"]];
            [myTextField2 setBackgroundColor: [UIColor whiteColor]];
            myTextField2.delegate=self;
            myTextField2.borderStyle=UITextBorderStyleRoundedRect;
             //myTextField2.font=[UIFont systemFontOfSize:HD_PIXELS(14)];
            myTextField2.font=[UIFont fontWithName:@"Impact" size:HD_TEXT2(14)];
           myTextField2.text=[[GameSettings shared] getGlobalForKey:@"Player2Name"];
            myTextField2.textAlignment=UITextAlignmentCenter;
            myTextField2.tag=2;
            UIView* view = [[CCDirector sharedDirector] view];
            [view addSubview:myTextField2];
            
        }
    } 
    if(_waitToShowTextfield3>0)
    {
        _waitToShowTextfield3=_waitToShowTextfield3-dt;
        
        if(_waitToShowTextfield3<0)
        {
            player2=[CCLabelTTF labelWithString:@"Your Name" fontName:@"Impact" fontSize:HD_TEXT(16)];
            [player2 setPosition:ADJUST_CCP(ccp(160,467))];
            [self addChild:player2];
            
            myTextField1 = [[UITextField alloc] initWithFrame: CGRectMake(ADJUST_X(120) ,ADJUST_Y(25),HD_PIXELS(80), HD_PIXELS(25))];
            //[myTextField setBackground:[UIImage imageNamed:@"Black50.png"]];
            [myTextField1 setBackgroundColor: [UIColor whiteColor]];
            myTextField1.delegate=self;
            myTextField1.borderStyle=UITextBorderStyleRoundedRect;
             //myTextField1.font=[UIFont systemFontOfSize:HD_PIXELS(14)];
            myTextField1.font=[UIFont fontWithName:@"Impact" size:HD_TEXT2(14)];
          myTextField1.text=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
            myTextField1.textAlignment=UITextAlignmentCenter;
          myTextField1.tag=1;
            UIView* view = [[CCDirector sharedDirector] view];
            [view addSubview:myTextField1];
            
        }
    }     

    [_upgradeButton update:dt];
    
    NSString *hasPurchased = [[GameSettings shared] getGlobalForKey:@"HasPurchased"];
    if([hasPurchased isEqualToString:@"NO"]&&_scroller.currentScreen==1)
    {
        [myTextField1 setHidden:YES];
        [myTextField2 setHidden:YES];
        [player1 setVisible:NO];
        [player2 setVisible:NO];
    }
    
    if([hasPurchased isEqualToString:@"NO"]&&_scroller.currentScreen==0)
    {
        [myTextField1 setHidden:NO];
        [myTextField2 setHidden:NO];
        [player1 setVisible:YES];
        [player2 setVisible:YES];
    }
}





- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    picker.delegate = nil;
    [picker autorelease];
}

-(IBAction) btnDisconnect:(id) sender {
    //[self.currentSession disconnectFromAllPeers];
    //[self.currentSession release];
    //currentSession = nil;
}


- (void)session:(GKSession *)session
           peer:(NSString *)peerID
 didChangeState:(GKPeerConnectionState)state {
    switch (state)
    {
        case GKPeerStateConnected:
            NSLog(@"connected");
            break;
        case GKPeerStateDisconnected:
            NSLog(@"disconnected");
              //[self.currentSession release];
            currentSession = nil;
            
            break;
        case GKPeerStateAvailable:
            NSLog(@"available");
            break;
        case GKPeerStateConnecting:
            NSLog(@"connecting");
            break;
        case GKPeerStateUnavailable:
            NSLog(@"unavailable");
            break;
    
    }
}
- (void) session:(GKSession *)session didFailWithError:(NSError *)error
{
    
}

- (void) mySendDataToPeers:(NSMutableData *) data
{
    if (currentSession)
        [self.currentSession sendDataToAllPeers:data
                                   withDataMode:GKSendDataReliable
                                          error:nil];
}

- (void)showMessage:(NSString *)buttonID
{
   
   //NSString *str=@"hellohello";
     NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
     NSString *invatationText = [NSString stringWithFormat:  @"%@ would like to invite you play level%@", playerName,buttonID];
     NSString *levelNumber=buttonID;
    [[GameSettings shared] setGlobal:playerName ForKey:@"BluePlayer"];
    [[GameSettings shared] setGlobal:@"YES" ForKey:@"touchEnable"];
    NSString *isInvitation=@"YES";
    NSString *isReply=@"NO";
    NSArray *valueArray=[NSArray arrayWithObjects:playerName,levelNumber,invatationText,isInvitation,isReply,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"PlayerName"], [NSString stringWithFormat:@"LevelNumber"],[NSString stringWithFormat:@"Text"],[NSString stringWithFormat:@"isInvation"],[NSString stringWithFormat:@"isReply"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    
    //data = [str dataUsingEncoding: NSASCIIStringEncoding];
     NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    [self mySendDataToPeers:data];
    [data release];
   }

-(void)reply:(NSString *)yesOrNo
{
    NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
    NSString *isInvitation=@"NO";
    NSString *isReply=@"YES";
    NSString *answer=yesOrNo;
    NSArray *valueArray=[NSArray arrayWithObjects:isInvitation,isReply,answer,playerName, nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isInvation"],[NSString stringWithFormat:@"isReply"],[NSString stringWithFormat:@"answer"],[NSString stringWithFormat:@"PlayerName"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    
    //data = [str dataUsingEncoding: NSASCIIStringEncoding];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    [self mySendDataToPeers:data];
    [data release];

}


- (void) receiveData:(NSMutableData *)data
            fromPeer:(NSString *)peer
           inSession:(GKSession *)session
             context:(void *)context {
    //---convert the NSData to NSString---
    
    NSMutableData *newData = data;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:newData];
    NSDictionary *infoList = [unarchiver decodeObjectForKey:@"Data"] ;
    [unarchiver finishDecoding];
   [unarchiver release];
    //[newData release];
    
    
    NSString *isInvation=[infoList objectForKey:@"isInvation"];
    NSString *isReply=[infoList objectForKey:@"isReply"];
    
    if([isInvation isEqualToString:@"YES"]&&[isReply isEqualToString:@"NO"])
    {
    NSString *text=[infoList objectForKey:@"Text"];
    NSString *playerName=[infoList objectForKey:@"PlayerName"];
   [[GameSettings shared] setGlobal:playerName ForKey:@"BluePlayer"];
    NSString *levelNumber=[infoList objectForKey:@"LevelNumber"];
   [[GameSettings shared] setGlobal:levelNumber ForKey:@"selectedLevel"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"YES",nil];
    [alert show];
    [alert release];
    }
    else if([isInvation isEqualToString:@"NO"]&&[isReply isEqualToString:@"YES"])
    {
        NSString *answer=[infoList objectForKey:@"answer"];
        
        if([answer isEqualToString:@"YES"])
        {
            NSString *orangePlayerName=[infoList objectForKey:@"PlayerName"];
            [[GameSettings shared] setGlobal:orangePlayerName ForKey:@"OrangePlayer"];
            [_waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
            [myTextField1 removeFromSuperview];
            [myTextField2 removeFromSuperview];
            CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
            [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[GameLayer scene]]]; 

        }
        else {
            if(_waitingAlert.isVisible)
            {
                [_waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
            }
           /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"invatition rejected"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Okay",nil];
            [alert show];
            [alert release];
            */
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[GameSettings shared] setGlobal:@"NO" ForKey:@"touchEnable"];
        NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
        [[GameSettings shared] setGlobal:playerName ForKey:@"OrangePlayer"];
        [myTextField1 removeFromSuperview];
        [myTextField2 removeFromSuperview];
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[GameLayer scene]]]; 
        [self reply:@"YES"];
        
    }
    else {
       [self reply:@"NO"];
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _isEditing=YES;
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
     _isEditing=NO;
    if(textField.tag==1)
    {
        if(![textField.text isEqualToString:@""])
        {
        [[GameSettings shared] setGlobal:textField.text ForKey:@"Player1Name"];
        }
        else {
            [[GameSettings shared] setGlobal:@"Player 1" ForKey:@"Player1Name"];
        }
    }
    else if(textField.tag==2) {
        if(![textField.text isEqualToString:@""])
        {
        [[GameSettings shared] setGlobal:textField.text ForKey:@"Player2Name"];
        }
        else {
            [[GameSettings shared] setGlobal:@"Player 2" ForKey:@"Player1Name"];
        }
    }
    //[textField resignFirstResponder];    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _isEditing=NO;
    if(textField.tag==1)
    {
        if(![textField.text isEqualToString:@""])
        {
            [[GameSettings shared] setGlobal:textField.text ForKey:@"Player1Name"];
        }
        else {
            [[GameSettings shared] setGlobal:@"Player 1" ForKey:@"Player1Name"];
        }
    }
    else if(textField.tag==2) {
        if(![textField.text isEqualToString:@""])
        {
            [[GameSettings shared] setGlobal:textField.text ForKey:@"Player2Name"];
        }
        else {
            [[GameSettings shared] setGlobal:@"Player 2" ForKey:@"Player1Name"];
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
    [_buttonArray1 release];
      [_buttonArray2 release];
      [_buttonArray3 release];
    
      [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"ChooseLevelSprites.plist"];
     [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MenuBackground.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"Black50.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"upgradeSprite.plist"];
    
}

@end
