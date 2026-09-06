//
//  HelloWorldLayer.m
//  Grid
//
//  Created by Yang Song on 4/12/12.
//  Copyright XecuDev 2012. All rights reserved.
//


// Import the interfaces
#import "GameLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "DeviceSettings.h"
#import "Edge.h"
#import "EdgeArray.h"
#import "Box.h"
#import "BoxArray.h"
#import "MapSettings.h"
#import "TreasureBox.h"
#import "Cannon.h"
#import "BoxIcon.h"
#import "Ship.h"
#import "Skull.h"
#import "Fog.h"
#import "TreasureMap.h"
#import "ChooseLevelMenu.h"
#import "GameSettings.h"
#import "GameoverWindow.h"
#import "SimpleAudioEngine.h"
#import "MainMenu.h"
#import "GCHelper.h"
#import "GCState.h"
#include <stdlib.h>
#define WAIT_TO_FADE_OUT_TREASUREBOX 2.0
#define WAIT_TO_FADE_OUT_CANNON 1.0
#define WAIT_TO_FADE_OUT_SHIP 2.0
#define WAIT_TO_FADE_OUT_MAP 1.0;

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation GameLayer
@synthesize CPUTurn=_CPUTurn;
@synthesize winOrLose=_winOrLose;
@synthesize twoPlayerOnOneDevice=_twoPlayerOnOneDevice;
@synthesize waitingAlert=_waitingAlert;
@synthesize CPUThinking=_CPUThinking;
@synthesize boxCount=_boxCount;
@synthesize isNewGame=_isNewGame;
@synthesize gridModel=_gridModel;
@synthesize gridView=_gridView;
@synthesize touchEnable=_touchEnable;
@synthesize currentSession;
@synthesize picker=_picker;
@synthesize gameMode=_gameMode;
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
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
		
		NSLog(@"pvp wins %d",[GCState sharedInstance].pvpSocre);
		// ask director the the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
      
	  _gameMode=[[GameSettings shared] getGlobalForKey:@"gameMode"];
      //  _receiveInvite=YES;
        if([_gameMode isEqualToString:@"solo"])
        {
                // [[GameSettings shared] saveToDisk];
            _twoPlayerOnOneDevice=NO;
        }
        
        else if ([_gameMode isEqualToString:@"oneDevice"])
        {
            _twoPlayerOnOneDevice=YES;
        }
        else if([_gameMode isEqualToString:@"blueTooth"])
        {
            _twoPlayerOnOneDevice=YES;
            
            [self setupBluetoothSession];
            
        }
        else if([_gameMode isEqualToString:@"network"])
        {
            _twoPlayerOnOneDevice=YES;
            [self setupNetworkSession];
            
        }
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spriteSheet.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"background.plist" ];
       [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Black50.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"GameOverSprite.plist" ];
              [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"howToPlaySprite.plist" ];

        // [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animation.plist"];
        
        _gridModel=[GridModel GridWithNumOfLines:NUM_OF_LINES NumberOfRows:NUM_OF_ROWS];
        _gridView=[GridView gridViewInController:self];
        //_gridView.parentController=self;
        //[self loadEdgeIndicator];
      
            
        
        [self addChild:_gridView];
        /*
        [self loadTreasureBoxAtRow:1 ItemIndex:3];
        [self loadTreasureBoxAtRow:3 ItemIndex:3];
        [self loadCannonAtRow:2 ItemIndex:4 Flip:NO];
        [self loadCannonAtRow:2 ItemIndex:2 Flip:YES];
        [self loadTreasureMapAtRow:0 ItemIndex:1 Part:TREASUREMAP_PART_ONE];
        [self loadTreasureMapAtRow:4 ItemIndex:5 Part:TREASUREMAP_PART_TWO];
        [self loadShipAtRow:0 ItemIndex:5 Flip:NO];
        [self loadShipAtRow:4 ItemIndex:1 Flip:YES];
         */
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        _changeColor=YES;
        _isBlueColor=NO;
        _touchEnable=YES;
        
        _CPUTurn=NO;
        _otherPlayerTurn=NO;
        _CPUThinking=NO;
        _isNewGame=YES;
       
      
  
        if(!_twoPlayerOnOneDevice)
        {
            _brain=[CPUBrain instance];
            _brain.grid=self;
        }
        [self schedule:@selector(update:)];
        
 
        
        [self newGame];
       [self updateBoxNumber];
         _gridModel.skullLeft=(int)_gridView.skullArray.count;
        NSString *leveNumber=[[GameSettings shared] getGlobalForKey:@"selectedLevel"];
        if(([leveNumber isEqualToString:@"1"]||[leveNumber isEqualToString:@"2"]||[leveNumber isEqualToString:@"3"]||[leveNumber isEqualToString:@"5"]||[leveNumber isEqualToString:@"8"]||[leveNumber isEqualToString:@"12"]||[leveNumber isEqualToString:@"17"]||[leveNumber isEqualToString:@"19"])&&[_gameMode isEqualToString:@"solo"])
        {
            _gridView.howToPlayPage=[HowToPlayPage HowToPlayPageInController:self];
            [_gridView addChild:_gridView.howToPlayPage];
            _gridView.howToPlayPage.waitToFadeInWindow=2.0;
        }
        
      // [_brain fillRandomEdge];
        
       
		/*
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentViewController:achivementViewController animated:YES completion:nil];
			
			[achivementViewController release];
		}
									   ];

		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentViewController:leaderboardViewController animated:YES completion:nil];
			
			[leaderboardViewController release];
		}
									   ];
		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];
         */

	}
	return self;
}
/*
- (void)loadEdgeIndicator
{
    _gridView.edgeIndicator =[CCSprite spriteWithSpriteFrameName:[self getEdgeColor]];
    [_gridView.edgeIndicator setVisible:NO]; 
    _gridView.edgeIndicator =[CCSprite spriteWithSpriteFrameName:[self getEdgeColor]];
    [_gridView.edgeIndicator setVisible:NO]; 
    [_gridView.edgeLayer addChild:_gridView.edgeIndicator];
    
 
}
*/

-(void)updateBoxNumber
{
    _boxCount=0;
    
    for(BoxArray *array in _gridModel.boxs)
    {
        for(Box *box in array)
        {
            if(box.status==EMPTY_BOX||box.status==MAP||box.status==CANNON||box.status==TREASUREBOX||box.status==SHIP||box.status==SKULL)
            {
                _boxCount++;
            }
        }
    }

}
-(void)setupBluetoothSession
{
    currentSession=[[GameSettings shared] getObjForKey:@"session"];
    currentSession.delegate=self;
    [currentSession setDataReceiveHandler:self withContext:nil];
}
-(void)setupNetworkSession
{
    myMatch=[[GameSettings shared] getObjForKey:@"GKMatch"];
    myMatch.delegate=self;
    //[currentSession setDataReceiveHandler:self withContext:nil];
    
}

#pragma mark Load power-ups


- (void)loadTreasureBoxRandom
{   /*
    _gridView.treasureBox1=[TreasureBox treasureBoxAtPosition:[self generatePositionForTreasureBox]];
    _gridView.treasureBox1.parentGridView=_gridView;
    [_gridView addChild:_gridView.treasureBox1];
    [_gridView.powerUpsArray addObject:_gridView.treasureBox1];
     */
    TreasureBox *box=[TreasureBox treasureBoxAtPosition:[self generatePositionForItem:TREASUREBOX]];
    box.parentGridView=_gridView;
    [_gridView addChild:box];
    [_gridView.treasureBoxArray addObject:box];
                      
}
-(void)loadCannonRandom
{
    /*
    _gridView.cannon1=[Cannon cannonAtPosition:[self generatePositionForCannon] Flip:NO];
    _gridView.cannon1.parentGridView=_gridView;
   // [_gridView.cannon1.cannonGraphic setFlipX:YES];
    //[_gridView.cannon1.cannonBallGraphic setFlipX:YES];
    [_gridView addChild:_gridView.cannon1];
     */
    Cannon *cannon=[Cannon cannonAtPosition:[self generatePositionForItem:CANNON] Flip:NO];
    cannon.parentGridView=_gridView;
    [_gridView addChild:cannon];
    [_gridView.cannonArray addObject:cannon];
}


- (void)loadTreasureBoxAtRow:(int)rowIndex ItemIndex:(int)edgeIndex
{  
    TreasureBox *box=[TreasureBox treasureBoxAtPosition:[self generatePositionForItem:TREASUREBOX AtRow:rowIndex ItemIndex:edgeIndex]];
    box.parentGridView=_gridView;
    [_gridView addChild:box];
    [_gridView.treasureBoxArray addObject:box];
    
}

- (void)loadSkullAtRow:(int)rowIndex ItemIndex:(int)edgeIndex
{  
    Skull *box=[Skull skullAtPosition:[self generatePositionForItem:SKULL AtRow:rowIndex ItemIndex:edgeIndex]];
    box.parentGridView=_gridView;
    [_gridView addChild:box];
    [_gridView.skullArray addObject:box];
    
}
- (void)loadFogAtRow:(int)rowIndex ItemIndex:(int)edgeIndex
{  
    //Fog *box=[Fog FogAtPosition:[self generatePositionForItem:SKULL AtRow:rowIndex ItemIndex:edgeIndex]];
    Fog *box=[Fog FogAtPosition:[self generatePositionForFogAtRow:rowIndex ItemIndex:edgeIndex]];

    box.parentGridView=_gridView;
    [_gridView addChild:box];
    [_gridView.fogArray addObject:box];
    
}

-(void)loadCannonAtRow:(int)rowIndex ItemIndex:(int)edgeIndex Flip:(BOOL)flipOrNot
{
   
    Cannon *cannon=[Cannon cannonAtPosition:[self generatePositionForItem:CANNON AtRow:rowIndex ItemIndex:edgeIndex] Flip:flipOrNot];
    cannon.parentGridView=_gridView;
    [_gridView addChild:cannon];
    [_gridView.cannonArray addObject:cannon];
}

-(void)loadShipAtRow:(int)rowIndex ItemIndex:(int)edgeIndex Flip:(BOOL)flipOrNot
{
    
    Ship *ship=[Ship shipAtPosition:[self generatePositionForItem:SHIP AtRow:rowIndex ItemIndex:edgeIndex ] Flip:flipOrNot];
    ship.parentGridView=_gridView;
    [_gridView addChild:ship];
    [_gridView.shipArray addObject:ship];
}
-(void)loadTreasureMapAtRow:(int)rowIndex ItemIndex:(int)edgeIndex Part:(TreasureMapNumber)number
{
    
    TreasureMap *map=[TreasureMap treasureMapAtPosition:[self generatePositionForItem:MAP AtRow:rowIndex ItemIndex:edgeIndex] andType:number ];
    map.parentGridView=_gridView;
    [_gridView addChild:map];
    [_gridView.mapArray addObject:map];
}

-(void)loadBoxPatternAtRow:(int)rowIndex ItemIndex:(int)edgeIndex
{
    CCSprite *pattern=[CCSprite spriteWithSpriteFrameName:@"Graphic_Bones.png"];
    [pattern setOpacity:76.5];
    [pattern setPosition:[self generatePositionForFogAtRow:rowIndex ItemIndex:edgeIndex]];
    [_gridView.blockLayer addChild: pattern];
}

#pragma mark Handle touch 
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    if(touchOrigin2.x>ADJUST_X(0) && touchOrigin2.x<ADJUST_X(50) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(470))
    {
        //if(_touchEnable||![_gameMode isEqualToString:@"solo"])
        //{
        [self newButtonPressed];
        //}
    }
   else if (touchOrigin2.x>ADJUST_X(50) && touchOrigin2.x<ADJUST_X(100) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(470))
   {
       //if(_touchEnable||![_gameMode isEqualToString:@"solo"])
       //{
       [self menuButtonPressed];
       //}
   }
   else if (touchOrigin2.x>ADJUST_X(220) && touchOrigin2.x<ADJUST_X(270) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(470))
   {
        [[SimpleAudioEngine sharedEngine] playEffect:@"menuForward.mp3"];
       _gridView.howToPlayPage=[HowToPlayPage HowToPlayWindowInController:self];
       [_gridView addChild:_gridView.howToPlayPage];
       //_gridView.howToPlayPage.waitToFadeInWindow=2.0;
   }
    else if (touchOrigin2.x>ADJUST_X(270) && touchOrigin2.x<ADJUST_X(320) && touchOrigin2.y>ADJUST_Y(415) && touchOrigin2.y<ADJUST_Y(480))
    {
        if(_gridView.isSoundOn)
        {
            [_gridView.soundButton setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_SoundOff.png"]];
            _gridView.isSoundOn=NO;
            [[SimpleAudioEngine sharedEngine] setMute:YES];
            [[GameSettings shared] setGlobal:@"NO" ForKey:@"isSoundOn"];
            
        }
        else
        {
            [_gridView.soundButton setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_SoundOn.png"]];
            _gridView.isSoundOn=YES;
             [[SimpleAudioEngine sharedEngine] setMute:NO];
            [[GameSettings shared] setGlobal:@"YES" ForKey:@"isSoundOn"];
        }
    }

    if(_touchEnable)
    {
  
    [_gridView.edgeIndicator setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[self getEdgeIndicatorColor]]];
        /*
        _CPUTurn=YES;
        if(self.isNewGame)
        {
            self.isNewGame=NO;
        }
        [self checkTouchOnEdgeAndDrawAtPosition:touchOrigin2];
        */
   // [self showEdgeIndicatorAtPosition:touchOrigin2];
     [self checkTouchOnEdgeAtPosition:touchOrigin2];    
        }
    
    
    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if(_touchEnable)
    {
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
  // [self showEdgeIndicatorAtPosition:touchOrigin2];
        [self checkTouchOnEdgeAtPosition:touchOrigin2];
    }
     
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
   
    if(_touchEnable)
    {
   // CGPoint touchOrigin = [touch locationInView:[touch view]];
	//CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
   
    [_gridView.edgeIndicator setVisible:NO];
    _CPUTurn=YES;
        _otherPlayerTurn=YES;
    if(self.isNewGame)
    {
        self.isNewGame=NO;
    }
    [self checkTouchOnEdgeAndDrawAtPosition:_drawPosition];
    }
    
    
}

-(int)modulo:(CGFloat)point

{
    
    int gridPosition=(int)point% EDGE_LENGTH;
    
    return gridPosition; 
    
}


-(void)drawEdgeAtRowIndex:(NSInteger)rowIndex EdgeIndex:(NSInteger)edgeIndex
{
   // NSLog(@"edge touched at row %d, number %d, an edge is drew",rowIndex,edgeIndex);
    
  
    
    Edge *edge= [_gridModel getEdgeAtRowIndex:rowIndex EdgeIndex:edgeIndex];
    if(![edge checkFiled])
    {
        
        edge.isFilled=YES;
        [_gridView.lastEdge setVisible:NO];
        [_gridView.lastEdge setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[self getEdgeIndicatorColor]]];
        
        NSString *lineColor=[self getEdgeColor];
        CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN;
        CGFloat pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN; //old
        
        [_gridView drawEdgeAtPosition:ccp(pointX,pointY) AndColor:lineColor Vertical:NO];
       
        _changeColor=YES;
        
     
        [self checkIfSquareExistForEdgeOnARowAtIndex:rowIndex EdgeIndex:edgeIndex];
        
        /*
        if(!_twoPlayerOnOneDevice &&_CPUTurn)
        {
           // [_brain move:self];
            _touchEnable=NO;
            [_brain move];
        }
        */ 
        
    }

}

-(void)drawEdgeAtLineIndex:(NSInteger)lineIndex EdgeIndex:(NSInteger)edgeIndex
{ 
    //NSLog(@"edge touched at line %d, number %d, an edge is drew",lineIndex,edgeIndex);
    Edge *edge= [_gridModel getEdgeAtLineIndex:lineIndex EdgeIndex:edgeIndex];
   
    if(![edge checkFiled])
    {
        
        edge.isFilled=YES;
         [_gridView.lastEdge setVisible:NO];
        [_gridView.lastEdge setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[self getEdgeIndicatorColor]]];
        
        NSString *lineColor=[self getEdgeColor];
        CGFloat pointX= edgeIndex * EDGE_LENGTH + X_MARGIN;
        CGFloat pointY=0.5*EDGE_LENGTH+lineIndex*EDGE_LENGTH+Y_MARGIN;
       
        [_gridView drawEdgeAtPosition:ccp(pointX,pointY) AndColor:lineColor Vertical:YES];
        
        _changeColor=YES;
        
      
        [self checkIfSquareExistForEdgeOnALineAtIndex:lineIndex EdgeIndex:edgeIndex];
        
        /*
        if(!_twoPlayerOnOneDevice &&_CPUTurn)
        {
             //[_brain move:self];
            _touchEnable=NO;
            [_brain move];
        }
         
        */
    }

}

-(void)drawEdgeIndicatorAtRowIndex:(NSInteger)rowIndex EdgeIndex:(NSInteger)edgeIndex
{
    //NSLog(@"edge touched at row %d, number %d, an edge is drew",rowIndex,edgeIndex);
    Edge *edge= [_gridModel getEdgeAtRowIndex:rowIndex EdgeIndex:edgeIndex];
    if(![edge checkFiled])
    {
        
        CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN;
        CGFloat pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN; //old
        [_gridView drawEdgeIndicatorAtPosition:ccp(pointX,pointY) Vertical:NO];
    }

}

-(void)drawEdgeIndicatorAtLineIndex:(NSInteger)lineIndex EdgeIndex:(NSInteger)edgeIndex
{
    //NSLog(@"edge touched at line %d, number %d, an edge is drew",lineIndex,edgeIndex);
    Edge *edge= [_gridModel getEdgeAtRowIndex:lineIndex EdgeIndex:edgeIndex];
    if(![edge checkFiled])
    {
        
        CGFloat pointX= edgeIndex * EDGE_LENGTH + X_MARGIN;
        CGFloat pointY=0.5*EDGE_LENGTH+lineIndex*EDGE_LENGTH+Y_MARGIN;
        [_gridView drawEdgeIndicatorAtPosition:ccp(pointX,pointY) Vertical:YES];
    }

}


- (void)checkTouchOnEdgeAtPosition:(CGPoint)point
{
    //NSLog(@"touch point:%f %f",point.x, point.y);
    
    
    if(point.y < Y_BOUNDARY_TOP &&point.y> Y_BOUNDARY_BOTTOM &&point.x > X_BOUNDARY_LEFT &&point.x < X_BOUNDARY_RIGHT)
    {
        
        if((EDGE_LENGTH * PORTION_MIN < [self modulo:(point.x - X_MARGIN)]&& [self modulo:(point.x - X_MARGIN)] <EDGE_LENGTH * PORTION_MAX) &&([self modulo:(point.y - Y_MARGIN)] >PORTION_MAX * EDGE_LENGTH || [self modulo:(point.y - Y_MARGIN)] < PORTION_MIN * EDGE_LENGTH))
        {
            //edge on a row
            _drawPosition=point;
        }
        
        else if((EDGE_LENGTH * PORTION_MIN < [self modulo:(point.y - Y_MARGIN)] && [self modulo:(point.y - Y_MARGIN)] <EDGE_LENGTH * PORTION_MAX) &&([self modulo:(point.x - X_MARGIN )] >PORTION_MAX * EDGE_LENGTH ||[self modulo:(point.x - X_MARGIN)] < PORTION_MIN * EDGE_LENGTH))
        {
        
            //edge on a line
            _drawPosition=point;
                    }
        
        else {
            //[_lable setString:[NSString stringWithFormat:@"No a touch on edge"]];
            
            
        }
    }

}

- (void)checkTouchOnEdgeAndDrawAtPosition:(CGPoint)point
{
   // NSLog(@"touch point:%f %f",point.x, point.y);
    
    
    if(point.y < Y_BOUNDARY_TOP &&point.y> Y_BOUNDARY_BOTTOM &&point.x > X_BOUNDARY_LEFT &&point.x < X_BOUNDARY_RIGHT)
    {
        
        if((EDGE_LENGTH * PORTION_MIN < [self modulo:(point.x - X_MARGIN)]&& [self modulo:(point.x - X_MARGIN)] <EDGE_LENGTH * PORTION_MAX) &&([self modulo:(point.y - Y_MARGIN)] >PORTION_MAX * EDGE_LENGTH || [self modulo:(point.y - Y_MARGIN)] < PORTION_MIN * EDGE_LENGTH))
        {
            //edge on a row
            NSUInteger rowIndex= (NSUInteger)((point.x - X_MARGIN)/EDGE_LENGTH);
            NSUInteger edgeIndex=(NSUInteger)((point.y - Y_MARGIN)/EDGE_LENGTH);
            
            if(rowIndex>4)
            {
                //rowIndex=5;
                return;
            }
            
            if(edgeIndex>5)
            {
                //edgeIndex=6;
                return;
            }
            if([self modulo:(point.y - Y_MARGIN)] >PORTION_MAX * EDGE_LENGTH)
            {
                [self drawEdgeAtRowIndex:rowIndex EdgeIndex:(edgeIndex+1)];
                                
                
            }
            else if([self modulo:(point.y - Y_MARGIN)] < PORTION_MIN * EDGE_LENGTH)
            {
               [self drawEdgeAtRowIndex:rowIndex EdgeIndex:edgeIndex];
            }
            
        }
        
        else if((EDGE_LENGTH * PORTION_MIN < [self modulo:(point.y - Y_MARGIN)] && [self modulo:(point.y - Y_MARGIN)] <EDGE_LENGTH * PORTION_MAX) &&([self modulo:(point.x - X_MARGIN )] >PORTION_MAX * EDGE_LENGTH ||[self modulo:(point.x - X_MARGIN)] < PORTION_MIN * EDGE_LENGTH))
        {
            //edge on a line
            NSUInteger edgeIndex= (NSUInteger)((point.x - X_MARGIN)/EDGE_LENGTH);
            NSUInteger lineIndex=(NSUInteger)((point.y - Y_MARGIN)/EDGE_LENGTH);
            
            
            if(lineIndex>4)
            {
                //lineIndex=5;
                return;
            }
            
            if(edgeIndex>5)
            {
                //edgeIndex=6;
                return;
            }
            
            if([self modulo:(point.x - X_MARGIN )] >PORTION_MAX * EDGE_LENGTH)
            {
                [self drawEdgeAtLineIndex:lineIndex EdgeIndex:(edgeIndex+1)];                
            }
            else if([self modulo:(point.x - X_MARGIN)] < PORTION_MIN * EDGE_LENGTH)
            {
                [self drawEdgeAtLineIndex:lineIndex EdgeIndex:edgeIndex]; 
            }
        }
        
        else {
            //[_lable setString:[NSString stringWithFormat:@"No a touch on edge"]];
            
            
        }
    }
    
}


-(void)showEdgeIndicatorAtPosition:(CGPoint)point
{
   // NSLog(@"touch point:%f %f",point.x, point.y);
    
    
    if(point.y < Y_BOUNDARY_TOP &&point.y> Y_BOUNDARY_BOTTOM &&point.x > X_BOUNDARY_LEFT &&point.x < X_BOUNDARY_RIGHT)
    {
        
        if((EDGE_LENGTH * PORTION_MIN < [self modulo:(point.x - X_MARGIN)]&& [self modulo:(point.x - X_MARGIN)] <EDGE_LENGTH * PORTION_MAX) &&([self modulo:(point.y - Y_MARGIN)] >PORTION_MAX * EDGE_LENGTH || [self modulo:(point.y - Y_MARGIN)] < PORTION_MIN * EDGE_LENGTH))
        {
            //edge on a row
            NSUInteger rowIndex= (NSUInteger)((point.x - X_MARGIN)/EDGE_LENGTH);
            NSUInteger edgeIndex=(NSUInteger)((point.y - Y_MARGIN)/EDGE_LENGTH);
            
            if(rowIndex>4)
            {
                //rowIndex=5;
                return;
            }
            
            if(edgeIndex>5)
            {
                //edgeIndex=6;
                return;
            }
            if([self modulo:(point.y - Y_MARGIN)] >PORTION_MAX * EDGE_LENGTH)
            {
                [self drawEdgeIndicatorAtRowIndex:rowIndex EdgeIndex:(edgeIndex+1)];
            }
            else if([self modulo:(point.y - Y_MARGIN)] < PORTION_MIN * EDGE_LENGTH)
            {
                [self drawEdgeIndicatorAtRowIndex:rowIndex EdgeIndex:edgeIndex];                
            }
            
        }
        
        else if((EDGE_LENGTH * PORTION_MIN < [self modulo:(point.y - Y_MARGIN)] && [self modulo:(point.y - Y_MARGIN)] <EDGE_LENGTH * PORTION_MAX) &&([self modulo:(point.x - X_MARGIN )] >PORTION_MAX * EDGE_LENGTH ||[self modulo:(point.x - X_MARGIN)] < PORTION_MIN * EDGE_LENGTH))
        {
            //edge on a line
            NSUInteger edgeIndex= (NSUInteger)((point.x - X_MARGIN)/EDGE_LENGTH);
            NSUInteger lineIndex=(NSUInteger)((point.y - Y_MARGIN)/EDGE_LENGTH);
            
            
            if(lineIndex>4)
            {
                //lineIndex=5;
                return;
            }
            
            if(edgeIndex>5)
            {
                //edgeIndex=6;
                return;
            }
            
            if([self modulo:(point.x - X_MARGIN )] >PORTION_MAX * EDGE_LENGTH)
            {
                [self drawEdgeIndicatorAtLineIndex:lineIndex EdgeIndex:(edgeIndex+1)];
            }
            else if([self modulo:(point.x - X_MARGIN)] < PORTION_MIN * EDGE_LENGTH)
            {
                [self drawEdgeIndicatorAtLineIndex:lineIndex EdgeIndex:edgeIndex];                
            }
        }
        
        else {
            //[_lable setString:[NSString stringWithFormat:@"No a touch on edge"]];
        }
    }
    
}


-(NSString *)getEdgeIndicatorColor
{
    if(_changeColor)
    {
        if(!_isBlueColor)
        {    //_isBlueColor=YES;
            return [NSString stringWithFormat:@"Graphic_BlueLine.png"];
            
        }
        else {
            //_isBlueColor=NO;
            return [NSString stringWithFormat:@"Graphic_OrangeLine.png"];
            
        }
    }
    
    else {
        if(_isBlueColor)
        {
            //_isBlueColor=YES;
            return [NSString stringWithFormat:@"Graphic_BlueLine.png"];
            
        }
        else {
            //_isBlueColor=NO;
            return [NSString stringWithFormat:@"Graphic_OrangeLine.png"];
            
        }
    }
    
}

-(NSString *)getEdgeColor
{
    if(_changeColor)
    {
        if(!_isBlueColor)
        {    _isBlueColor=YES;
            //return [NSString stringWithFormat:@"Graphic_BlueLine.png"];
            [[SimpleAudioEngine sharedEngine] playEffect:@"player1turn.wav"];
            return [NSString stringWithFormat:@"Graphic_GreenLine.png"];
            
        }
        else {
            _isBlueColor=NO;
            //return [NSString stringWithFormat:@"Graphic_OrangeLine.png"];
             [[SimpleAudioEngine sharedEngine] playEffect:@"player2turn.wav"];
            return [NSString stringWithFormat:@"Graphic_GreenLine.png"];
            
        }
    }
    
    else {
        if(_isBlueColor)
        {
            _isBlueColor=YES;
            //return [NSString stringWithFormat:@"Graphic_BlueLine.png"];
             [[SimpleAudioEngine sharedEngine] playEffect:@"player1turn.wav"];
            return [NSString stringWithFormat:@"Graphic_GreenLine.png"];
            
        }
        else {
            _isBlueColor=NO;
            // return [NSString stringWithFormat:@"Graphic_OrangeLine.png"];
             [[SimpleAudioEngine sharedEngine] playEffect:@"player2turn.wav"];
            return [NSString stringWithFormat:@"Graphic_GreenLine.png"];
            
        }
    }
}

-(NSString *)getInitialEdgeColor
{
    if(_changeColor)
    {
        if(!_isBlueColor)
        {    _isBlueColor=YES;
            //return [NSString stringWithFormat:@"Graphic_BlueLine.png"];
            //[[SimpleAudioEngine sharedEngine] playEffect:@"player1turn.wav"];
            return [NSString stringWithFormat:@"Graphic_GreenLine.png"];
            
        }
        else {
            _isBlueColor=NO;
            //return [NSString stringWithFormat:@"Graphic_OrangeLine.png"];
            //[[SimpleAudioEngine sharedEngine] playEffect:@"player2turn.wav"];
            return [NSString stringWithFormat:@"Graphic_GreenLine.png"];
            
        }
    }
    
    else {
        if(_isBlueColor)
        {
            _isBlueColor=YES;
            //return [NSString stringWithFormat:@"Graphic_BlueLine.png"];
            //[[SimpleAudioEngine sharedEngine] playEffect:@"player1turn.wav"];
            return [NSString stringWithFormat:@"Graphic_GreenLine.png"];
            
        }
        else {
            _isBlueColor=NO;
            // return [NSString stringWithFormat:@"Graphic_OrangeLine.png"];
            //[[SimpleAudioEngine sharedEngine] playEffect:@"player2turn.wav"];
            return [NSString stringWithFormat:@"Graphic_GreenLine.png"];
            
        }
    }
}


-(void)newButtonPressed
{
   // NSLog(@"newButton Pressed");
    NSString *isHost=[[GameSettings shared] getGlobalForKey:@"isHost"];
    if([isHost isEqualToString:@"NO"]&&[_gameMode isEqualToString:@"network"])
    {
        return;
    }
    CCAnimation *buttonAnimation=[CCAnimation animation];
    [buttonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_NewGame.png"]];
    [buttonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_NewGame_Pressed.png" ]];
     [[SimpleAudioEngine sharedEngine] playEffect:@"menuForward.mp3"];
   // id buttonAnimationAction=[CCAnimate actionWithDuration:0.1 animation:buttonAnimation restoreOriginalFrame:YES];
    buttonAnimation.restoreOriginalFrame=YES;
    buttonAnimation.delayPerUnit=0.1/buttonAnimation.frames.count;
        [_gridView.theNewGameButton runAction:[[[CCAnimate alloc] initWithAnimation:buttonAnimation] autorelease]];
    _drawPosition=ccp(0,0);
    if([_gameMode isEqualToString:@"blueTooth"])
    {
    //[self.currentSession release];
   /*
        currentSession = nil;
    
    AlertView *alert = [[AlertView alloc] initWithTitle:@""
                                                    message:@"connection lost"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Okay",nil];
    [alert show];
    [alert release];
    
    [[GameSettings shared] setGlobal:@"oneDevice" ForKey:@"gameMode"];
    _gameMode=@"oneDevice";
    */
        
        [self showMessage:[[GameSettings shared] getGlobalForKey:@"selectedLevel"]];
        self.waitingAlert = [[AlertView alloc] initWithTitle:@""
                                                                    message:@"waiting for response...."
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"Cancel",nil];
        self.waitingAlert.tag=2;
        [self.waitingAlert show];
        [self.waitingAlert release];

    }
    else if([_gameMode isEqualToString:@"network"]) {
        [self networkShowMessage:[[GameSettings shared] getGlobalForKey:@"selectedLevel"]];
        self.waitingAlert = [[AlertView alloc] initWithTitle:@""
                                                       message:@"waiting for response...."
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"Cancel",nil];
         self.waitingAlert.tag=2;
        [self.waitingAlert show];
        [self.waitingAlert release];
        
    }
    [self newGame];

}

-(void)menuButtonPressed
{
    //NSLog(@"menuButton Pressed");
   
    
    CCAnimation *buttonAnimation=[CCAnimation animation];
    [buttonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_Menu.png"]];
    [buttonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_Menu_Pressed.png" ]];
    //id buttonAnimationAction=[CCAnimate actionWithDuration:0.1 animation:buttonAnimation restoreOriginalFrame:YES];
    buttonAnimation.restoreOriginalFrame=YES;
    buttonAnimation.delayPerUnit=0.1/buttonAnimation.frames.count;
    [_gridView.menuButton runAction:[[[CCAnimate alloc] initWithAnimation:buttonAnimation] autorelease]];
    _drawPosition=ccp(0,0);
    
     [[SimpleAudioEngine sharedEngine] playEffect:@"menuBack.wav"];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"MenuMusic.mp3"];
    
    
    CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
    [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseLevelMenu scene]]]; 
     
    
    
    
    /*
    _picker = [[PeerPickerController alloc] init];
    _picker.delegate = self;
    
    [_picker show];
     */
}


#pragma mark Check Square Existence

-(void)checkIfSquareExistForEdgeOnARowAtIndex:(NSUInteger)rowIndex 
                                    EdgeIndex:(NSUInteger)edgeIndex
{
    Edge *top=[_gridModel getEdgeAtRowIndex:rowIndex EdgeIndex:(edgeIndex+1)];
    Edge *topLeft=[_gridModel getEdgeAtLineIndex:edgeIndex EdgeIndex:rowIndex];
    Edge *topRight=[_gridModel getEdgeAtLineIndex:edgeIndex EdgeIndex:(rowIndex+1)];
    
    Edge *bottom=[_gridModel getEdgeAtRowIndex:rowIndex EdgeIndex:(edgeIndex-1)];
    Edge *bottomLeft=[_gridModel getEdgeAtLineIndex:(edgeIndex-1) EdgeIndex:rowIndex];
    Edge *bottomRight=[_gridModel getEdgeAtLineIndex:(edgeIndex-1) EdgeIndex:(rowIndex+1)];
    
   // BOOL aboveFilled=NO;
    if(top.isFilled && topLeft.isFilled && topRight.isFilled)
    {
       
        
       // _CPUTurn=NO;
        //square above is filled
        CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN+0.5*EDGE_LENGTH;
        CGFloat pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;
        
        
        int blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        int blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        
      Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
        
      
         // NSLog(@"Checkbox lineIndex:%d boxIndex:%d",blockLineIndex,blockBoxIndex);
        //NSLog(@"box status %d",box.status);
        if(box.status==EMPTY_BOX||box.status==TREASUREBOX||box.status==CANNON||box.status==SHIP||box.status==MAP||box.status==SKULL)
        {
            //_changeColor=NO;
            //_CPUTurn=NO;
            
        if(_isBlueColor)
        {
            _changeColor=NO;
            _otherPlayerTurn=NO;
            _CPUTurn=NO;
            CGPoint point=ccp(pointX,pointY);
            /*
            if([self checkIfThereIsATreasureBox:point])
            {
                 box.status=BLUE;
                [self blueOpenedTreasureBox:point];
            }
            else if([self checkIfThereIsACannon:point])
            {
               // NSLog(@"shootCannon");
                 box.status=BLUE;
                [self blueCannonBallShoot:point];

            }
             */
            //BoxInfo status= [self checkPowerUps:point];
            
            if(box.status==TREASUREBOX)
            {
                box.status=BLUE;
                [self blueOpenedTreasureBox:point];
            }
            else if (box.status==CANNON)
            {
                box.status=BLUE;
                [self blueCannonBallShoot:point];

            }
            else if (box.status==SHIP){
                box.status=BLUE;
                [self blueShipMoving:point];
            }
            else if (box.status==MAP){
                box.status=BLUE;
                [self blueFoundTreasureMap:point];
            }
            else if (box.status==SKULL) {
                box.status=BLUE;
                [self blueOpenedSkull:point];
            }
                
            else
            {
                 box.status=BLUE;
            [_gridView fillBlockAtPositionX:pointX PositionY:pointY WithColor:BLUE_BOX];
                           _gridModel.blueScore++;
             [_gridView.blueScoreBox changeScore:1];
            }
            
        }
        else {
            _changeColor=NO;
            _otherPlayerTurn=NO;
            CGPoint point=ccp(pointX,pointY);
            /*
            if([self checkIfThereIsATreasureBox:point])
            {
                 box.status=ORANGE;
                [self orangeOpenedTresureBox:point];
            }
            
            else if([self checkIfThereIsACannon:point])
            {
                //NSLog(@"shootCannon");
                 box.status=ORANGE;
                [self orangeCannonBallShoot:point];
            }
            
          //  [_gridView orangeBlockAtPositionX:pointX PositionY:pointY];
             */
            if(box.status==TREASUREBOX)
            {
                box.status=ORANGE;
                [self orangeOpenedTresureBox:point];
            }
            else if (box.status==CANNON)
            {
                box.status=ORANGE;
                [self orangeCannonBallShoot:point];
                
            }
            else if (box.status==SHIP){
                box.status=ORANGE;
                [self orangeShipMoving:point];
            }
            else if (box.status==MAP){
                box.status=ORANGE;
                [self orangeFoundTreasureMap:point];
            }
            else if (box.status==SKULL) {
                box.status=ORANGE;
                [self orangeOpenedSkull:point];
            }
            
            else
            {
                 box.status=ORANGE;
             [_gridView fillBlockAtPositionX:pointX PositionY:pointY WithColor:ORANGE_BOX];
               
            _gridModel.orangeScore++;
             [_gridView.orangeScoreBox changeScore:1];
            }
           
        }
        }
        // [_lable setString:[NSString stringWithFormat:@"Square Above"]];
        
        //[self checkWinner];
    }
    
    if(bottom.isFilled && bottomLeft.isFilled && bottomRight.isFilled)
    {
       
        //_CPUTurn=NO;
        //square underneath is filled
        CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN-0.5*EDGE_LENGTH;
        CGFloat pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;
        
        int blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        int blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        
        Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
         // NSLog(@"Checkbox lineIndex:%d boxIndex:%d",blockLineIndex,blockBoxIndex);
          // NSLog(@"box status %d",box.status);
        if(box.status==EMPTY_BOX||box.status==TREASUREBOX||box.status==CANNON||box.status==SHIP||box.status==MAP||box.status==SKULL)
        {
           
        if(_isBlueColor)
        {
            _CPUTurn=NO;
            _otherPlayerTurn=NO;
             _changeColor=NO;
            CGPoint point=ccp(pointX,pointY);
            /*
            if([self checkIfThereIsATreasureBox:point])
            {
               box.status=BLUE;
                
                [self blueOpenedTreasureBox:point];
            }
            else if([self checkIfThereIsACannon:point])
            {
               // NSLog(@"shootCannon");
                box.status=BLUE;
                [self blueCannonBallShoot:point];
            }
             */
            
            if(box.status==TREASUREBOX)
            {
                box.status=BLUE;
                [self blueOpenedTreasureBox:point];
            }
            else if (box.status==CANNON)
            {
                box.status=BLUE;
                [self blueCannonBallShoot:point];
                
            }
            else if (box.status==SHIP){
                box.status=BLUE;
                [self blueShipMoving:point];
            }
            else if (box.status==MAP){
                box.status=BLUE;
                [self blueFoundTreasureMap:point];
            }
            else if (box.status==SKULL) {
                box.status=BLUE;
                [self blueOpenedSkull:point];
            }
            else
            {
                box.status=BLUE;
           // if(!aboveFilled)
          //  {
            //[_gridView blueBlockAtPositionX:pointX PositionY:pointY];
                 [_gridView fillBlockAtPositionX:pointX PositionY:pointY WithColor:BLUE_BOX];
           // }
           // else {
                
            //    _gridView.secondBoxPositionX=pointX;
             //   _gridView.secondBoxPositionY=pointY;
             //   _gridView.waitToShowSecondBoxBlue=0.5;
           // }
             _gridModel.blueScore++;
             [_gridView.blueScoreBox changeScore:1];
            }
             
        }
        else {
              _changeColor=NO;
            _otherPlayerTurn=NO;
            CGPoint point=ccp(pointX,pointY);
            /*
            if([self checkIfThereIsATreasureBox:point])
            {
                box.status=ORANGE;
                [self orangeOpenedTresureBox:point];
            }
            else if([self checkIfThereIsACannon:point])
            {
               // NSLog(@"shootCannon");
                box.status=ORANGE;
                [self orangeCannonBallShoot:point];
            }
             */
            if(box.status==TREASUREBOX)
            {
                box.status=ORANGE;
                [self orangeOpenedTresureBox:point];
            }
            else if (box.status==CANNON)
            {
                box.status=ORANGE;
                [self orangeCannonBallShoot:point];
                
            }
            else if (box.status==SHIP){
                box.status=ORANGE;
                [self orangeShipMoving:point];
            }
            else if (box.status==MAP){
                box.status=ORANGE;
                [self orangeFoundTreasureMap:point];
            }
            else if (box.status==SKULL) {
                box.status=ORANGE;
                [self orangeOpenedSkull:point];
            }
            
            else
            {
                box.status=ORANGE;
           // if(!aboveFilled)
           // {
           // [_gridView orangeBlockAtPositionX:pointX PositionY:pointY];
                [_gridView fillBlockAtPositionX:pointX PositionY:pointY WithColor:ORANGE_BOX];
           // }
           // else {
           //     _gridView.secondBoxPositionX=pointX;
           //     _gridView.secondBoxPositionY=pointY;
           //     _gridView.waitToShowSecondBoxOrange=0.5;
           // }
             _gridModel.orangeScore++;
             [_gridView.orangeScoreBox changeScore:1];
            }
            
        }
        }
        
        //  [_lable setString:[NSString stringWithFormat:@"Square Below"]];
        
        //[self checkWinner];
    }
    
    if(!_twoPlayerOnOneDevice &&_CPUTurn&&!_CPUThinking)
    {
        // [_brain move:self];
        _touchEnable=NO;
        [_brain move];
    }
  
    if(_twoPlayerOnOneDevice && [_gameMode isEqualToString:@"blueTooth"]&&_otherPlayerTurn&&!_isReceiving )
    {
        _touchEnable=NO;
        //send the move to other player and wait for their move
        [self sendMoveToTheOtherPlayer:@"row" RowOrLineIndex:rowIndex EdgeIndex:edgeIndex switchTurn:@"YES"];
    }
    
    else if(_twoPlayerOnOneDevice && [_gameMode isEqualToString:@"blueTooth"]&&!_otherPlayerTurn&&!_isReceiving)
    {
        //send the move to other player
        [self sendMoveToTheOtherPlayer:@"row" RowOrLineIndex:rowIndex EdgeIndex:edgeIndex switchTurn:@"NO"];
    }
    
    if(_twoPlayerOnOneDevice && [_gameMode isEqualToString:@"network"]&&_otherPlayerTurn&&!_isReceiving )
    {
        _touchEnable=NO;
        //send the move to other player and wait for their move
        [self networkSendMoveToTheOtherPlayer:@"row" RowOrLineIndex:rowIndex EdgeIndex:edgeIndex switchTurn:@"YES"];
    }
    
    else if(_twoPlayerOnOneDevice && [_gameMode isEqualToString:@"network"]&&!_otherPlayerTurn&&!_isReceiving)
    {
        //send the move to other player
        [self networkSendMoveToTheOtherPlayer:@"row" RowOrLineIndex:rowIndex EdgeIndex:edgeIndex switchTurn:@"NO"];
    }
    
    [self showPlayerTurnInfo];
    
}

-(void)checkIfSquareExistForEdgeOnALineAtIndex:(NSUInteger)lineIndex EdgeIndex:(NSUInteger)edgeIndex
{
    NSUInteger M=lineIndex+1-edgeIndex;
    Edge *left=[_gridModel getEdgeAtLineIndex:lineIndex EdgeIndex:(edgeIndex-1)];
    Edge *topLeft=[_gridModel getEdgeAtRowIndex:(lineIndex-M) EdgeIndex:(edgeIndex+M)];
    Edge *bottomLeft=[_gridModel getEdgeAtRowIndex:(lineIndex-M) EdgeIndex:(edgeIndex+M-1)];
    
    Edge *right=[_gridModel getEdgeAtLineIndex:lineIndex EdgeIndex:(edgeIndex+1)];
    Edge *topRight=[_gridModel getEdgeAtRowIndex:(lineIndex+1-M) EdgeIndex:(edgeIndex+M)];
    Edge *bottomRight=[_gridModel getEdgeAtRowIndex:(lineIndex+1-M) EdgeIndex:(edgeIndex+M-1)];
    
    //BOOL LeftFilled=NO;
    if(left.isFilled && topLeft.isFilled && bottomLeft.isFilled)
    {
        
        //_CPUTurn=NO;
      //  LeftFilled=YES;
        //square left is filled
        CGFloat pointX=edgeIndex * EDGE_LENGTH + X_MARGIN - 0.5 * EDGE_LENGTH;
        CGFloat pointY=lineIndex * EDGE_LENGTH + Y_MARGIN + 0.5 * EDGE_LENGTH;
        
        int blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        int blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        
        Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
         // NSLog(@"Checkbox lineIndex:%d boxIndex:%d",blockLineIndex,blockBoxIndex);
          // NSLog(@"box status %d",box.status);
        if(box.status==EMPTY_BOX||box.status==TREASUREBOX||box.status==CANNON||box.status==SHIP||box.status==MAP||box.status==SKULL)
        {
            //_changeColor=NO;
            //_CPUTurn=NO;
        if(_isBlueColor)
        {
            _CPUTurn=NO;
            _otherPlayerTurn=NO;
            _changeColor=NO;
            CGPoint point=ccp(pointX,pointY);
            /*
            if([self checkIfThereIsATreasureBox:point])
            {
                box.status=BLUE;

                [self blueOpenedTreasureBox:point];
                
            }
            else if([self checkIfThereIsACannon:point])
            {
                //NSLog(@"shootCannon");
                box.status=BLUE;

                [self blueCannonBallShoot:point];
            
            }
             */
            if(box.status==TREASUREBOX)
            {
                box.status=BLUE;
                [self blueOpenedTreasureBox:point];
            }
            else if (box.status==CANNON)
            {
                box.status=BLUE;
                [self blueCannonBallShoot:point];
                
            }
            else if (box.status==SHIP){
                box.status=BLUE;
                [self blueShipMoving:point];
            }
            else if (box.status==MAP){
                box.status=BLUE;
                [self blueFoundTreasureMap:point];
            }
            else if (box.status==SKULL) {
                box.status=BLUE;
                [self blueOpenedSkull:point];
            }
            
            else {
                box.status=BLUE;

           // [_gridView blueBlockAtPositionX:pointX PositionY:pointY];
             [_gridView fillBlockAtPositionX:pointX PositionY:pointY WithColor:BLUE_BOX];
               
            _gridModel.blueScore++;
            [_gridView.blueScoreBox changeScore:1];
            }
                     }
        else {
            _changeColor=NO;
            _otherPlayerTurn=NO;
            CGPoint point=ccp(pointX,pointY);
            /*
            if([self checkIfThereIsATreasureBox:point])
            {
                 box.status=ORANGE;
                [self orangeOpenedTresureBox:point];   
            }
            else if([self checkIfThereIsACannon:point])
            {
               // NSLog(@"shootCannon");
                 box.status=ORANGE;
                [self orangeCannonBallShoot:point];
            }
            */
            //[_gridView orangeBlockAtPositionX:pointX PositionY:pointY];
            if(box.status==TREASUREBOX)
            {
                box.status=ORANGE;
                [self orangeOpenedTresureBox:point];
            }
            else if (box.status==CANNON)
            {
                box.status=ORANGE;
                [self orangeCannonBallShoot:point];
                
            }
            else if (box.status==SHIP){
                box.status=ORANGE;
                [self orangeShipMoving:point];
            }
            else if (box.status==MAP){
                box.status=ORANGE;
                [self orangeFoundTreasureMap:point];
            }
            else if (box.status==SKULL) {
                box.status=ORANGE;
                [self orangeOpenedSkull:point];
            }
            
            else
            {
                 box.status=ORANGE;
            [_gridView fillBlockAtPositionX:pointX PositionY:pointY WithColor:ORANGE_BOX];
               
             _gridModel.orangeScore++;
            [_gridView.orangeScoreBox changeScore:1];
            }
            
        }
        }
        // [_lable setString:[NSString stringWithFormat:@"Square Left"]];
       
        // [self checkWinner];
    }
    
    if(right.isFilled && topRight.isFilled && bottomRight.isFilled)
    {
        
        //_CPUTurn=NO;
        //square right is filled
        CGFloat pointX=edgeIndex * EDGE_LENGTH + X_MARGIN + 0.5 * EDGE_LENGTH;
        CGFloat pointY=lineIndex * EDGE_LENGTH + Y_MARGIN + 0.5 * EDGE_LENGTH;
        
        int blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        int blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        
        Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
         // NSLog(@"Checkbox lineIndex:%d boxIndex:%d",blockLineIndex,blockBoxIndex);
          // NSLog(@"box status %d",box.status);
        if(box.status==EMPTY_BOX||box.status==TREASUREBOX||box.status==CANNON||box.status==SHIP||box.status==MAP||box.status==SKULL)
        {
            //_changeColor=NO;
            //_CPUTurn=NO;
        if(_isBlueColor)
        {
            _changeColor=NO;
            _CPUTurn=NO;
            _otherPlayerTurn=NO;
            CGPoint point=ccp(pointX,pointY);
            /*
            if([self checkIfThereIsATreasureBox:point])
            {
                 box.status=BLUE;
                [self blueOpenedTreasureBox:point];
            }
            else if([self checkIfThereIsACannon:point])
            {
                //NSLog(@"shootCannon");
                 box.status=BLUE;
                [self blueCannonBallShoot:point];
            }
             */
            if(box.status==TREASUREBOX)
            {
                box.status=BLUE;
                [self blueOpenedTreasureBox:point];
            }
            else if (box.status==CANNON)
            {
                box.status=BLUE;
                [self blueCannonBallShoot:point];
                
            }
            else if (box.status==SHIP){
                box.status=BLUE;
                [self blueShipMoving:point];
            }
            else if (box.status==MAP){
                box.status=BLUE;
                [self blueFoundTreasureMap:point];
            }
            else if (box.status==SKULL) {
                box.status=BLUE;
                [self blueOpenedSkull:point];
            }
            
            else
            {
                 box.status=BLUE;
            //if(!LeftFilled)
           // {
            //[_gridView blueBlockAtPositionX:pointX PositionY:pointY];
                
                 [_gridView fillBlockAtPositionX:pointX PositionY:pointY WithColor:BLUE_BOX];
            //}
            //else {
            //    _gridView.secondBoxPositionX=pointX;
            //    _gridView.secondBoxPositionY=pointY;
            //    _gridView.waitToShowSecondBoxBlue=0.5;
            //}
            _gridModel.blueScore++;
             [_gridView.blueScoreBox changeScore:1];
            }
        }
        else {
          _changeColor=NO;
            _otherPlayerTurn=NO;
            CGPoint point=ccp(pointX,pointY);
            /*
            if([self checkIfThereIsATreasureBox:point])
            {
                  box.status=ORANGE;
                [self orangeOpenedTresureBox:point];
            }
            else if([self checkIfThereIsACannon:point])
            {
              //  NSLog(@"shootCannon");
                  box.status=ORANGE;
                [self orangeCannonBallShoot:point];
            }
             */
            if(box.status==TREASUREBOX)
            {
                box.status=ORANGE;
                [self orangeOpenedTresureBox:point];
            }
            else if (box.status==CANNON)
            {
                box.status=ORANGE;
                [self orangeCannonBallShoot:point];
                
            }
            else if (box.status==SHIP){
                box.status=ORANGE;
                [self orangeShipMoving:point];
            }
            else if (box.status==MAP){
                box.status=ORANGE;
                [self orangeFoundTreasureMap:point];
            }
            else if (box.status==SKULL) {
                box.status=ORANGE;
                [self orangeOpenedSkull:point];
            }
            
            else {
                  box.status=ORANGE;
            
            //if(!LeftFilled)
            //{
            //[_gridView orangeBlockAtPositionX:pointX PositionY:pointY];
                [_gridView fillBlockAtPositionX:pointX PositionY:pointY WithColor:ORANGE_BOX];
            //}
            //else {
            //    _gridView.secondBoxPositionX=pointX;
            //    _gridView.secondBoxPositionY=pointY;
            //    _gridView.waitToShowSecondBoxOrange=0.5;
            //}
             _gridModel.orangeScore++;
              [_gridView.orangeScoreBox changeScore:1];
            }
        }
        }
        // [_lable setString:[NSString stringWithFormat:@"Square Right"]];
        
        //[self checkWinner];
    }
    
    if(!_twoPlayerOnOneDevice &&_CPUTurn&&!_CPUThinking)
    {
        // [_brain move:self];
        _touchEnable=NO;
        [_brain move];
    }
  
    if(_twoPlayerOnOneDevice && [_gameMode isEqualToString:@"blueTooth"]&&_otherPlayerTurn &&!_isReceiving)
    {
        _touchEnable=NO;
        //send the move to other player and wait for their move
        [self sendMoveToTheOtherPlayer:@"line" RowOrLineIndex:lineIndex EdgeIndex:edgeIndex switchTurn:@"YES"];
    }
    
    else if(_twoPlayerOnOneDevice && [_gameMode isEqualToString:@"blueTooth"]&&!_otherPlayerTurn&&!_isReceiving)
    {
        //send the move to other player
        [self sendMoveToTheOtherPlayer:@"line" RowOrLineIndex:lineIndex EdgeIndex:edgeIndex switchTurn:@"NO"];
    }
    
    if(_twoPlayerOnOneDevice && [_gameMode isEqualToString:@"network"]&&_otherPlayerTurn &&!_isReceiving)
    {
        _touchEnable=NO;
        //send the move to other player and wait for their move
        [self networkSendMoveToTheOtherPlayer:@"line" RowOrLineIndex:lineIndex EdgeIndex:edgeIndex switchTurn:@"YES"];
    }
    
    else if(_twoPlayerOnOneDevice && [_gameMode isEqualToString:@"network"]&&!_otherPlayerTurn&&!_isReceiving)
    {
        //send the move to other player
        [self networkSendMoveToTheOtherPlayer:@"line" RowOrLineIndex:lineIndex EdgeIndex:edgeIndex switchTurn:@"NO"];
    }
    [self showPlayerTurnInfo];
}
-(void)getTotalScore
{
    NSString *islandNum=[[GameSettings shared] getGlobalForKey:@"island"];
    int totalScore=0;
    int page=[islandNum intValue];
    for (int i=1; i<5; i++) 
    {
        for (int j=1; j<5; j++) 
        {
            NSString *score=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"bestScoreLevel%d",((j+(i-1)*4)+page*16)]];
            totalScore=totalScore+[score intValue];
        }
    }
    NSString *totalScoreString=[NSString stringWithFormat:@"%d",totalScore];
    [[GameSettings shared] setGlobal:totalScoreString ForKey:[NSString stringWithFormat:@"island%@Score",islandNum]];
    
    
}

-(BOOL)checkWinner
{
    BOOL hasWinner=NO;
    int i= (int)[_gridView.treasureBoxArray count];
    int j=(int)[_gridView.mapArray count];
    int x=(int)[_gridView.skullArray count];  
    
    
    
        if(_gridModel.skullLeft==0)
        {
    int totalScore=i*2+_boxCount-_gridModel.damageCount-2*_gridModel.skullDamageCount-x;
    if(_gridModel.blueMapCount==2||_gridModel.orangeMapCount==2)
    {
     totalScore=i*2+_boxCount-_gridModel.damageCount-2*_gridModel.skullDamageCount-x+(j*5)/2;
    }
      // NSLog(@"total score is%d",totalScore);
    if((_gridModel.blueScore+_gridModel.orangeScore)==totalScore)
    {
        hasWinner=YES;
        if(_gridModel.blueScore>_gridModel.orangeScore)
        {
            _winOrLose=YES;
            if([_gameMode isEqualToString:@"solo"])
            {
           
                NSString *levelNumber=[[GameSettings shared] getGlobalForKey:@"selectedLevel"];
                
                //update total medal number for this island
                NSString *hasMedal=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"GiveMedalLevel%@",levelNumber]];
                if(![hasMedal isEqualToString:@"YES"])
                {
                NSString *islandNumber= [[GameSettings shared] getGlobalForKey:@"island"];
                NSString *totalMedal=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"MedalNumberForIsland%@",islandNumber]];
                    int newMedal=[totalMedal intValue];
                    newMedal++;
                   
                NSString *newTotalMedal=[NSString stringWithFormat:@"%d",newMedal];
                [[GameSettings shared] setGlobal:[NSString stringWithFormat:@"%@",newTotalMedal] ForKey:[NSString stringWithFormat:@"MedalNumberForIsland%@",islandNumber]];
                }
                
                
              //clear level, get medal, and won game
                [[GameSettings shared] setGlobal:@"YES" ForKey:[NSString stringWithFormat:@"ClearLevel%@",levelNumber]];
                [[GameSettings shared] setGlobal:@"YES" ForKey:[NSString stringWithFormat:@"GiveMedalLevel%@",levelNumber]];
                [[GameSettings shared] setGlobal:@"YES" ForKey:@"WonGame"];
                
               
                //unlock next level
                int levelNumberInt= [ [[GameSettings shared] getGlobalForKey:@"selectedLevel"] intValue];
                int nextLevelNumber=levelNumberInt+1;
                if(nextLevelNumber>96)
                {
                    nextLevelNumber=96;
                }
                
                NSString *nextLevelNumberString=[NSString stringWithFormat:@"%d",nextLevelNumber];
                 [[GameSettings shared] setGlobal:@"YES" ForKey:[NSString stringWithFormat:@"level%@",nextLevelNumberString]];
                
                //current score and best score
                NSString *currentScore=[NSString stringWithFormat:@"%d",100*_gridModel.blueScore];
                [[GameSettings shared] setGlobal:currentScore ForKey:[NSString stringWithFormat:@"currentScoreLevel%@",levelNumber]];
                NSString *bestScore=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"bestScoreLevel%@",levelNumber]];
                
                int bestScoreInt=[bestScore intValue];
                [[GameSettings shared] setGlobal:@"NO" ForKey:@"isNewBestSocre"];
                if(_gridModel.blueScore*100>bestScoreInt)
                {
                   
                    [[GameSettings shared] setGlobal:currentScore ForKey:[NSString stringWithFormat:@"bestScoreLevel%@",levelNumber]];
                    [[GameSettings shared] setGlobal:@"YES" ForKey:@"isNewBestSocre"];
                }
                
                
               
                int totalScore=0;
                for(int page=0;page<6;page++)
                {
                
                for (int i=1; i<5; i++) 
                {
                    for (int j=1; j<5; j++) 
                    {
                        NSString *score=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"bestScoreLevel%d",((j+(i-1)*4)+page*16)]];
                        totalScore=totalScore+[score intValue];
                    }
                }
                }
                NSString *totalScoreString=[NSString stringWithFormat:@"%d",totalScore];
                 float totalScorefloat=[totalScoreString floatValue];
                
                
                [[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland1Score score:totalScorefloat];
               // [[GameSettings shared] setGlobal:totalScoreString ForKey:[NSString stringWithFormat:@"island%@Score",islandNum]];

                
                
            }
            
            else if ([_gameMode isEqualToString:@"oneDevice"])
            {
                     //[[SimpleAudioEngine sharedEngine] playEffect:@"wonGame.wav"];
                // [_gridView.lable setString:[NSString stringWithFormat:@"%@ Won!",[[GameSettings shared] getGlobalForKey:@"Player1Name"]]];
                NSString *winnerScore= [[GameSettings shared] getGlobalForKey:[[GameSettings shared] getGlobalForKey:@"Player1Name"]];
                int winnerScoreInt=0;
                if([winnerScore isEqualToString:@""])
                {
                    winnerScoreInt=1;
                }
                else
                {
                    winnerScoreInt=[winnerScore intValue];
                    winnerScoreInt++;
                }
                NSString *newWinnerScore=[NSString stringWithFormat:@"%d",winnerScoreInt];
                
                [[GameSettings shared] setGlobal:newWinnerScore ForKey:[[GameSettings shared] getGlobalForKey:@"Player1Name"]];
                [[GameSettings shared] setGlobal:[[GameSettings shared] getGlobalForKey:@"Player1Name"] ForKey:@"WinnerName"];
            }
            else if([_gameMode isEqualToString:@"blueTooth"]||[_gameMode isEqualToString:@"network"])
            {
                    // [[SimpleAudioEngine sharedEngine] playEffect:@"wonGame.wav"];
               // [_gridView.lable setString:[NSString stringWithFormat:@"%@ Won!",[[GameSettings shared] getGlobalForKey:@"BluePlayer"]]];
                
                NSString *winnerScore= [[GameSettings shared] getGlobalForKey:[[GameSettings shared] getGlobalForKey:@"BluePlayer"]];
                int winnerScoreInt=0;
                if([winnerScore isEqualToString:@""])
                {
                     winnerScoreInt=1;
                }
                else
                {
                    winnerScoreInt=[winnerScore intValue];
                    winnerScoreInt++;
                }
                NSString *newWinnerScore=[NSString stringWithFormat:@"%d",winnerScoreInt];
                
                [[GameSettings shared] setGlobal:newWinnerScore ForKey:[[GameSettings shared] getGlobalForKey:@"BluePlayer"]];
                [[GameSettings shared] setGlobal:[[GameSettings shared] getGlobalForKey:@"BluePlayer"] ForKey:@"WinnerName"];
                NSString *localPlayerName=[[GKLocalPlayer localPlayer] alias];
                NSString *bluePlayer=[[GameSettings shared] getGlobalForKey:@"BluePlayer"];
                
                NSLog(@"localPlayerName: %@",localPlayerName);
                NSLog(@"bluePlayerName: %@",bluePlayer );
                
                
                
             if(   [localPlayerName isEqualToString:bluePlayer]&&[_gameMode isEqualToString:@"network"])
             {
                 //[[GCHelper sharedInstance] reportLeaderboardOnlineWinning:@""];
                 NSString *islandNum=[[GameSettings shared] getGlobalForKey:@"island"];
                
                 int page=[islandNum intValue];
                
                 if(page==0)
                 {
                     //[[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland1Score score:totalScorefloat];
                     [[GCHelper sharedInstance] reportLeaderboardOnlineWinning:gcLeaderboardPVPscore];
                 }
                 else if(page==1)
                 {
                     //[[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland2Score score:totalScorefloat];
                     [[GCHelper sharedInstance] reportLeaderboardOnlineWinning:gcLeaderboardPVPscore];
                 }
                 else if(page==2)
                 {
                     //[[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland3Score score:totalScorefloat];
                     [[GCHelper sharedInstance] reportLeaderboardOnlineWinning:gcLeaderboardPVPscore];
                 }
                 else if(page==3)
                 {
                     //[[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland4Score score:totalScorefloat];
                     [[GCHelper sharedInstance] reportLeaderboardOnlineWinning:gcLeaderboardPVPscore];
                 }
                 else if(page==4)
                 {
                     //[[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland5Score score:totalScorefloat];
                     [[GCHelper sharedInstance] reportLeaderboardOnlineWinning:gcLeaderboardPVPscore];
                 }
                 else if(page==5)
                 {
                     //[[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland6Score score:totalScorefloat];
                     [[GCHelper sharedInstance] reportLeaderboardOnlineWinning:gcLeaderboardPVPscore];
                 }
               
             }
                
            }
            

            //[_gridView.playerIndicator  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextBlue.png"]]; 
           // [_gridView.playerIndicator2  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextBlue.png"]];
            
            
        }
        else if(_gridModel.blueScore==_gridModel.orangeScore)
        {
            _winOrLose=NO;
            if([_gameMode isEqualToString:@"solo"])
            {
                NSString *levelNumber=[[GameSettings shared] getGlobalForKey:@"selectedLevel"];
                
                //clear level, and won game
                [[GameSettings shared] setGlobal:@"YES" ForKey:[NSString stringWithFormat:@"ClearLevel%@",levelNumber]];
                 [[GameSettings shared] setGlobal:@"YES" ForKey:@"WonGame"];
                
                 //unlock next level
                int levelNumberInt= [ [[GameSettings shared] getGlobalForKey:@"selectedLevel"] intValue];
                int nextLevelNumber=levelNumberInt+1;
                if(nextLevelNumber>64)
                {
                    nextLevelNumber=64;
                }
                
                NSString *nextLevelNumberString=[NSString stringWithFormat:@"%d",nextLevelNumber];
                [[GameSettings shared] setGlobal:@"YES" ForKey:[NSString stringWithFormat:@"level%@",nextLevelNumberString]];
                
                //current score and best score
                NSString *currentScore=[NSString stringWithFormat:@"%d",100*_gridModel.blueScore];
                [[GameSettings shared] setGlobal:currentScore ForKey:[NSString stringWithFormat:@"currentScoreLevel%@",levelNumber]];
                NSString *bestScore=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"bestScoreLevel%@",levelNumber]];
                
                int bestScoreInt=[bestScore intValue];
                [[GameSettings shared] setGlobal:@"NO" ForKey:@"isNewBestSocre"];
                if(_gridModel.blueScore*100>bestScoreInt)
                {
                    
                    [[GameSettings shared] setGlobal:currentScore ForKey:[NSString stringWithFormat:@"bestScoreLevel%@",levelNumber]];
                    [[GameSettings shared] setGlobal:@"YES" ForKey:@"isNewBestSocre"];
                }
                
                int totalScore=0;
                for(int page=0;page<6;page++)
                {
                    
                    for (int i=1; i<5; i++) 
                    {
                        for (int j=1; j<5; j++) 
                        {
                            NSString *score=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"bestScoreLevel%d",((j+(i-1)*4)+page*16)]];
                            totalScore=totalScore+[score intValue];
                        }
                    }
                }
                NSString *totalScoreString=[NSString stringWithFormat:@"%d",totalScore];
                float totalScorefloat=[totalScoreString floatValue];
                
                
                [[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland1Score score:totalScorefloat];
            }
            
            else if ([_gameMode isEqualToString:@"oneDevice"])
            {
              //  [_gridView.lable setString:[NSString stringWithFormat:@"Tie Game!"]];
                   // [[SimpleAudioEngine sharedEngine] playEffect:@"lostGame"];
                 [[GameSettings shared] setGlobal:@"" ForKey:@"WinnerName"];
            }
            else if([_gameMode isEqualToString:@"blueTooth"]||[_gameMode isEqualToString:@"network"])
            {
              //  [_gridView.lable setString:[NSString stringWithFormat:@"Tie Game!"]];
                   // [[SimpleAudioEngine sharedEngine] playEffect:@"lostGame"];
                [[GameSettings shared] setGlobal:@"" ForKey:@"WinnerName"];
            }
            
           // [_gridView.playerIndicator setVisible:NO];
           // [_gridView.playerIndicator2 setVisible:NO];
            
        }

        else {
            _winOrLose=NO;
            if([_gameMode isEqualToString:@"solo"])
            {
                 NSString *levelNumber=[[GameSettings shared] getGlobalForKey:@"selectedLevel"];
                 [[GameSettings shared] setGlobal:@"NO" ForKey:@"WonGame"];
                
                
                //current score and best score
                NSString *currentScore=[NSString stringWithFormat:@"%d",100*_gridModel.blueScore];
                [[GameSettings shared] setGlobal:currentScore ForKey:[NSString stringWithFormat:@"currentScoreLevel%@",levelNumber]];
                NSString *bestScore=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"bestScoreLevel%@",levelNumber]];
                
                int bestScoreInt=[bestScore intValue];
                [[GameSettings shared] setGlobal:@"NO" ForKey:@"isNewBestSocre"];
                if(_gridModel.blueScore*100>bestScoreInt)
                {
                    
                    [[GameSettings shared] setGlobal:currentScore ForKey:[NSString stringWithFormat:@"bestScoreLevel%@",levelNumber]];
                    [[GameSettings shared] setGlobal:@"YES" ForKey:@"isNewBestSocre"];
                }

               // [_gridView.lable setString:[NSString stringWithFormat:@"CPU Won!"]];
               // [[SimpleAudioEngine sharedEngine] playEffect:@"lostGame"];
                int totalScore=0;
                for(int page=0;page<6;page++)
                {
                    
                    for (int i=1; i<5; i++) 
                    {
                        for (int j=1; j<5; j++) 
                        {
                            NSString *score=[[GameSettings shared] getGlobalForKey:[NSString stringWithFormat:@"bestScoreLevel%d",((j+(i-1)*4)+page*16)]];
                            totalScore=totalScore+[score intValue];
                        }
                    }
                }
                NSString *totalScoreString=[NSString stringWithFormat:@"%d",totalScore];
                float totalScorefloat=[totalScoreString floatValue];
                
                
                [[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland1Score score:totalScorefloat];
            }
            
            else if ([_gameMode isEqualToString:@"oneDevice"])
            {
                     //[[SimpleAudioEngine sharedEngine] playEffect:@"wonGame.wav"];
              //  [_gridView.lable setString:[NSString stringWithFormat:@"%@ Won!",[[GameSettings shared] getGlobalForKey:@"Player2Name"]]];
                NSString *winnerScore= [[GameSettings shared] getGlobalForKey:[[GameSettings shared] getGlobalForKey:@"Player2Name"]];
                int winnerScoreInt=0;
                if([winnerScore isEqualToString:@""])
                {
                    winnerScoreInt=1;
                }
                else
                {
                    winnerScoreInt=[winnerScore intValue];
                    winnerScoreInt++;
                }
                NSString *newWinnerScore=[NSString stringWithFormat:@"%d",winnerScoreInt];
                
                [[GameSettings shared] setGlobal:newWinnerScore ForKey:[[GameSettings shared] getGlobalForKey:@"Player2Name"]];
                [[GameSettings shared] setGlobal:[[GameSettings shared] getGlobalForKey:@"Player2Name"] ForKey:@"WinnerName"];
            }
            else if([_gameMode isEqualToString:@"blueTooth"]||[_gameMode isEqualToString:@"network"])
            {
                NSString *winnerScore= [[GameSettings shared] getGlobalForKey:[[GameSettings shared] getGlobalForKey:@"OrangePlayer"]];
                int winnerScoreInt=0;
                if([winnerScore isEqualToString:@""])
                {
                    winnerScoreInt=1;
                }
                else
                {
                    winnerScoreInt=[winnerScore intValue];
                    winnerScoreInt++;
                }
                NSString *newWinnerScore=[NSString stringWithFormat:@"%d",winnerScoreInt];
                
                [[GameSettings shared] setGlobal:newWinnerScore ForKey:[[GameSettings shared] getGlobalForKey:@"OrangePlayer"]];
                 [[GameSettings shared] setGlobal:[[GameSettings shared] getGlobalForKey:@"OrangePlayer"] ForKey:@"WinnerName"];
                
                NSString *localPlayerName=[[GKLocalPlayer localPlayer] alias];
                NSString *orangePlayer=[[GameSettings shared] getGlobalForKey:@"OrangePlayer"];
                
                NSLog(@"localPlayerName: %@",localPlayerName);
                NSLog(@"orangePlayerName: %@",orangePlayer );
                if(   [localPlayerName isEqualToString:orangePlayer]&&[_gameMode isEqualToString:@"network"])
                {
                    //[[GCHelper sharedInstance] reportLeaderboardOnlineWinning:@""];
                    NSString *islandNum=[[GameSettings shared] getGlobalForKey:@"island"];
                    
                    int page=[islandNum intValue];
                    
                    if(page==0)
                    {
                        //[[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland1Score score:totalScorefloat];
                        [[GCHelper sharedInstance] reportLeaderboardOnlineWinning:gcLeaderboardPVPscore];
                    }
                    else if(page==1)
                    {
                        //[[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland2Score score:totalScorefloat];
                        [[GCHelper sharedInstance] reportLeaderboardOnlineWinning:gcLeaderboardPVPscore];
                    }
                    else if(page==2)
                    {
                        //[[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland3Score score:totalScorefloat];
                        [[GCHelper sharedInstance] reportLeaderboardOnlineWinning:gcLeaderboardPVPscore];
                    }
                    else if(page==3)
                    {
                        //[[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland4Score score:totalScorefloat];
                        [[GCHelper sharedInstance] reportLeaderboardOnlineWinning:gcLeaderboardPVPscore];
                    }
                    else if(page==4)
                    {
                        //[[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland5Score score:totalScorefloat];
                        [[GCHelper sharedInstance] reportLeaderboardOnlineWinning:gcLeaderboardPVPscore];
                    }
                    else if(page==5)
                    {
                        //[[GCHelper sharedInstance] reportLeaderboard:gcLeaderboardIsland6Score score:totalScorefloat];
                        [[GCHelper sharedInstance] reportLeaderboardOnlineWinning:gcLeaderboardPVPscore];
                    }
                    
                }


                    // [[SimpleAudioEngine sharedEngine] playEffect:@"wonGame.wav"];
               //  [_gridView.lable setString:[NSString stringWithFormat:@"%@ Won!",[[GameSettings shared] getGlobalForKey:@"OrangePlayer"]]];
            }
            // [_gridView.playerIndicator  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextOrange.png"]];
            //[_gridView.playerIndicator2  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextOrange.png"]];
        }
        //[self newGame];
        _touchEnable=YES;
        _isNewGame=YES;
        if(!_GameOver)
        {
            _GameOver=YES;
        
            _gridView.gameoverWindow=[GameoverWindow GameWindowInController:self];
            [_gridView addChild:_gridView.gameoverWindow];
            _gridView.gameoverWindow.waitToFadeInWindow=3.0;
            
            //GameoverWindow *gameoverWindow=[GameoverWindow GameWindowInController:self];
            //[_gridView addChild:gameoverWindow];

                }
        [self getTotalScore];
           }
            
        }
    return hasWinner;
}
- (void)checkTreasureMapWinner
{
    if(_gridModel.blueMapCount==2)
    {
        [_gridView showMessageBoxForTreasureMap];
        _gridModel.blueScore=_gridModel.blueScore+5;
        [_gridView.blueScoreBox changeScore:5];
        [[SimpleAudioEngine sharedEngine] playEffect:@"treasuremap2.wav"];
    }
    else if(_gridModel.orangeMapCount==2)
    {
        [_gridView showMessageBoxForTreasureMap];
        _gridModel.orangeScore=_gridModel.orangeScore+5;
        [_gridView.orangeScoreBox changeScore:5];
        [[SimpleAudioEngine sharedEngine] playEffect:@"treasuremap2.wav"];
    }
    
}
-(void)newGame
{
    [_gridModel resetModel];
    [_gridView resetView];
    //[_gridView.playerIndicator setVisible:YES];
    
   // [_gridView.playerIndicator  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextBlue.png"]];
   // [_gridView.playerIndicator2 setVisible:YES];
    
   // [_gridView.playerIndicator2  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextBlue.png"]];
    _changeColor=YES;
    _GameOver=NO;
    _CPUThinking=NO;
    _CPUTurn=NO;
    _otherPlayerTurn=NO;
    
    if(!_twoPlayerOnOneDevice)
    {
        
        _brain=nil;
        _brain=[CPUBrain instance];
        _brain.grid=self;
        
     int yesOrNo = arc4random() % 2;
    
    if(yesOrNo)
    {
     _touchEnable=YES;
     _isBlueColor=NO;
        NSString *LevelNumber=[[GameSettings shared] getGlobalForKey:@"selectedLevel"];
        if([LevelNumber isEqualToString:@"1"]||[LevelNumber isEqualToString:@"2"])
        {
            _isBlueColor=YES;
            
            _touchEnable=NO;
            _brain.waitToCheckRandomEdge=2.5;
        }
    
    }
    else {
        _isBlueColor=YES;
      
        _touchEnable=NO;
        _brain.waitToCheckRandomEdge=2.5;
       // [_gridView.lable setString:[NSString stringWithFormat:@"CPU's Turn"]];
        [_gridView orangeIsOn];
       // [_gridView.playerIndicator  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextOrange.png"]];
         //[_gridView.playerIndicator2  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextOrange.png"]];
    }
    }
    else {
        _touchEnable=YES;
        _isBlueColor=NO;
        // [_gridView.lable setString:[NSString stringWithFormat:@"%@'s Turn",[[GameSettings shared] getGlobalForKey:@"Player1Name"]]];
        [_gridView blueIsOn];
        
        if([_gameMode isEqualToString:@"network"])
        {
           // NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
            NSString *playerName=	[[GKLocalPlayer localPlayer] alias];
            NSString *bluePlayerName=[[GameSettings shared] getGlobalForKey:@"BluePlayer"];
            
            if([playerName isEqualToString:bluePlayerName])
            {
                int yesOrNo = arc4random() % 2;
                
                if(yesOrNo)
                {
                    _touchEnable=YES;
                    _isBlueColor=NO; 
                    [_gridView blueIsOn];
                   // if([_gameMode isEqualToString:@"blueTooth"])
                    //{
                      //  [self disableOpponnentMove:@"YES"];
                   // }
                   // else if([_gameMode isEqualToString:@"network"])
                    //{
                        [self networkDisableOpponnentMove:@"YES"];
                    //}
                }
                else {
                    _isBlueColor=YES;
                    
                    _touchEnable=NO;
                    [_gridView orangeIsOn];
                    //if([_gameMode isEqualToString:@"blueTooth"])
                   // {
                    //    [self disableOpponnentMove:@"NO"];
                    //}
                    //else if([_gameMode isEqualToString:@"network"])
                   // {
                        [self networkDisableOpponnentMove:@"NO"];
                    //}
                }

            }
        }
        
        else if([_gameMode isEqualToString:@"blueTooth"])
            
        {
             NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
            //NSString *playerName=	[[GKLocalPlayer localPlayer] alias];
            NSString *bluePlayerName=[[GameSettings shared] getGlobalForKey:@"BluePlayer"];
            
            if([playerName isEqualToString:bluePlayerName])
            {
                int yesOrNo = arc4random() % 2;
                
                if(yesOrNo)
                {
                    _touchEnable=YES;
                    _isBlueColor=NO; 
                    [_gridView blueIsOn];
                    //if([_gameMode isEqualToString:@"blueTooth"])
                   // {
                        [self disableOpponnentMove:@"YES"];
                    //}
                    //else if([_gameMode isEqualToString:@"network"])
                    //{
                      //  [self networkDisableOpponnentMove:@"YES"];
                    //}
                }
                else {
                    _isBlueColor=YES;
                    
                    _touchEnable=NO;
                    [_gridView orangeIsOn];
                    //if([_gameMode isEqualToString:@"blueTooth"])
                    //{
                        [self disableOpponnentMove:@"NO"];
                    //}
                    //else if([_gameMode isEqualToString:@"network"])
                   // {
                     //   [self networkDisableOpponnentMove:@"NO"];
                    //}
                }
                
            }

            
            }
    }
    /*
NSString *touchEnable=[[GameSettings shared] getGlobalForKey:@"touchEnable"];
   if(_twoPlayerOnOneDevice && [touchEnable isEqualToString:@"NO"] && ([_gameMode isEqualToString:@"blueTooth"]||[_gameMode isEqualToString:@"network"]))
 {
     _touchEnable=NO;
   
        // [_gridView.lable setString:@"Opponent's Turn"];
    // [_gridView.lable setString:[NSString stringWithFormat:@"%@'s Turn",[[GameSettings shared] getGlobalForKey:@"BluePlayer"]]];
     [_gridView blueIsOn];
     
 }
     */
    _gridModel.skullLeft=(int)_gridView.skullArray.count;
    
   }

- (void)showPlayerTurnInfo
{
    if(_changeColor&&_isBlueColor)
    {
        if([_gameMode isEqualToString:@"solo"])
        {
         //   [_gridView.lable setString:[NSString stringWithFormat:@"CPU's Turn"]];
            [_gridView orangeIsOn];
            
        }
        
        else if ([_gameMode isEqualToString:@"oneDevice"])
        {
       //     [_gridView.lable setString:[NSString stringWithFormat:@"%@'s Turn",[[GameSettings shared] getGlobalForKey:@"Player2Name"]]]; 
            [_gridView orangeIsOn];
        }
        else if([_gameMode isEqualToString:@"blueTooth"]||[_gameMode isEqualToString:@"network"])
        {
            //[_gridView.lable setString:[NSString stringWithFormat:@"Player 2's Turn"]];
       //     [_gridView.lable setString:[NSString stringWithFormat:@"%@'s Turn",[[GameSettings shared] getGlobalForKey:@"OrangePlayer"]]];
            [_gridView orangeIsOn];
        }
      //  [_gridView.playerIndicator  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextOrange.png"]];
       // [_gridView.playerIndicator2  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextOrange.png"]];
    }
    else if (_changeColor &&!_isBlueColor)
    {
        if([_gameMode isEqualToString:@"solo"])
        {
    //        [_gridView.lable setString:[NSString stringWithFormat:@"Your Turn"]];
            [_gridView blueIsOn];
        }
        
        else if ([_gameMode isEqualToString:@"oneDevice"])
        {
      //    [_gridView.lable setString:[NSString stringWithFormat:@"%@'s Turn",[[GameSettings shared] getGlobalForKey:@"Player1Name"]]];
            [_gridView blueIsOn];
        }
        else if([_gameMode isEqualToString:@"blueTooth"]||[_gameMode isEqualToString:@"network"])
        {
       //     [_gridView.lable setString:[NSString stringWithFormat:@"%@'s Turn",[[GameSettings shared] getGlobalForKey:@"BluePlayer"]]];
            [_gridView blueIsOn];
        }
       // [_gridView.playerIndicator  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextBlue.png"]];
       // [_gridView.playerIndicator2  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextBlue.png"]];
    }
    
    else if(!_changeColor && _isBlueColor){
        if([_gameMode isEqualToString:@"solo"])
        {
       //     [_gridView.lable setString:[NSString stringWithFormat:@"Your Turn"]];
            //[_gridView blueIsOn];
        }
        
        else if ([_gameMode isEqualToString:@"oneDevice"])
        {
      //       [_gridView.lable setString:[NSString stringWithFormat:@"%@'s Turn",[[GameSettings shared] getGlobalForKey:@"Player1Name"]]];
            //[_gridView blueIsOn];
        }
        else if([_gameMode isEqualToString:@"blueTooth"]||[_gameMode isEqualToString:@"network"])
        {
       //     [_gridView.lable setString:[NSString stringWithFormat:@"%@'s Turn",[[GameSettings shared] getGlobalForKey:@"BluePlayer"]]];
            //[_gridView blueIsOn];
        }
       // [_gridView.playerIndicator  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextBlue.png"]];
       // [_gridView.playerIndicator2  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextBlue.png"]];
        [self checkWinner];
    }
    else if (!_changeColor &&!_isBlueColor)
    {
        if([_gameMode isEqualToString:@"solo"])
        {
       //     [_gridView.lable setString:[NSString stringWithFormat:@"CPU's Turn"]];
           // [_gridView orangeIsOn];
        }
        
        else if ([_gameMode isEqualToString:@"oneDevice"])
        {
       //      [_gridView.lable setString:[NSString stringWithFormat:@"%@'s Turn",[[GameSettings shared] getGlobalForKey:@"Player2Name"]]]; 
           // [_gridView orangeIsOn];
        }
        else if([_gameMode isEqualToString:@"blueTooth"]||[_gameMode isEqualToString:@"network"])
        {
       //    [_gridView.lable setString:[NSString stringWithFormat:@"%@'s Turn",[[GameSettings shared] getGlobalForKey:@"OrangePlayer"]]];
          //  [_gridView orangeIsOn];
        } 
        
       // [_gridView.playerIndicator  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextOrange.png"]];
      //  [_gridView.playerIndicator2  setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_TextOrange.png"]];
        [self checkWinner];
    }
    
    
}

- (void)update:(ccTime)dt {
    
    [_gridView update:dt];
    [_brain update:dt];
}


- (CGPoint)generatePositionForItem:(BoxInfo)boxInfor
{
    
    int rowIndex =( arc4random() % 4) + 1;
    int edgeIndex = (arc4random() % 5) + 1;                      
    //int rowIndex=2;
    //int edgeIndex=3;
    CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN-0.5*EDGE_LENGTH;
    CGFloat pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;
    int blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    
    Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
    
    
    while (!box.status==EMPTY) {
        rowIndex =( arc4random() % 4) + 1;
        edgeIndex = (arc4random() % 5) + 1;                      
        
        pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN-0.5*EDGE_LENGTH;
        pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;
        blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
        
    }

    
    
    box.status=boxInfor;
    CGPoint point=ccp(pointX,pointY);
    return point;

}

- (CGPoint)generatePositionForItem:(BoxInfo)boxInfor AtRow:(int)rowIndex ItemIndex:(int)edgeIndex
{
    
    
    CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN-0.5*EDGE_LENGTH;
    CGFloat pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;
    int blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    
    Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
    box.status=boxInfor;
    CGPoint point=ccp(pointX,pointY);
    return point;
    
}

- (CGPoint)generatePositionForFogAtRow:(int)rowIndex ItemIndex:(int)edgeIndex
{
    
    
    CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN-0.5*EDGE_LENGTH;
    CGFloat pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;
  
    CGPoint point=ccp(pointX,pointY);
    return point;
    
}



- (CGPoint)generatePositionForCannon
{
    int rowIndex =( arc4random() % 4) + 1;
    int edgeIndex = (arc4random() % 5) + 1;                      
    //int rowIndex=4;
    //int edgeIndex=5;
    CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN-0.5*EDGE_LENGTH;
    CGFloat pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;

    int blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    
    Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
    while (!box.status==EMPTY) {
         rowIndex =( arc4random() % 4) + 1;
         edgeIndex = (arc4random() % 5) + 1;                      
        
        pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN-0.5*EDGE_LENGTH;
        pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;
         blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
         blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];

    }
    box.status=CANNON;
    CGPoint point=ccp(pointX,pointY);
    return point;
}
 
-(BoxInfo)checkPowerUps:(CGPoint)point
{
    int blockLineIndex=(point.y-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int blockBoxIndex=(point.x-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    
    Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
    return box.status;

    
}



- (BOOL)checkIfThereIsATreasureBox:(CGPoint)point
{
   // NSLog(@"x:%f, y:%f",_gridView.treasureBox1.position.x,_gridView.treasureBox1.position.y);
    int blockLineIndex=(point.y-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int blockBoxIndex=(point.x-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    
    Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];

    
    if(box.status==TREASUREBOX)
    {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)checkIfThereIsACannon:(CGPoint)point
{
   // NSLog(@"x:%f, y:%f",_gridView.cannon1.position.x,_gridView.cannon1.position.y);
    
    
    int blockLineIndex=(point.y-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int blockBoxIndex=(point.x-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    
    Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
    if(box.status==CANNON)
    {
        return YES;
    }
    else {
        return NO;
    }
}
-(void)fogFadeOut:(CGPoint)point
{
    Fog *fog=[_gridView getFogAtPosition:point];
    if(fog)
    {
    fog.waitToFadeOutFog=0.5;
    [[SimpleAudioEngine sharedEngine] playEffect:@"fog.wav"];
    }
}


-(void)blueOpenedTreasureBox:(CGPoint)point
{
    [self fogFadeOut:point];
    TreasureBox *box=[_gridView getTreasureBoxAtPosition:point];
    box.waitToPlayTreasureBoxAnimation=0;
    [box playOpenAnimation];
    box.waitToFadeOutTreasureBoxBlue=WAIT_TO_FADE_OUT_TREASUREBOX;

    _gridModel.blueScore=_gridModel.blueScore+3;
    [_gridView.blueScoreBox changeScore:3];
    [[SimpleAudioEngine sharedEngine] playEffect:@"treasureBox.wav"];
    [_gridView showMessageBoxForTreasureBox];
}

-(void)orangeOpenedTresureBox:(CGPoint)point
{
    [self fogFadeOut:point];
    TreasureBox *box=[_gridView getTreasureBoxAtPosition:point];
    box.waitToPlayTreasureBoxAnimation=0;
    [box playOpenAnimation];
    box.waitToFadeOutTreasureBoxOrange=WAIT_TO_FADE_OUT_TREASUREBOX;


    _gridModel.orangeScore=_gridModel.orangeScore+3;
    [_gridView.orangeScoreBox changeScore:3];
    [[SimpleAudioEngine sharedEngine] playEffect:@"treasureBox.wav"];
    [_gridView showMessageBoxForTreasureBox];
}

-(void)blueOpenedSkull:(CGPoint)point
{
    [self fogFadeOut:point];
    Skull *box=[_gridView getSkullAtPosition:point];
    
   
    box.waitToFadeOutSkullBlue=WAIT_TO_FADE_OUT_TREASUREBOX;
    //if(_gridView.blueScoreBox.count>1)
    //{
    _gridModel.blueScore=_gridModel.blueScore-2;
    [_gridView.blueScoreBox changeScore:-2];
        _gridModel.skullDamageCount++;
    //}
    //else if(_gridView.blueScoreBox.count==1)
    //{
      //  _gridModel.blueScore=_gridModel.blueScore-1;
        //[_gridView.blueScoreBox changeScore:-1];
        //_gridModel.skullHalfDamageCount++;
    //}
    [[SimpleAudioEngine sharedEngine] playEffect:@"skull.wav"];
    [_gridView showMessageBoxForSkull];
    _gridModel.skullLeft--;
}

-(void)orangeOpenedSkull:(CGPoint)point
{
    [self fogFadeOut:point];
    Skull *box=[_gridView getSkullAtPosition:point];
    
    box.waitToFadeOutSkullOrange=WAIT_TO_FADE_OUT_TREASUREBOX;
    
   // if(_gridView.orangeScoreBox.count>1)
    //{
    _gridModel.orangeScore=_gridModel.orangeScore-2;
    [_gridView.orangeScoreBox changeScore:-2];
        _gridModel.skullDamageCount++;
    //}
    //else if(_gridView.orangeScoreBox.count==1){
      //  _gridModel.orangeScore=_gridModel.orangeScore-1;
        //[_gridView.orangeScoreBox changeScore:-1];
        //_gridModel.skullHalfDamageCount++;
    //}
    [[SimpleAudioEngine sharedEngine] playEffect:@"skull.wav"];
    [_gridView showMessageBoxForSkull];
    _gridModel.skullLeft--;
}

-(void)blueCannonBallShoot:(CGPoint)point
{
    [self fogFadeOut:point];
    Cannon *cannon=[_gridView getCannoAtPosition:point];
    [cannon playCannonShootingAnimation];
   // [cannon playCannonMovingAnimation];
    cannon.waitToFadeOutCannonBlue=WAIT_TO_FADE_OUT_CANNON;

    _gridModel.blueScore=_gridModel.blueScore+1;
    [_gridView.blueScoreBox changeScore:1];
    [[SimpleAudioEngine sharedEngine] playEffect:@"cannonShooting.wav"];
    [self cannonDamage:cannon.cannonPosition];


}

-(void)orangeCannonBallShoot:(CGPoint)point
{
    [self fogFadeOut:point];
    Cannon *cannon=[_gridView getCannoAtPosition:point];
    [cannon playCannonShootingAnimation];
    //[cannon playCannonMovingAnimation];
    cannon.waitToFadeOutCannonOrange=WAIT_TO_FADE_OUT_CANNON;

    _gridModel.orangeScore=_gridModel.orangeScore+1;
    [_gridView.orangeScoreBox changeScore:1];
    [[SimpleAudioEngine sharedEngine] playEffect:@"cannonShooting.wav"];
    [self cannonDamage:cannon.cannonPosition];

}


-(void)blueFoundTreasureMap:(CGPoint)point
{
    TreasureMap *map=[_gridView getMapAtPosition:point];
    map.waitToFadeOutTreasureMapBlue=WAIT_TO_FADE_OUT_MAP;
    _gridModel.blueScore=_gridModel.blueScore+1;
    _gridModel.blueMapCount++;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"treasureMap.wav"];
    [_gridView.blueScoreBox changeScore:1];
    
    if(map.partNumber==TREASUREMAP_PART_ONE)
    {
        CCSprite *mapOne=[CCSprite spriteWithSpriteFrameName:@"Graphic_Tmap_1.png"];
        [mapOne setPosition:ADJUST_CCP(ccp(50,35))];
        [ _gridView.blockLayer addChild:mapOne];
    }
    else if (map.partNumber==TREASUREMAP_PART_TWO)
    {
        CCSprite *mapOne=[CCSprite spriteWithSpriteFrameName:@"Graphic_Tmap_2.png"];
        [mapOne setPosition:ADJUST_CCP(ccp(50,35))];
        [ _gridView.blockLayer addChild:mapOne];
    }
    [self checkTreasureMapWinner];
        
    
    
}

-(void)orangeFoundTreasureMap:(CGPoint)point
{
    TreasureMap *map=[_gridView getMapAtPosition:point];
    map.waitToFadeOutTreasureMapOrange=WAIT_TO_FADE_OUT_MAP;
    
    _gridModel.orangeScore=_gridModel.orangeScore+1;
    _gridModel.orangeMapCount++;
    [_gridView.orangeScoreBox changeScore:1];
    [[SimpleAudioEngine sharedEngine] playEffect:@"treasureMap.wav"];
    if(map.partNumber==TREASUREMAP_PART_ONE)
    {
        CCSprite *mapOne=[CCSprite spriteWithSpriteFrameName:@"Graphic_Tmap_1.png"];
        [mapOne setPosition:ADJUST_CCP(ccp(270,35))];
        [ _gridView.blockLayer addChild:mapOne];
    }
    else if (map.partNumber==TREASUREMAP_PART_TWO)
    {
        CCSprite *mapOne=[CCSprite spriteWithSpriteFrameName:@"Graphic_Tmap_2.png"];
        [mapOne setPosition:ADJUST_CCP(ccp(270,35))];
        [ _gridView.blockLayer addChild:mapOne];
    }
    [self checkTreasureMapWinner];
    
}



-(void)blueShipMoving:(CGPoint)point
{
    [self fogFadeOut:point];
    Ship *ship=[_gridView getShipAtPosition:point];
    [ship moveShip];
    ship.waitToPlayShipAnimation=0;
    [ship playShipFastAnimation];
    ship.waitToFadeOutShipBlue=WAIT_TO_FADE_OUT_SHIP;
  
    _gridModel.blueScore=_gridModel.blueScore+1;
    [_gridView.blueScoreBox changeScore:1];
    [self shipTakingOver:ship.shipPosition];
    [[SimpleAudioEngine sharedEngine] playEffect:@"ship.wav"];
    //[self cannonDamage:cannon.cannonPosition];
    
    
}

-(void)orangeShipMoving:(CGPoint)point
{
    [self fogFadeOut:point];
    Ship *ship=[_gridView getShipAtPosition:point];
    [ship moveShip];
    ship.waitToPlayShipAnimation=0;
    [ship playShipFastAnimation];
    ship.waitToFadeOutShipOrange=WAIT_TO_FADE_OUT_SHIP;

    _gridModel.orangeScore=_gridModel.orangeScore+1;
    [_gridView.orangeScoreBox changeScore:1];
    [self shipTakingOver:ship.shipPosition];
    [[SimpleAudioEngine sharedEngine] playEffect:@"ship.wav"];
    //[self cannonDamage:cannon.cannonPosition];
    
}

-(void)cannonDamage:(CGPoint)point
{
    Cannon *cannon=[_gridView getCannoAtPosition:point];
    int lineIndex=(point.y-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int boxIndex=(point.x-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    Box *boxAttacking=[_gridModel getBoxAtLineIndex:lineIndex BoxIndex:boxIndex];
    //if(cannon shoot left)
    if(!cannon.isFlip)
    {
    Box *boxAttacked= [_gridModel getBoxAtLineIndex:lineIndex BoxIndex:(boxIndex-1)];
        if (boxAttacking.status==BLUE&&boxAttacked.status==ORANGE)
        {
            BoxIcon *box=[_gridView getBoxAtPosition: [_gridView getBoxPositionAt:LEFT From:point]];
            [box playBreakAnimation:ORANGE_BOX];
            _gridModel.orangeScore=_gridModel.orangeScore-1;
            [_gridView.orangeScoreBox changeScore:-1];
            _gridModel.damageCount++;
            
        }
        
        if(boxAttacking.status==ORANGE&&boxAttacked.status==BLUE)
        {
            BoxIcon *box=[_gridView getBoxAtPosition: [_gridView getBoxPositionAt:LEFT From:point]];
            [box playBreakAnimation:BLUE_BOX];
            _gridModel.blueScore=_gridModel.blueScore-1;
            [_gridView.blueScoreBox changeScore:-1];
            _gridModel.damageCount++;
        }

    }
    else
    {
    Box *boxAttacked=[_gridModel getBoxAtLineIndex:lineIndex BoxIndex:(boxIndex+1)];
        if (boxAttacking.status==BLUE&&boxAttacked.status==ORANGE)
        {
            BoxIcon *box=[_gridView getBoxAtPosition: [_gridView getBoxPositionAt:RIGHT From:point]];
            [box playBreakAnimation:ORANGE_BOX];
            _gridModel.orangeScore=_gridModel.orangeScore-1;
            [_gridView.orangeScoreBox changeScore:-1];
            _gridModel.damageCount++;
            
        }
        
        if(boxAttacking.status==ORANGE&&boxAttacked.status==BLUE)
        {
            BoxIcon *box=[_gridView getBoxAtPosition: [_gridView getBoxPositionAt:RIGHT From:point]];
            [box playBreakAnimation:BLUE_BOX];
            _gridModel.blueScore=_gridModel.blueScore-1;
            [_gridView.blueScoreBox changeScore:-1];
            _gridModel.damageCount++;
        }

    }
        
}

-(void)shipTakingOver:(CGPoint)point
{
    Ship *ship=[_gridView getShipAtPosition:point];
    int lineIndex=(point.y-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int boxIndex=(point.x-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    Box *boxAttacking=[_gridModel getBoxAtLineIndex:lineIndex BoxIndex:boxIndex];
    //if(cannon shoot left)
    if(!ship.isFlip)
    {
        float distance=(float)(NUM_OF_ROWS-boxIndex)/NUM_OF_ROWS;
       NSMutableArray *array= [_gridModel.boxs objectAtIndex:lineIndex];
        if(boxAttacking.status==BLUE)
        {
        for(Box *obj in array)
        {
            int itemIndex=(int)[array indexOfObject:obj];
            if(itemIndex>boxIndex&&obj.status==ORANGE)
            {
                BoxIcon *box=[_gridView getBoxAtPosition:[_gridView getItemPositionAtRowIndex:lineIndex ItemIndex:itemIndex]];
                [box setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_BlueBox.png"]];
                _gridModel.orangeScore=_gridModel.orangeScore-1;
                [_gridView.orangeScoreBox changeScore:-1];
                _gridModel.blueScore=_gridModel.blueScore+1;
                [_gridView.blueScoreBox changeScore:1];
                [box setScale:0];
                box.waitToShowBox=distance*0.3*(itemIndex+1);
            }
        }
            
        }
        else if(boxAttacking.status==ORANGE)
        {
            for(Box *obj in array)
            {
                int itemIndex=(int)[array indexOfObject:obj];
                if(itemIndex>boxIndex&&obj.status==BLUE)
                {
                    BoxIcon *box=[_gridView getBoxAtPosition:[_gridView getItemPositionAtRowIndex:lineIndex ItemIndex:itemIndex]];
                    [box setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_OrangeBox.png"]];
                    _gridModel.orangeScore=_gridModel.orangeScore+1;
                    [_gridView.orangeScoreBox changeScore:1];
                    _gridModel.blueScore=_gridModel.blueScore-1;
                    [_gridView.blueScoreBox changeScore:-1];
                    [box setScale:0];
                    box.waitToShowBox=distance*0.3*(itemIndex+1);
                }
            }

        }
   
    }
    else
    {
        float distance=(float)(boxIndex+1)/NUM_OF_ROWS;
        NSMutableArray *array= [_gridModel.boxs objectAtIndex:lineIndex];
        if(boxAttacking.status==BLUE)
        {
            for(Box *obj in array)
            {
                int itemIndex=(int)[array indexOfObject:obj];
                if(itemIndex<boxIndex&&obj.status==ORANGE)
                {
                    BoxIcon *box=[_gridView getBoxAtPosition:[_gridView getItemPositionAtRowIndex:lineIndex ItemIndex:itemIndex]];
                    [box setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_BlueBox.png"]];
                    _gridModel.orangeScore=_gridModel.orangeScore-1;
                    [_gridView.orangeScoreBox changeScore:-1];
                    _gridModel.blueScore=_gridModel.blueScore+1;
                    [_gridView.blueScoreBox changeScore:1];
                    [box setScale:0];
                    box.waitToShowBox=distance*0.3*(NUM_OF_ROWS-itemIndex);
                }
            }
            
        }
        else if(boxAttacking.status==ORANGE)
        {
            for(Box *obj in array)
            {
                int itemIndex=(int)[array indexOfObject:obj];
                if(itemIndex<boxIndex&&obj.status==BLUE)
                {
                    BoxIcon *box=[_gridView getBoxAtPosition:[_gridView getItemPositionAtRowIndex:lineIndex ItemIndex:itemIndex]];
                    [box setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_OrangeBox.png"]];
                    _gridModel.orangeScore=_gridModel.orangeScore+1;
                    [_gridView.orangeScoreBox changeScore:1];
                    _gridModel.blueScore=_gridModel.blueScore-1;
                    [_gridView.blueScoreBox changeScore:-1];
                    [box setScale:0];
                    box.waitToShowBox=distance*0.3*(NUM_OF_ROWS-itemIndex);
                }
            }
            
        }

     
        
    }
    
}
- (NSString *)getIslandName:(NSString *)islandNumber
{
    if([islandNumber isEqualToString:@"0"])
    {
        return @"Cabin Boy";
    }
    else if([islandNumber isEqualToString:@"1"])
    {
        return @"Swabbie";
    }
    else if([islandNumber isEqualToString:@"2"])
    {
        return @"Deckhand";
    }
    else if([islandNumber isEqualToString:@"3"])
    {
        return @"Helmsman";
    }
    else if([islandNumber isEqualToString:@"4"])
    {
        return @"Captain";
    }
    else if([islandNumber isEqualToString:@"5"])
    {
        return @"Pirate King";
    }
    else {
        return nil;
    }
    
}


                            
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"spriteSheet.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"background.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"Black50.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"GameOverSprite.plist"];
     [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"howToPlaySprite.plist"];
    [_waitingAlert release];
    
	[super dealloc];
}




#pragma mark








- (void)session:(PeerSession *)session
           peer:(NSString *)peerID
 didChangeState:(PeerConnectionState)state {
    switch (state)
    {
        case PeerStateConnected:
            NSLog(@"connected");
            break;
        case PeerStateDisconnected:
            NSLog(@"disconnected");
            [currentSession disconnectFromAllPeers];
        
            
            AlertView *alert = [[AlertView alloc] initWithTitle:@""
                                                            message:@"The connection with the other player has been lost"
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
            
            alert.tag=3;
            [alert show];
            [alert release];

             
            [[GameSettings shared] setGlobal:@"oneDevice" ForKey:@"gameMode"];
            _gameMode=@"oneDevice";
            [self newGame];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"BluePlayer"]];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"OrangePlayer"]];
            
            break;
        case PeerStateAvailable:
            NSLog(@"available");
            break;
        case PeerStateConnecting:
            NSLog(@"connecting");
            break;
        case PeerStateUnavailable:
            NSLog(@"unavailable");
            break;
    }
}
- (void) session:(PeerSession *)session didFailWithError:(NSError *)error
{
    
}

- (void) mySendDataToPeers:(NSMutableData *) data
{
    if (currentSession)
        [self.currentSession sendDataToAllPeers:data
                                   withDataMode:PeerSendDataReliable
                                          error:nil];
}


-(void)sendMoveToTheOtherPlayer:(NSString *)RowOrLine
                 RowOrLineIndex:(NSUInteger)rowOrLineIndex
                      EdgeIndex:(NSUInteger)edgeIndex
                      switchTurn:(NSString *)switchOrNot
                 
{
    NSString *isSendingMove=@"YES";
    NSString *_rowOrLineIndex=[NSString stringWithFormat:@"%d",rowOrLineIndex];
    NSString *_edgeIndex=[NSString stringWithFormat:@"%d",edgeIndex];
    NSArray *valueArray=[NSArray arrayWithObjects:isSendingMove,RowOrLine,_rowOrLineIndex,_edgeIndex,switchOrNot,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isSendingMove"],[NSString stringWithFormat:@"RowOrLine"], [NSString stringWithFormat:@"rowOrLineIndex"],[NSString stringWithFormat:@"edgeIndex"],[NSString stringWithFormat:@"switchOrNot"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    [self mySendDataToPeers:data];
    [data release];

}
-(void)sendFogInfoToTheOtherPlayer:(int)RowIndex
                 ItemIndex:(int)itemIndex
                      FlipOrNot:(NSString *)FlipOrNot
                      ItemName:(NSString *)ItemName
                     

{
    NSString *isSendingFogInFo=@"YES";
    NSString *_rowIndex=[NSString stringWithFormat:@"%d",RowIndex];
    NSString *_itemIndex=[NSString stringWithFormat:@"%d",itemIndex];
    NSArray *valueArray=[NSArray arrayWithObjects:isSendingFogInFo,_rowIndex,_itemIndex,FlipOrNot,ItemName,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isSendingFogInfo"],[NSString stringWithFormat:@"RowIndex"], [NSString stringWithFormat:@"ItemIndex"],[NSString stringWithFormat:@"FlipOrNot"],[NSString stringWithFormat:@"ItemName"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    [self mySendDataToPeers:data];
    [data release];
    
}




- (void)showMessage:(NSString *)buttonID
{
    NSString *receiveInvite=[[GameSettings shared] getGlobalForKey:@"receiveInvite"];
    if([receiveInvite isEqualToString:@"NO"])
    {
        return;
    }
    //NSString *str=@"hellohello";
    [[GameSettings shared] setGlobal:@"NO" ForKey:@"receiveInvite"];
    //_receiveInvite=NO;
    
    NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
    NSString *islandNumber=[[GameSettings shared] getGlobalForKey:@"island"];
    NSString *newIslandName=[self getIslandName:islandNumber];
    NSString *levelNumberOnButton=[[GameSettings shared] getGlobalForKey:@"levelNumberOnButton"];
    NSString *invatationText = [NSString stringWithFormat:  @"%@ would like to play %@ level %@", playerName,newIslandName,levelNumberOnButton];
    NSString *levelNumber=buttonID;
    //[[GameSettings shared] setGlobal:playerName ForKey:@"BluePlayer"];
   // [[GameSettings shared] setGlobal:@"YES" ForKey:@"touchEnable"];
    NSString *isInvitation=@"YES";
    NSString *isReply=@"NO";
    NSArray *valueArray=[NSArray arrayWithObjects:playerName,levelNumber,invatationText,isInvitation,isReply,islandNumber,levelNumberOnButton,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"PlayerName"], [NSString stringWithFormat:@"LevelNumber"],[NSString stringWithFormat:@"Text"],[NSString stringWithFormat:@"isInvation"],[NSString stringWithFormat:@"isReply"],[NSString stringWithFormat:@"islandNumber"],[NSString stringWithFormat:@"levelnumberOnButton"],nil];
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


-(void)disableOpponnentMove:(NSString *)yesOrNo
{
    
    NSString *isDecideWhoStart=@"YES";
    NSString *disableOpponnetMove=yesOrNo;
 
    NSArray *valueArray=[NSArray arrayWithObjects:isDecideWhoStart,disableOpponnetMove, nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isDecideWhoStart"],[NSString stringWithFormat:@"disableOpponnetMove"],nil];
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
-(void)reply:(NSString *)yesOrNo AndColor:(NSString *)color
{
    NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
    NSString *isInvitation=@"NO";
    NSString *isReply=@"YES";
    
    NSString *answer=yesOrNo;
    NSArray *valueArray=[NSArray arrayWithObjects:isInvitation,isReply,answer,playerName,color,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isInvation"],[NSString stringWithFormat:@"isReply"],[NSString stringWithFormat:@"answer"],[NSString stringWithFormat:@"PlayerName"],[NSString stringWithFormat:@"opponentColor"],nil];
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
           inSession:(PeerSession *)session
             context:(void *)context {
    //---convert the NSData to NSString---
    
    NSData *newData = data;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:newData];
    NSDictionary *infoList = [unarchiver decodeObjectForKey:@"Data"] ;
    [unarchiver finishDecoding];
    [unarchiver release];
    //[newData release];
    
    
    NSString *isSendingMove=[infoList objectForKey:@"isSendingMove"];
    NSString *isSendingFogInfo=[infoList objectForKey:@"isSendingFogInfo"];
    
    if([isSendingMove isEqualToString:@"YES"])
    {
        NSString *rowOrLine=[infoList objectForKey:@"RowOrLine"];
         NSString *rowOrLineIndex=[infoList objectForKey:@"rowOrLineIndex"];
        NSString *edgeIndex=[infoList objectForKey:@"edgeIndex"];
        NSString *switchOrNot=[infoList objectForKey:@"switchOrNot"];
        NSUInteger _rowOrLineIndex=[rowOrLineIndex integerValue];
        NSUInteger _edgeIndex=[edgeIndex integerValue];
        
        if([switchOrNot isEqualToString:@"YES"])
        {
            _touchEnable=YES;
        }
        else {
            _touchEnable=NO;
        }
        _isReceiving=YES;
        if([rowOrLine isEqualToString:@"row"])
        {
            //_otherPlayerTurn=YES;
            [self drawEdgeAtRowIndex:_rowOrLineIndex EdgeIndex:_edgeIndex];
        }
        
        else if([rowOrLine isEqualToString:@"line"])
        {
            //_otherPlayerTurn=YES;
            [self drawEdgeAtLineIndex:_rowOrLineIndex EdgeIndex:_edgeIndex];
        }
        
        
        _isReceiving=NO;
            }
     if([isSendingFogInfo isEqualToString:@"YES"])
    {
        NSString *rowIndex=[infoList objectForKey:@"RowIndex"];
        NSString *itemIndex=[infoList objectForKey:@"ItemIndex"];
        NSString *FlipOrNot=[infoList objectForKey:@"FlipOrNot"];
        NSString *ItemName=[infoList objectForKey:@"ItemName"];
        int RowIndex=[rowIndex intValue];
        int ItemIndex=[itemIndex intValue];
        BOOL flipOrNot;
        if([FlipOrNot isEqualToString:@"YES"])
        {
            flipOrNot=YES;
        }
        else
        {
            flipOrNot=NO;
        }
        
        if([ItemName isEqualToString:@"TreasureBox"])
        {
            
            Box *box=[_gridModel getBoxAtLineIndex:(ItemIndex-1) BoxIndex:RowIndex];
            //NSLog(@" Treasurebox, lineIndex:%d boxIndex:%d",(ItemIndex-1),RowIndex);
            box.status=TREASUREBOX;
            [self loadTreasureBoxAtRow:RowIndex ItemIndex:ItemIndex];
            [self loadFogAtRow:RowIndex ItemIndex:ItemIndex];
        }
        
        else if([ItemName isEqualToString:@"Cannon"])
        {
            Box *box=[_gridModel getBoxAtLineIndex:(ItemIndex-1) BoxIndex:RowIndex];
            //  NSLog(@"Cannon, lineIndex:%d boxIndex:%d",(ItemIndex-1),RowIndex);
            box.status=CANNON;
            [self loadCannonAtRow:RowIndex ItemIndex:ItemIndex Flip:flipOrNot];
            [self loadFogAtRow:RowIndex ItemIndex:ItemIndex];
        }
         else if([ItemName isEqualToString:@"Ship"])
        {
            Box *box=[_gridModel getBoxAtLineIndex:(ItemIndex-1) BoxIndex:RowIndex];
             // NSLog(@"Ship lineIndex:%d boxIndex:%d",(ItemIndex-1),RowIndex);
            box.status=SHIP;
         [self loadShipAtRow:RowIndex ItemIndex:ItemIndex Flip:flipOrNot];
         [self loadFogAtRow:RowIndex ItemIndex:ItemIndex];
        }
         else if([ItemName isEqualToString:@"Skull"])
         {
             Box *box=[_gridModel getBoxAtLineIndex:(ItemIndex-1) BoxIndex:RowIndex];
              // NSLog(@"Skull lineIndex:%d boxIndex:%d",(ItemIndex-1),RowIndex);
             box.status=SKULL;
             [self loadSkullAtRow:RowIndex ItemIndex:ItemIndex];
             [self loadFogAtRow:RowIndex ItemIndex:ItemIndex];
         }
         [self updateBoxNumber];
         _gridModel.skullLeft=(int)_gridView.skullArray.count;
    }
    
    NSString *isDecideWhoStart=[infoList objectForKey:@"isDecideWhoStart"];
    NSString *disableOpponnetMove=[infoList objectForKey:@"disableOpponnetMove"];
    
    if([isDecideWhoStart isEqualToString:@"YES"])
    {
        if([disableOpponnetMove isEqualToString:@"YES"])
        {
            _touchEnable=NO;
            _isBlueColor=NO;
            [_gridView blueIsOn];
        }
        else if([disableOpponnetMove isEqualToString:@"NO"]) {
            _touchEnable=YES;
            _isBlueColor=YES;
            [_gridView orangeIsOn];
        }
    }
    
    
    
    
    NSString *isInvation=[infoList objectForKey:@"isInvation"];
    NSString *isReply=[infoList objectForKey:@"isReply"];
    NSString *receiveInvite=[[GameSettings shared] getGlobalForKey:@"receiveInvite"];
    if([isInvation isEqualToString:@"YES"]&&[isReply isEqualToString:@"NO"]&&![receiveInvite isEqualToString:@"NO"])
    {
        NSString *text=[infoList objectForKey:@"Text"];
        NSString *playerName=[infoList objectForKey:@"PlayerName"];
       [[GameSettings shared] setGlobal:playerName ForKey:@"OpponentName"];
        NSString *islandNumber=[infoList objectForKey:@"islandNumber"];
        NSString *levelNumberOnButton=[infoList objectForKey:@"levelnumberOnButton"];
        [[GameSettings shared] setGlobal:islandNumber ForKey:@"island"];
        [[GameSettings shared] setGlobal:levelNumberOnButton ForKey:@"levelNumberOnButton"];
        NSString *levelNumber=[infoList objectForKey:@"LevelNumber"];
        [[GameSettings shared] setGlobal:levelNumber ForKey:@"selectedLevel"];
        AlertView *alert = [[AlertView alloc] initWithTitle:@""
                                                        message:text
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"YES",nil];
        alert.tag=1;
        
        [alert show];
        [alert release];
    }
    else if([isInvation isEqualToString:@"NO"]&&[isReply isEqualToString:@"YES"])
    {
        NSString *answer=[infoList objectForKey:@"answer"];
            [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
        if([answer isEqualToString:@"YES"])
        {
            NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
            NSString *opponentName=[infoList objectForKey:@"PlayerName"];
            NSString *opponentColor=[infoList objectForKey:@"opponentColor"];
            
            if([opponentColor isEqualToString:@"orange"])
            {
                
                
                [[GameSettings shared] setGlobal:opponentName ForKey:@"OrangePlayer"];
                [[GameSettings shared] setGlobal:playerName ForKey:@"BluePlayer"];
                [[GameSettings shared] setGlobal:@"YES" ForKey:@"touchEnable"];
            }
            else if([opponentColor isEqualToString:@"blue"])
            {
                [[GameSettings shared] setGlobal:opponentName ForKey:@"BluePlayer"];
                [[GameSettings shared] setGlobal:playerName ForKey:@"OrangePlayer"];
                [[GameSettings shared] setGlobal:@"NO" ForKey:@"touchEnable"];
            }
            [_waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
            // [myTextField1 removeFromSuperview];
            // [myTextField2 removeFromSuperview];
            CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
            [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[GameLayer scene]]]; 
            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        }
        else {
            [_waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
            
             AlertView *alert = [[AlertView alloc] initWithTitle:@""
             message:@"Seems your opponent doesn't like that level, please select another one."
             delegate:self
             cancelButtonTitle:nil
             otherButtonTitles:@"Okay",nil];
            alert.tag=2;
             [alert show];
             [alert release];
             
        }
    }

}


- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==3)
    {
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
        CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
        [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[MainMenu scene]]];
    }
    
    
    if(alertView.tag==1)
    {
        if (buttonIndex==1) {
            
            NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
            // [[GameSettings shared] setGlobal:playerName ForKey:@"OrangePlayer"];
            //int yesOrNo = arc4random() % 2;
            int yesOrNo=1;
            if(yesOrNo)
            {
                
                [[GameSettings shared] setGlobal: [[GameSettings shared] getGlobalForKey:@"OpponentName"] ForKey:@"BluePlayer"];
                [[GameSettings shared] setGlobal:@"NO" ForKey:@"touchEnable"];
                if([_gameMode isEqualToString:@"blueTooth"])
                {
                    [[GameSettings shared] setGlobal:playerName ForKey:@"OrangePlayer"]; 
                    [self reply:@"YES" AndColor:@"orange"];
                }
                else if([_gameMode isEqualToString:@"network"]) {
                    NSString *playerName2=[[GKLocalPlayer localPlayer] alias];
                    [[GameSettings shared] setGlobal:playerName2 ForKey:@"OrangePlayer"];
                    [self networkReply:@"YES" AndColor:@"orange"];
                }
            }
            else {
                
                [[GameSettings shared] setGlobal:playerName ForKey:@"BluePlayer"]; 
                [[GameSettings shared] setGlobal: [[GameSettings shared] getGlobalForKey:@"OpponentName"] ForKey:@"OrangePlayer"];
                [[GameSettings shared] setGlobal:@"YES" ForKey:@"touchEnable"];
                if([_gameMode isEqualToString:@"blueTooth"])
                {
                    [self reply:@"YES" AndColor:@"blue"];
                }
                else if([_gameMode isEqualToString:@"network"]) {
                    [self networkReply:@"YES" AndColor:@"blue"];
                }
                
            }
            CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
            [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[GameLayer scene]]]; 
            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
            
            
            
        }
    else {
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
        if([_gameMode isEqualToString:@"blueTooth"])
        {
            [self reply:@"NO"];
        }
        else if([_gameMode isEqualToString:@"network"]) {
            [self networkReply:@"NO"];
        }
    }
    }
    else {
         [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
    }
    
}
- (void)match:(GKMatch *)match player:(GKPlayer *)player didChangeState:(GKPlayerConnectionState)state
{
    switch (state)
    {
        case GKPlayerStateUnknown:
            break;
        case GKPlayerStateConnected:
            // handle a new player connection.
            break;
        case GKPlayerStateDisconnected:
            [myMatch disconnect];
            [[GameSettings shared] setGlobal:@"YES" ForKey:@"isHost"];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"BluePlayer"]];
            [[GameSettings shared] setGlobal:@"0" ForKey:[[GameSettings shared] getGlobalForKey:@"OrangePlayer"]];
            [[GameSettings shared] setGlobal:@"solo" ForKey:@"gameMode"];
            AlertView *alert = [[AlertView alloc] initWithTitle:@""
                                                            message:@"The connection with the other player has been lost"
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
             alert.tag=3;
            [alert show];
            [alert release];
            
            break;
             
    }
    
}
- (BOOL)match:(GKMatch *)match shouldReinviteDisconnectedPlayer:(GKPlayer *)player
{
    return NO;
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromRemotePlayer:(GKPlayer *)player
{
    NSData *newData = data;
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:newData];
    NSDictionary *infoList = [unarchiver decodeObjectForKey:@"Data"] ;
    [unarchiver finishDecoding];
    [unarchiver release];
    //[newData release];
    
    
    NSString *isSendingMove=[infoList objectForKey:@"isSendingMove"];
     NSString *isSendingFogInfo=[infoList objectForKey:@"isSendingFogInfo"];
    
    if([isSendingMove isEqualToString:@"YES"])
    {
        NSString *rowOrLine=[infoList objectForKey:@"RowOrLine"];
        NSString *rowOrLineIndex=[infoList objectForKey:@"rowOrLineIndex"];
        NSString *edgeIndex=[infoList objectForKey:@"edgeIndex"];
        NSString *switchOrNot=[infoList objectForKey:@"switchOrNot"];
        NSUInteger _rowOrLineIndex=[rowOrLineIndex integerValue];
        NSUInteger _edgeIndex=[edgeIndex integerValue];
        
        if([switchOrNot isEqualToString:@"YES"])
        {
            _touchEnable=YES;
        }
        else {
            _touchEnable=NO;
        }
        _isReceiving=YES;
        if([rowOrLine isEqualToString:@"row"])
        {
            //_otherPlayerTurn=YES;
            [self drawEdgeAtRowIndex:_rowOrLineIndex EdgeIndex:_edgeIndex];
        }
        
        else if([rowOrLine isEqualToString:@"line"])
        {
            //_otherPlayerTurn=YES;
            [self drawEdgeAtLineIndex:_rowOrLineIndex EdgeIndex:_edgeIndex];
        }
        
        
        _isReceiving=NO;
    }
     if([isSendingFogInfo isEqualToString:@"YES"])
    {
        NSString *rowIndex=[infoList objectForKey:@"RowIndex"];
        NSString *itemIndex=[infoList objectForKey:@"ItemIndex"];
        NSString *FlipOrNot=[infoList objectForKey:@"FlipOrNot"];
        NSString *ItemName=[infoList objectForKey:@"ItemName"];
        int RowIndex=[rowIndex intValue];
        int ItemIndex=[itemIndex intValue];
        BOOL flipOrNot;
        if([FlipOrNot isEqualToString:@"YES"])
        {
            flipOrNot=YES;
        }
        else {
            flipOrNot=NO;
        }
        
        if([ItemName isEqualToString:@"TreasureBox"])
        {
            
            Box *box=[_gridModel getBoxAtLineIndex:(ItemIndex-1) BoxIndex:RowIndex];
            box.status=TREASUREBOX;
            [self loadTreasureBoxAtRow:RowIndex ItemIndex:ItemIndex];
            [self loadFogAtRow:RowIndex ItemIndex:ItemIndex];
        }
        
        else if([ItemName isEqualToString:@"Cannon"])
        {
            Box *box=[_gridModel getBoxAtLineIndex:(ItemIndex-1) BoxIndex:RowIndex];
            box.status=CANNON;
            [self loadCannonAtRow:RowIndex ItemIndex:ItemIndex Flip:flipOrNot];
            [self loadFogAtRow:RowIndex ItemIndex:ItemIndex];
        }
        else if([ItemName isEqualToString:@"Ship"])
        {
            Box *box=[_gridModel getBoxAtLineIndex:(ItemIndex-1) BoxIndex:RowIndex];
            box.status=SHIP;
            [self loadShipAtRow:RowIndex ItemIndex:ItemIndex Flip:flipOrNot];
            [self loadFogAtRow:RowIndex ItemIndex:ItemIndex];
        }
        else if([ItemName isEqualToString:@"Skull"])
        {
            Box *box=[_gridModel getBoxAtLineIndex:(ItemIndex-1) BoxIndex:RowIndex];
            box.status=SKULL;
            [self loadSkullAtRow:RowIndex ItemIndex:ItemIndex];
            [self loadFogAtRow:RowIndex ItemIndex:ItemIndex];
        }
        [self updateBoxNumber];
         _gridModel.skullLeft=(int)_gridView.skullArray.count;
    }
    
    NSString *isDecideWhoStart=[infoList objectForKey:@"isDecideWhoStart"];
    NSString *disableOpponnetMove=[infoList objectForKey:@"disableOpponnetMove"];
    
    if([isDecideWhoStart isEqualToString:@"YES"])
    {
        if([disableOpponnetMove isEqualToString:@"YES"])
        {
            _touchEnable=NO;
            _isBlueColor=NO;
            [_gridView blueIsOn];
        }
        else if([disableOpponnetMove isEqualToString:@"NO"]) {
            _touchEnable=YES;
            _isBlueColor=YES;
            [_gridView orangeIsOn];
        }
    }
    
    
    NSString *isInvation=[infoList objectForKey:@"isInvation"];
    NSString *isReply=[infoList objectForKey:@"isReply"];
    NSString *receiveInvite=[[GameSettings shared] getGlobalForKey:@"receiveInvite"];
    if([isInvation isEqualToString:@"YES"]&&[isReply isEqualToString:@"NO"]&&![receiveInvite isEqualToString:@"NO"])
    {
        NSString *text=[infoList objectForKey:@"Text"];
        NSString *playerName=[infoList objectForKey:@"PlayerName"];
    [[GameSettings shared] setGlobal:playerName ForKey:@"OpponentName"];
        NSString *islandNumber=[infoList objectForKey:@"islandNumber"];
        NSString *levelNumberOnButton=[infoList objectForKey:@"levelnumberOnButton"];
        [[GameSettings shared] setGlobal:islandNumber ForKey:@"island"];
        [[GameSettings shared] setGlobal:levelNumberOnButton ForKey:@"levelNumberOnButton"];
        NSString *levelNumber=[infoList objectForKey:@"LevelNumber"];
        [[GameSettings shared] setGlobal:levelNumber ForKey:@"selectedLevel"];
        AlertView *alert = [[AlertView alloc] initWithTitle:@""
                                                        message:text
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"YES",nil];
        alert.tag=1;
        [alert show];
        [alert release];
    }
    else if([isInvation isEqualToString:@"NO"]&&[isReply isEqualToString:@"YES"])
    {
        [[GameSettings shared] setGlobal:@"YES" ForKey:@"receiveInvite"];
        NSString *answer=[infoList objectForKey:@"answer"];
        
        if([answer isEqualToString:@"YES"])
        {
           // NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
             NSString *playerName=[[GKLocalPlayer localPlayer] alias];
            NSString *opponentName=[infoList objectForKey:@"PlayerName"];
            NSString *opponentColor=[infoList objectForKey:@"opponentColor"];
            
            if([opponentColor isEqualToString:@"orange"])
            {
                
                
                [[GameSettings shared] setGlobal:opponentName ForKey:@"OrangePlayer"];
                [[GameSettings shared] setGlobal:playerName ForKey:@"BluePlayer"];
                [[GameSettings shared] setGlobal:@"YES" ForKey:@"touchEnable"];
            }
            else if([opponentColor isEqualToString:@"blue"])
            {
                [[GameSettings shared] setGlobal:opponentName ForKey:@"BluePlayer"];
                [[GameSettings shared] setGlobal:playerName ForKey:@"OrangePlayer"];
                [[GameSettings shared] setGlobal:@"NO" ForKey:@"touchEnable"];
            }
            [_waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
            // [myTextField1 removeFromSuperview];
            // [myTextField2 removeFromSuperview];
            CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
            [director_ replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:[GameLayer scene]]]; 
            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        }

        else {
            [_waitingAlert dismissWithClickedButtonIndex:-1 animated:YES];
            
             AlertView *alert = [[AlertView alloc] initWithTitle:@""
             message:@"Seems your opponent doesn't like that level, please select another one."
             delegate:self
             cancelButtonTitle:nil
             otherButtonTitles:@"Okay",nil];
            alert.tag=2;
             [alert show];
             [alert release];
             
        }
    }

}
-(void)networkSendMoveToTheOtherPlayer:(NSString *)RowOrLine
                 RowOrLineIndex:(NSUInteger)rowOrLineIndex
                      EdgeIndex:(NSUInteger)edgeIndex
                     switchTurn:(NSString *)switchOrNot

{
    NSString *isSendingMove=@"YES";
    NSString *_rowOrLineIndex=[NSString stringWithFormat:@"%d",rowOrLineIndex];
    NSString *_edgeIndex=[NSString stringWithFormat:@"%d",edgeIndex];
    NSArray *valueArray=[NSArray arrayWithObjects:isSendingMove,RowOrLine,_rowOrLineIndex,_edgeIndex,switchOrNot,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isSendingMove"],[NSString stringWithFormat:@"RowOrLine"], [NSString stringWithFormat:@"rowOrLineIndex"],[NSString stringWithFormat:@"edgeIndex"],[NSString stringWithFormat:@"switchOrNot"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    //[self mySendDataToPeers:data];
    [myMatch sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:nil];
    [data release];
    
}

-(void)networkSendFogInfoToTheOtherPlayer:(int)RowIndex
                         ItemIndex:(int)itemIndex
                         FlipOrNot:(NSString *)FlipOrNot
                          ItemName:(NSString *)ItemName


{
    NSString *isSendingFogInFo=@"YES";
    NSString *_rowIndex=[NSString stringWithFormat:@"%d",RowIndex];
    NSString *_itemIndex=[NSString stringWithFormat:@"%d",itemIndex];
    NSArray *valueArray=[NSArray arrayWithObjects:isSendingFogInFo,_rowIndex,_itemIndex,FlipOrNot,ItemName,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isSendingFogInfo"],[NSString stringWithFormat:@"RowIndex"], [NSString stringWithFormat:@"ItemIndex"],[NSString stringWithFormat:@"FlipOrNot"],[NSString stringWithFormat:@"ItemName"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    [myMatch sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:nil];

    [data release];
    
}
-(void)networkDisableOpponnentMove:(NSString *)yesOrNo
{
    
    NSString *isDecideWhoStart=@"YES";
    NSString *disableOpponnetMove=yesOrNo;
    
    NSArray *valueArray=[NSArray arrayWithObjects:isDecideWhoStart,disableOpponnetMove, nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isDecideWhoStart"],[NSString stringWithFormat:@"disableOpponnetMove"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    
    //data = [str dataUsingEncoding: NSASCIIStringEncoding];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    [myMatch sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:nil];
    [data release];
    
}

-(void)networkReply:(NSString *)yesOrNo
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
    //[self mySendDataToPeers:data];
    [myMatch sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:nil];
    [data release];
    
}
-(void)networkReply:(NSString *)yesOrNo AndColor:(NSString *)color
{
   // NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
    NSString *playerName=[[GKLocalPlayer localPlayer] alias];
    NSString *isInvitation=@"NO";
    NSString *isReply=@"YES";
    
    NSString *answer=yesOrNo;
    NSArray *valueArray=[NSArray arrayWithObjects:isInvitation,isReply,answer,playerName,color,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"isInvation"],[NSString stringWithFormat:@"isReply"],[NSString stringWithFormat:@"answer"],[NSString stringWithFormat:@"PlayerName"],[NSString stringWithFormat:@"opponentColor"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];
    
    //data = [str dataUsingEncoding: NSASCIIStringEncoding];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    [myMatch sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:nil];
    [data release];
    
}
- (void)networkShowMessage:(NSString *)buttonID
{
    NSString *receiveInvite=[[GameSettings shared] getGlobalForKey:@"receiveInvite"];
    if([receiveInvite isEqualToString:@"NO"])
    {
        return;
    }
    
    [[GameSettings shared] setGlobal:@"NO" ForKey:@"receiveInvite"];
   // _receiveInvite=NO;
    
    //NSString *str=@"hellohello";
   // NSString *playerName=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
    NSString *playerName=[[GKLocalPlayer localPlayer] alias];
    NSString *islandNumber=[[GameSettings shared] getGlobalForKey:@"island"];
    NSString *newIslandName=[self getIslandName:islandNumber];
    NSString *levelNumberOnButton=[[GameSettings shared] getGlobalForKey:@"levelNumberOnButton"];
    NSString *invatationText = [NSString stringWithFormat:  @"%@ would like to play %@ level %@", playerName,newIslandName,levelNumberOnButton];
    NSString *levelNumber=buttonID;
    //[[GameSettings shared] setGlobal:playerName ForKey:@"BluePlayer"];
    //[[GameSettings shared] setGlobal:@"YES" ForKey:@"touchEnable"];
    NSString *isInvitation=@"YES";
    NSString *isReply=@"NO";
    NSArray *valueArray=[NSArray arrayWithObjects:playerName,levelNumber,invatationText,isInvitation,isReply,islandNumber,levelNumberOnButton,nil];
    NSArray *keyArray=[NSArray arrayWithObjects:[NSString stringWithFormat:@"PlayerName"], [NSString stringWithFormat:@"LevelNumber"],[NSString stringWithFormat:@"Text"],[NSString stringWithFormat:@"isInvation"],[NSString stringWithFormat:@"isReply"],[NSString stringWithFormat:@"islandNumber"],[NSString stringWithFormat:@"levelnumberOnButton"],nil];
    NSDictionary *infoList=[NSDictionary dictionaryWithObjects:valueArray forKeys:keyArray];

    
    //data = [str dataUsingEncoding: NSASCIIStringEncoding];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:infoList forKey:@"Data"];
    [archiver finishEncoding];
    [archiver release];
    //[self mySendDataToPeers:data];
    [myMatch sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:nil];
    [data release];
}

@end
