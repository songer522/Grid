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
#import "CCScrollLayer.h"
#import "MainMenu.h"

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
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ChooseLevelSprites.plist" ];
       
         [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MenuBackground.plist" ];      
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
        [self addChild: background];
     
        _buttonArray=[[NSMutableArray alloc] init];
        _isSoundOn=YES;
        
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
        
        
       // [self setupBluetoothSession];
        [self loadButton];
        
        _title=[CCLabelTTF labelWithString:@"Level Select" fontName:@"Marker Felt" fontSize:HD_TEXT(38)];
        [_title setPosition:ADJUST_CCP(ccp(160,450))];
        
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
        
        [self addChild:_title];
        [self addChild:_goBackButton];
        [self addChild:_soundButton];
        
       
       
        
        //[self schedule:@selector(update:)];
        
		        
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
   NSMutableArray *_pages = [[NSMutableArray alloc] initWithCapacity:3];
    CCLayer *_layer=[CCLayer node];
    for (int i=1; i<6; i++) {
        for (int j=1; j<5; j++) {
            LevelButton *button=[LevelButton levelButtonWithId:(j+(i-1)*4)];
            [button setPosition:ADJUST_CCP(ccp(40+80*(j-1),380-70*(i-1)))];
            [_layer addChild:button];
            [_buttonArray addObject:button];
        }
    }
    
    CCLayer *_layer2=[CCLayer node];
    for (int i=1; i<6; i++) {
        for (int j=1; j<5; j++) {
            LevelButton *button=[LevelButton levelButtonWithId:(j+(i-1)*4)+20];
            [button setPosition:ADJUST_CCP(ccp(40+80*(j-1),380-70*(i-1)))];
            [_layer2 addChild:button];
            [_buttonArray addObject:button];
        }
    }
    
    CCLayer *_layer3=[CCLayer node];
    for (int i=1; i<6; i++) {
        for (int j=1; j<5; j++) {
            LevelButton *button=[LevelButton levelButtonWithId:(j+(i-1)*4)+40];
            [button setPosition:ADJUST_CCP(ccp(40+80*(j-1),380-70*(i-1)))];
            [_layer3 addChild:button];
            [_buttonArray addObject:button];
        }
    }
    
    
   [_pages addObject:_layer];
 [_pages addObject:_layer2];
[_pages addObject:_layer3];

CCScrollLayer  *_scroller = [[CCScrollLayer alloc] initWithLayers:_pages widthOffset: 0];
_scroller.minimumTouchLengthToChangePage = 30.0f;

[self addChild:_scroller];
_scroller.showPagesIndicator=YES;
    _scroller.pagesIndicatorPosition=ADJUST_CCP(ccp(160,20));


}


-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    if (touchOrigin2.x>ADJUST_X(20) && touchOrigin2.x<ADJUST_X(40) && touchOrigin2.y>ADJUST_Y(445) && touchOrigin2.y<ADJUST_Y(465))
    {
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        
        [director_ pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[MainMenu scene]]];

        
    }
    
    if (touchOrigin2.x>ADJUST_X(30) && touchOrigin2.x<ADJUST_X(290) && touchOrigin2.y>ADJUST_Y(160) && touchOrigin2.y<ADJUST_Y(235))
    {
        
    }
    if(touchOrigin2.x>ADJUST_X(260) && touchOrigin2.x<ADJUST_X(320) && touchOrigin2.y>ADJUST_Y(425) && touchOrigin2.y<ADJUST_Y(480))
    {
        //[self showMessage];
        
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

    
    for(LevelButton *obj in _buttonArray)
    {
        if([obj checkTouchAtPosition:touchOrigin2])
        {
       
            [obj ButtonPressed];
        }
    }
    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
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
              [self.currentSession release];
            currentSession = nil;
            
            break;
    }
}
- (void) session:(GKSession *)session didFailWithError:(NSError *)error
{
    
}

- (void) mySendDataToPeers:(NSData *) data
{
    if (currentSession)
        [self.currentSession sendDataToAllPeers:data
                                   withDataMode:GKSendDataReliable
                                          error:nil];
}

- (void)showMessage
{
    NSData* data;
    NSString *str = [NSString stringWithString:@"hellohello"];
    data = [str dataUsingEncoding: NSASCIIStringEncoding];
    [self mySendDataToPeers:data];
}
-(IBAction) btnSend:(id) sender
{
    //---convert an NSString object to NSData---
    NSData* data;
    //NSString *str = [NSString stringWithString:txtMessage.text];
    //data = [str dataUsingEncoding: NSASCIIStringEncoding];
    [self mySendDataToPeers:data];
}

- (void) receiveData:(NSData *)data
            fromPeer:(NSString *)peer
           inSession:(GKSession *)session
             context:(void *)context {
    //---convert the NSData to NSString---
    NSString* str;
    str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data received"
                                                    message:str
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)dealloc
{
    [super dealloc];
    [_buttonArray release];
      [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"ChooseLevelSprites.plist"];
     [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"MenuBackground.plist"];
}

@end
