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
#import "ChooseLevelMenu.h"
#include <stdlib.h>
#define WAIT_TO_FADE_OUT_TREASUREBOX 2.0
#define WAIT_TO_FADE_OUT_CANNON 1.0
#define WAIT_TO_FADE_OUT_SHIP 2.0

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation GameLayer
@synthesize CPUTurn=_CPUTurn;
@synthesize isNewGame=_isNewGame;
@synthesize gridModel=_gridModel;
@synthesize gridView=_gridView;
@synthesize touchEnable=_touchEnable;
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
		
		
		// ask director the the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
	
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spriteSheet.plist" ];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"background.plist" ];
        // [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"animation.plist"];
        
        _gridModel=[GridModel GridWithNumOfLines:NUM_OF_LINES NumberOfRows:NUM_OF_ROWS];
        _gridView=[GridView gridViewInController:self];
        //_gridView.parentController=self;
        //[self loadEdgeIndicator];
      
            
        
        [self addChild:_gridView];
        
        [self loadTreasureBoxAtRow:1 ItemIndex:3];
        [self loadTreasureBoxAtRow:3 ItemIndex:3];
        [self loadCannonAtRow:2 ItemIndex:4 Flip:NO];
        [self loadCannonAtRow:2 ItemIndex:2 Flip:YES];
        [self loadShipAtRow:0 ItemIndex:5 Flip:NO];
        [self loadShipAtRow:4 ItemIndex:1 Flip:YES];
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        _changeColor=YES;
        _isBlueColor=NO;
        _touchEnable=YES;
        _twoPlayerOnOneDevice=NO;
        _CPUTurn=NO;
        _isNewGame=YES;
        
        
        if(!_twoPlayerOnOneDevice)
        {
            _brain=[CPUBrain instance];
            _brain.grid=self;
        }
        [self schedule:@selector(update:)];
        
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
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}
									   ];

		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
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
{   /*
     _gridView.treasureBox1=[TreasureBox treasureBoxAtPosition:[self generatePositionForTreasureBox]];
     _gridView.treasureBox1.parentGridView=_gridView;
     [_gridView addChild:_gridView.treasureBox1];
     [_gridView.powerUpsArray addObject:_gridView.treasureBox1];
     */
    TreasureBox *box=[TreasureBox treasureBoxAtPosition:[self generatePositionForItem:TREASUREBOX AtRow:rowIndex ItemIndex:edgeIndex]];
    box.parentGridView=_gridView;
    [_gridView addChild:box];
    [_gridView.treasureBoxArray addObject:box];
    
}
-(void)loadCannonAtRow:(int)rowIndex ItemIndex:(int)edgeIndex Flip:(BOOL)flipOrNot
{
    /*
     _gridView.cannon1=[Cannon cannonAtPosition:[self generatePositionForCannon] Flip:NO];
     _gridView.cannon1.parentGridView=_gridView;
     // [_gridView.cannon1.cannonGraphic setFlipX:YES];
     //[_gridView.cannon1.cannonBallGraphic setFlipX:YES];
     [_gridView addChild:_gridView.cannon1];
     */
    Cannon *cannon=[Cannon cannonAtPosition:[self generatePositionForItem:CANNON AtRow:rowIndex ItemIndex:edgeIndex] Flip:flipOrNot];
    cannon.parentGridView=_gridView;
    [_gridView addChild:cannon];
    [_gridView.cannonArray addObject:cannon];
}

-(void)loadShipAtRow:(int)rowIndex ItemIndex:(int)edgeIndex Flip:(BOOL)flipOrNot
{
    /*
     _gridView.cannon1=[Cannon cannonAtPosition:[self generatePositionForCannon] Flip:NO];
     _gridView.cannon1.parentGridView=_gridView;
     // [_gridView.cannon1.cannonGraphic setFlipX:YES];
     //[_gridView.cannon1.cannonBallGraphic setFlipX:YES];
     [_gridView addChild:_gridView.cannon1];
     */
   // Ship *ship=[Ship cannonAtPosition:[self generatePositionForItem:CANNON AtRow:rowIndex ItemIndex:edgeIndex] Flip:flipOrNot];
    Ship *ship=[Ship shipAtPosition:[self generatePositionForItem:SHIP AtRow:rowIndex ItemIndex:edgeIndex ] Flip:flipOrNot];
    ship.parentGridView=_gridView;
    [_gridView addChild:ship];
    [_gridView.shipArray addObject:ship];
}



-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
    if(touchOrigin2.x>ADJUST_X(15) && touchOrigin2.x<ADJUST_X(90) && touchOrigin2.y>ADJUST_Y(445) && touchOrigin2.y<ADJUST_Y(475))
    {
        [self newButtonPressed];
    }
   else if (touchOrigin2.x>ADJUST_X(235) && touchOrigin2.x<ADJUST_X(310) && touchOrigin2.y>ADJUST_Y(445) && touchOrigin2.y<ADJUST_Y(475))
   {
       [self menuButtonPressed];
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
    //[self showEdgeIndicatorAtPosition:touchOrigin2];
     [self checkTouchOnEdgeAtPosition:touchOrigin2];    
        }
    
    
    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if(_touchEnable)
    {
    CGPoint touchOrigin = [touch locationInView:[touch view]];
	CGPoint touchOrigin2 = [[CCDirector sharedDirector] convertToGL:touchOrigin];
   //[self showEdgeIndicatorAtPosition:touchOrigin2];
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
        
        if(!_twoPlayerOnOneDevice &&_CPUTurn)
        {
           // [_brain move:self];
            _touchEnable=NO;
            [_brain move];
        }
        
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
        
        if(!_twoPlayerOnOneDevice &&_CPUTurn)
        {
             //[_brain move:self];
            _touchEnable=NO;
            [_brain move];
        }
        
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
            return [NSString stringWithFormat:@"Graphic_GreenLine.png"];
            
        }
        else {
            _isBlueColor=NO;
            //return [NSString stringWithFormat:@"Graphic_OrangeLine.png"];
            return [NSString stringWithFormat:@"Graphic_GreenLine.png"];
            
        }
    }
    
    else {
        if(_isBlueColor)
        {
            _isBlueColor=YES;
            //return [NSString stringWithFormat:@"Graphic_BlueLine.png"];
            return [NSString stringWithFormat:@"Graphic_GreenLine.png"];
            
        }
        else {
            _isBlueColor=NO;
            // return [NSString stringWithFormat:@"Graphic_OrangeLine.png"];
            return [NSString stringWithFormat:@"Graphic_GreenLine.png"];
            
        }
    }
}


-(void)newButtonPressed
{
   // NSLog(@"newButton Pressed");
    CCAnimation *buttonAnimation=[CCAnimation animation];
    [buttonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_NewGame.png"]];
    [buttonAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Button_NewGame_Pressed.png" ]];
   // id buttonAnimationAction=[CCAnimate actionWithDuration:0.1 animation:buttonAnimation restoreOriginalFrame:YES];
    buttonAnimation.restoreOriginalFrame=YES;
    buttonAnimation.delayPerUnit=0.1/buttonAnimation.frames.count;
        [_gridView.theNewGameButton runAction:[[[CCAnimate alloc] initWithAnimation:buttonAnimation] autorelease]];
    _drawPosition=ccp(0,0);
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
    CCDirectorIOS	*director_= (CCDirectorIOS*) [CCDirector sharedDirector];
    [director_ replaceScene: [ChooseLevelMenu scene]]; 
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
        _changeColor=NO;
        _CPUTurn=NO;
      //  aboveFilled=YES;
        //square above is filled
        CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN+0.5*EDGE_LENGTH;
        CGFloat pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;
        
        
        int blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        int blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        
      Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
        if(box.status==EMPTY_BOX||box.status==TREASUREBOX||box.status==CANNON||box.status==SHIP)
        {
        if(_isBlueColor)
        {
           
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
                
            else
            {
                 box.status=BLUE;
            [_gridView fillBlockAtPositionX:pointX PositionY:pointY WithColor:BLUE_BOX];
            _gridModel.blueScore++;
             [_gridView.blueScoreBox changeScore:1];
            }
            
        }
        else {
             
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
        _changeColor=NO;
        _CPUTurn=NO;
        //square underneath is filled
        CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN-0.5*EDGE_LENGTH;
        CGFloat pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;
        
        int blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        int blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        
        Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
        if(box.status==EMPTY_BOX||box.status==TREASUREBOX||box.status==CANNON||box.status==SHIP)
        {
        if(_isBlueColor)
        {
           
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
        _changeColor=NO;
        _CPUTurn=NO;
      //  LeftFilled=YES;
        //square left is filled
        CGFloat pointX=edgeIndex * EDGE_LENGTH + X_MARGIN - 0.5 * EDGE_LENGTH;
        CGFloat pointY=lineIndex * EDGE_LENGTH + Y_MARGIN + 0.5 * EDGE_LENGTH;
        
        int blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        int blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        
        Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
        if(box.status==EMPTY_BOX||box.status==TREASUREBOX||box.status==CANNON||box.status==SHIP)
        {
        if(_isBlueColor)
        {
           
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

            else {
                box.status=BLUE;

           // [_gridView blueBlockAtPositionX:pointX PositionY:pointY];
             [_gridView fillBlockAtPositionX:pointX PositionY:pointY WithColor:BLUE_BOX];
               
            _gridModel.blueScore++;
            [_gridView.blueScoreBox changeScore:1];
            }
                     }
        else {
            
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
        _changeColor=NO;
        _CPUTurn=NO;
        //square right is filled
        CGFloat pointX=edgeIndex * EDGE_LENGTH + X_MARGIN + 0.5 * EDGE_LENGTH;
        CGFloat pointY=lineIndex * EDGE_LENGTH + Y_MARGIN + 0.5 * EDGE_LENGTH;
        
        int blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        int blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
        
        Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
        
        if(box.status==EMPTY_BOX||box.status==TREASUREBOX||box.status==CANNON||box.status==SHIP)
        {
        if(_isBlueColor)
        {
           
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
    [self showPlayerTurnInfo];
}

-(BOOL)checkWinner
{
    BOOL hasWinner=NO;
    int i= [_gridView.treasureBoxArray count];
    int totalScore=i*4+25-_gridModel.damageCount;
    NSLog(@"total score is%d",totalScore);
    if((_gridModel.blueScore+_gridModel.orangeScore)==totalScore)
    {
        hasWinner=YES;
        if(_gridModel.blueScore>_gridModel.orangeScore)
        {
            [_gridView.lable setString:[NSString stringWithFormat:@"You Won!"]];
            
        }
        else {
            [_gridView.lable setString:[NSString stringWithFormat:@"CPU Won!"]];
        }
        //[self newGame];
        _touchEnable=YES;
        _isNewGame=YES;
        
    }
    return hasWinner;
}

-(void)newGame
{
    /*
    [_gridView.edgeLayer removeAllChildrenWithCleanup:YES];
    [_gridView.blockLayer removeAllChildrenWithCleanup:YES];
    [_gridView.orangeScoreBox reset];
    [_gridView.blueScoreBox reset];
    //[_gridView removeChild:_gridView.treasureBox1 cleanup:YES];
    for(TreasureBox *obj in _gridView.treasureBoxArray)
    {
        [_gridView removeChild:obj cleanup:YES];
    }
    
    for(Cannon *obj in _gridView.cannonArray)
    {
        [_gridView removeChild:obj cleanup:YES];
    }
    //[_gridView removeChild:_gridView.cannon1 cleanup:YES];
   */
        /*
    _gridModel.blueScore=0;
    _gridModel.orangeScore=0;
    _gridModel.damageCount=0;
     */
   // _gridView.waitToPlayTreasureBoxAnimation=0.3;
    //_gridView.treasureBox1.waitToPlayTreasureBoxAnimation=0.3;
  
    /*
    [_gridView.lable setString:[NSString stringWithFormat:@"Please Start"]];
    _gridView.edgeIndicator =[CCSprite spriteWithSpriteFrameName:[self getEdgeIndicatorColor]];
    [_gridView.edgeIndicator setVisible:NO];
    [_gridView.lastEdge setVisible:NO];
    
    [_gridView.edgeLayer addChild:_gridView.edgeIndicator];
    [_gridView.treasureBoxArray removeAllObjects];
    [_gridView.cannonArray removeAllObjects];
    [_gridView.boxArray removeAllObjects];
     */
    /*
    for(EdgeArray *array in _gridModel.lines)
    {
        for(Edge *edge in array)
        {
            edge.isFilled=NO;
        }
    }
    
    for(EdgeArray *array in _gridModel.rows)
    {
        for(Edge *edge in array)
        {
            edge.isFilled=NO;
        }
    }
    
    for(BoxArray *array in _gridModel.boxs)
    {
        for(Box *box in array)
        {
            box.status=EMPTY_BOX;
        }
    }
    */
    [_gridView resetView];
    [_gridModel resetModel];
    _changeColor=YES;
    _isBlueColor=NO;
    _touchEnable=YES;
    [self loadTreasureBoxAtRow:1 ItemIndex:3];
    [self loadTreasureBoxAtRow:3 ItemIndex:3];
    [self loadCannonAtRow:2 ItemIndex:4 Flip:NO];
    [self loadCannonAtRow:2 ItemIndex:2 Flip:YES];
     [self loadShipAtRow:0 ItemIndex:5 Flip:NO];
     [self loadShipAtRow:4 ItemIndex:1 Flip:YES];
   }

- (void)showPlayerTurnInfo
{
    if(_changeColor&&_isBlueColor)
    {
        
        [_gridView.lable setString:[NSString stringWithFormat:@"CPU's Turn"]];
        
    }
    else if (_changeColor &&!_isBlueColor)
    {
        [_gridView.lable setString:[NSString stringWithFormat:@"Your Turn"]];
    }
    
    else if(!_changeColor && _isBlueColor){
        [_gridView.lable setString:[NSString stringWithFormat:@"Your Turn"]];
        [self checkWinner];
    }
    else if (!_changeColor &&!_isBlueColor)
    {
        [_gridView.lable setString:[NSString stringWithFormat:@"CPU's Turn"]];
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
    
    //int rowIndex =( arc4random() % 4) + 1;
    //int edgeIndex = (arc4random() % 5) + 1;                      
    //int rowIndex=2;
    //int edgeIndex=3;
    CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN-0.5*EDGE_LENGTH;
    CGFloat pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;
    int blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    
    Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
    box.status=boxInfor;
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
    /*
    while(pointX==_gridView.treasureBox1.boxPosition.x&&pointX==_gridView.treasureBox1.boxPosition.x)
    {
        int rowIndex =( arc4random() % 4) + 1;
        int edgeIndex = (arc4random() % 5) + 1;                      
       
       pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN-0.5*EDGE_LENGTH;
       pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;
         
    }
    int blockLineIndex=(pointY-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int blockBoxIndex=(pointX-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    
    Box *box=  [_gridModel getBoxAtLineIndex:blockLineIndex BoxIndex:blockBoxIndex];
    box.status=CANNON;

   CGPoint point=ccp(pointX,pointY);
    
    return point;
     */
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

-(void)blueOpenedTreasureBox:(CGPoint)point
{
    
    TreasureBox *box=[_gridView getTreasureBoxAtPosition:point];
    box.waitToPlayTreasureBoxAnimation=0;
    [box playOpenAnimation];
    box.waitToFadeOutTreasureBoxBlue=WAIT_TO_FADE_OUT_TREASUREBOX;
    
    
    //_gridView.waitToPlayTreasureBoxAnimation=0;
    
    /*
    _gridView.treasureBox1.waitToPlayTreasureBoxAnimation=0;
    [_gridView.treasureBox1 playOpenAnimation];
   // _gridView.waitToFadeOutTreasureBoxBlue=WAIT_TO_FADE_OUT_TREASUREBOX;
     _gridView.treasureBox1.waitToFadeOutTreasureBoxBlue=WAIT_TO_FADE_OUT_TREASUREBOX;
     */
    _gridModel.blueScore=_gridModel.blueScore+5;
    [_gridView.blueScoreBox changeScore:5];
    [_gridView showMessageBoxForTreasureBox];
}

-(void)orangeOpenedTresureBox:(CGPoint)point
{
    
    TreasureBox *box=[_gridView getTreasureBoxAtPosition:point];
    box.waitToPlayTreasureBoxAnimation=0;
    [box playOpenAnimation];
    box.waitToFadeOutTreasureBoxOrange=WAIT_TO_FADE_OUT_TREASUREBOX;

    
    //_gridView.waitToPlayTreasureBoxAnimation=0;
    /*
    _gridView.treasureBox1.waitToPlayTreasureBoxAnimation=0;
    [_gridView.treasureBox1 playOpenAnimation];
    _gridView.treasureBox1.waitToFadeOutTreasureBoxOrange=WAIT_TO_FADE_OUT_TREASUREBOX;
    */
    _gridModel.orangeScore=_gridModel.orangeScore+5;
    [_gridView.orangeScoreBox changeScore:5];
    [_gridView showMessageBoxForTreasureBox];
}

-(void)blueCannonBallShoot:(CGPoint)point
{
    Cannon *cannon=[_gridView getCannoAtPosition:point];
    [cannon playCannonShootingAnimation];
   // [cannon playCannonMovingAnimation];
    cannon.waitToFadeOutCannonBlue=WAIT_TO_FADE_OUT_CANNON;
    /*
    [_gridView.cannon1 playCannonShootingAnimation];
    [_gridView.cannon1 playCannonMovingAnimation];
    _gridView.cannon1.waitToFadeOutCannonBlue=WAIT_TO_FADE_OUT_CANNON;
     */
    _gridModel.blueScore=_gridModel.blueScore+1;
    [_gridView.blueScoreBox changeScore:1];
    [self cannonDamage:cannon.cannonPosition];


}

-(void)orangeCannonBallShoot:(CGPoint)point
{
    Cannon *cannon=[_gridView getCannoAtPosition:point];
    [cannon playCannonShootingAnimation];
    //[cannon playCannonMovingAnimation];
    cannon.waitToFadeOutCannonOrange=WAIT_TO_FADE_OUT_CANNON;
    /*
    [_gridView.cannon1 playCannonShootingAnimation];
    [_gridView.cannon1 playCannonMovingAnimation];
     _gridView.cannon1.waitToFadeOutCannonOrange=WAIT_TO_FADE_OUT_CANNON;
     */
    _gridModel.orangeScore=_gridModel.orangeScore+1;
    [_gridView.orangeScoreBox changeScore:1];
    [self cannonDamage:cannon.cannonPosition];

}
-(void)blueShipMoving:(CGPoint)point
{
    Ship *ship=[_gridView getShipAtPosition:point];
    [ship moveShip];
    ship.waitToPlayShipAnimation=0;
    [ship playShipFastAnimation];
    ship.waitToFadeOutShipBlue=WAIT_TO_FADE_OUT_SHIP;
    /*
     [_gridView.cannon1 playCannonShootingAnimation];
     [_gridView.cannon1 playCannonMovingAnimation];
     _gridView.cannon1.waitToFadeOutCannonBlue=WAIT_TO_FADE_OUT_CANNON;
     */
    _gridModel.blueScore=_gridModel.blueScore+1;
    [_gridView.blueScoreBox changeScore:1];
    [self shipTakingOver:ship.shipPosition];
    //[self cannonDamage:cannon.cannonPosition];
    
    
}

-(void)orangeShipMoving:(CGPoint)point
{
    Ship *ship=[_gridView getShipAtPosition:point];
    [ship moveShip];
    ship.waitToPlayShipAnimation=0;
    [ship playShipFastAnimation];
    ship.waitToFadeOutShipOrange=WAIT_TO_FADE_OUT_SHIP;
    /*
     [_gridView.cannon1 playCannonShootingAnimation];
     [_gridView.cannon1 playCannonMovingAnimation];
     _gridView.cannon1.waitToFadeOutCannonBlue=WAIT_TO_FADE_OUT_CANNON;
     */
    _gridModel.orangeScore=_gridModel.orangeScore+1;
    [_gridView.orangeScoreBox changeScore:1];
    [self shipTakingOver:ship.shipPosition];
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
            int itemIndex=[array indexOfObject:obj];
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
                int itemIndex=[array indexOfObject:obj];
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
        /*
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
        */
    }
    else
    {
        float distance=(float)(boxIndex+1)/NUM_OF_ROWS;
        NSMutableArray *array= [_gridModel.boxs objectAtIndex:lineIndex];
        if(boxAttacking.status==BLUE)
        {
            for(Box *obj in array)
            {
                int itemIndex=[array indexOfObject:obj];
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
                int itemIndex=[array indexOfObject:obj];
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

        /*
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
         */
        
    }
    
}


                            
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}




#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
