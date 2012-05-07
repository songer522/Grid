//
//  GridView.m
//  Grid
//
//  Created by Yang Song on 4/20/12.
//  Copyright 2012 XecuDev. All rights reserved.
//

#import "GridView.h"
#import "DeviceSettings.h"
#import "Edge.h"
#import "MapSettings.h"
#import "BoxIcon.h"
#import "EdgeGraphic.h"
#import "Ship.h"
#import "TreasureBox.h"
#import "Cannon.h"
#import "GameLayer.h"


@implementation GridView
@synthesize edgeIndicator=_edgeIndicator;
@synthesize lable=_lable;
@synthesize edgeLayer=_edgeLayer;
@synthesize blockLayer=_blockLayer;
@synthesize orangeScoreBox=_orangeScoreBox;
@synthesize blueScoreBox=_blueScoreBox;
@synthesize menuButton=_menuButton;
@synthesize theNewGameButton=_theNewGameButton;
@synthesize secondBoxPositionX=_secondBoxPositionX;
@synthesize secondBoxPositionY=_secondBoxPositionY;
@synthesize waitToShowSecondBoxBlue=_waitToShowSecondBoxBlue;
@synthesize waitToShowSecondBoxOrange=_waitToShowSecondBoxOrange;
@synthesize treasureBoxArray=_treasureBoxArray;
@synthesize cannonArray=_cannonArray;
@synthesize boxArray=_boxArray;
@synthesize edgeArray=_edgeArray;
@synthesize shipArray=_shipArray;
@synthesize parentController=_parentController;
//@synthesize waitToFadeOutTreasureBoxBlue=_waitToFadeOutTreasureBoxBlue;
//@synthesize waitToFadeOutTreasureBoxOrange=_waitToFadeOutTreasureBoxOrange;
//@synthesize waitToPlayTreasureBoxAnimation=_waitToPlayTreasureBoxAnimation;
//@synthesize waitToFadeOutCannonBlue=_waitToFadeOutCannonBlue;
//@synthesize waitToFadeOutCannonOrange=_waitToFadeOutCannonOrange;
@synthesize lastEdge=_lastEdge;
@synthesize dots=_dots;
//@synthesize treasureBox1=_treasureBox1;
//@synthesize cannon1=_cannon1;

+(id)gridViewInController:(id)controller
{
    return [[self alloc] initInController:controller];
}

-(id)initInController:(id)controller
{
    if ((self=[super init])) {
        _parentController=controller;
        _background=[CCSprite spriteWithSpriteFrameName:@"Graphic_Background.png"];
        [_background setPosition:ADJUST_CCP(ccp(160,240))];
        //[_background setScale:0.5];
        
        _dashLines=[CCLayer node];        
        _dots=[CCLayer node];
        
        [self loadDots];
        [self loadDashLines];
        
        _waitToShowBox=0;
       // _waitToPlayTreasureBoxAnimation=0.3;
       // _waitToFadeOutTreasureBoxBlue=0;
        //_waitToFadeOutTreasureBoxOrange=0;
        
        _lable=[CCLabelTTF labelWithString:@"Please Start" fontName:@"Marker Felt" fontSize: HD_TEXT(24)];
        [_lable setColor:ccBLACK];
        _lable.position=ADJUST_CCP(ccp(160,420)) ;
        
        _edgeLayer=[CCLayer node];
        _blockLayer=[CCLayer node];
        
        _blueScoreBox=[ScoreBox ScoreBoxWithImage:@"Graphic_BlueScore.png" andPosition:ADJUST_CCP(ccp(50,70))]; 
        _orangeScoreBox=[ScoreBox ScoreBoxWithImage:@"Graphic_OrangeScore.png" andPosition:ADJUST_CCP(ccp(270,70))];
        
        _theNewGameButton=[CCSprite spriteWithSpriteFrameName:@"Button_NewGame.png"];
        _menuButton=[CCSprite spriteWithSpriteFrameName:@"Button_Menu.png"];
        
        [_theNewGameButton setPosition:ADJUST_CCP(ccp(50,460))];
        [_menuButton setPosition:ADJUST_CCP(ccp(270,460))];
        _window=[GameWindow GameWindowWithImage:@"Graphic_TBox_1.png" text:@"Treasure Points" andPosition:ADJUST_CCP(ccp(160,70))];
        [_window setOpacity:0];  
       
        
      //CCTMXTiledMap  *tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"story_hard_level3.tmx"];
        
        
        //[tileMap setPosition:ADJUST_CCP(ccp(160,240))];
       // _powerUpsArray=[NSMutableArray arrayWithObjects:_treasureBox1, nil];

        
        _treasureBoxArray=[[NSMutableArray alloc] init ];
        _cannonArray=[[NSMutableArray alloc] init];
        _boxArray=[[NSMutableArray alloc] init];
        _edgeArray=[[NSMutableArray alloc] init];
        _shipArray=[[NSMutableArray alloc] init];
        [self addChild:_background];
        //[self addChild:tileMap];
        [self addChild:_dashLines];
        [self addChild:_blockLayer];
        [self addChild:_edgeLayer];
        [self addChild:_dots];
        [self addChild:_lable];
        [self addChild:_blueScoreBox];
        [self addChild:_orangeScoreBox];
        [self addChild:_menuButton];
        [self addChild:_theNewGameButton];
         [self addChild:_window];
               
        [self loadEdgeIndicator];
    }
    return self;
}

-(void)loadDots
{
    for(int positionX = X_MARGIN; positionX< X_BOUNDARY_RIGHT; positionX=positionX+EDGE_LENGTH )
    {
        for (int positionY= Y_MARGIN; positionY<Y_BOUNDARY_TOP; positionY=positionY+EDGE_LENGTH) {
            CCSprite *dot=[CCSprite spriteWithSpriteFrameName:@"Graphic_Dot.png"];
            [dot setPosition:ccp(positionX,positionY)];
            [_dots addChild:dot];
        }
    }
    
     _lastEdge=[EdgeGraphic spriteWithSpriteFrameName:@"Graphic_Dot.png"];
    [_lastEdge setPosition:ADJUST_CCP(ccp(0,0))];
    [_lastEdge setVisible:NO];
     [_dots addChild:_lastEdge];
     
}

-(void)loadDashLines
{
    for(int positionX = X_MARGIN+0.5*EDGE_LENGTH; positionX< X_BOUNDARY_RIGHT; positionX=positionX+EDGE_LENGTH )
    {
        for (int positionY= Y_MARGIN; positionY<Y_BOUNDARY_TOP; positionY=positionY+EDGE_LENGTH) {
            CCSprite *dot=[CCSprite spriteWithSpriteFrameName:@"Graphic_HelpLine.png"];
            [dot setPosition:ccp(positionX,positionY)];
            [_dashLines addChild:dot];
        }
    }
    
    for(int positionX = X_MARGIN; positionX< X_BOUNDARY_RIGHT; positionX=positionX+EDGE_LENGTH )
    {
        for (int positionY= Y_MARGIN+0.5*EDGE_LENGTH; positionY<Y_BOUNDARY_TOP; positionY=positionY+EDGE_LENGTH) {
            CCSprite *dot=[CCSprite spriteWithSpriteFrameName:@"Graphic_HelpLine.png"];
            dot.rotation=90;
            [dot setPosition:ccp(positionX,positionY)];
            [_dashLines addChild:dot];
        }
    }
}

- (void)loadEdgeIndicator
{
    _edgeIndicator =[CCSprite spriteWithSpriteFrameName:[_parentController getEdgeColor]];
    [_edgeIndicator setVisible:NO]; 
    _edgeIndicator =[CCSprite spriteWithSpriteFrameName:[_parentController getEdgeColor]];
    [_edgeIndicator setVisible:NO]; 
    [_edgeLayer addChild:_edgeIndicator];
    
    
}
- (id)getTreasureBoxAtPosition:(CGPoint)point
{
    for(TreasureBox *obj in _treasureBoxArray)
    {
        if (obj.boxPosition.x==point.x && obj.boxPosition.y==point.y) 
        {
            return obj;
        }
            
    }
    NSLog(@"Treasure Box not found!");
    return nil;
    
}

- (id)getCannoAtPosition:(CGPoint)point
{
    for(Cannon *obj in _cannonArray)
    {
        if (obj.cannonPosition.x==point.x && obj.cannonPosition.y==point.y) 
        {
            return obj;
        }
        
    }
    NSLog(@"cannon not found!");
    return nil;
    
}
- (id)getShipAtPosition:(CGPoint)point
{
    for(Ship *obj in _shipArray)
    {
        if (obj.shipPosition.x==point.x && obj.shipPosition.y==point.y) 
        {
            return obj;
        }
        
    }
    NSLog(@"ship not found!");
    return nil;
    
}

-(id)getBoxAtPosition:(CGPoint)point
{
    for(BoxIcon *obj in _boxArray)
    {
       if (obj.position.x==point.x&&obj.position.y==point.y)
       {
           return obj;
       }
    }
    
    NSLog(@"box not found!");
    return nil;
}

-(CGPoint)getBoxPositionAt:(Direction)direction From:(CGPoint)point
{
    CGPoint newPoint=point;
    if(direction==LEFT)
    {
        newPoint.x=newPoint.x-EDGE_LENGTH;
    }
    else {
        newPoint.x=newPoint.x+EDGE_LENGTH;
    }
    return newPoint;
}

-(CGPoint)getItemPositionAtRowIndex:(int)rowIndex ItemIndex:(int)edgeIndex
{
    CGFloat pointY= rowIndex * EDGE_LENGTH + Y_MARGIN+0.5*EDGE_LENGTH;
    CGFloat pointX=0.5*EDGE_LENGTH+edgeIndex*EDGE_LENGTH+X_MARGIN;
    CGPoint point=ccp(pointX,pointY);
    return point;
}

- (void)showMessageBoxForTreasureBox
{
    
    _window.waitToFadeInTreasureBoxMessageBox=1.0;
}


-(void)fillBlockAtPositionX:(CGFloat)positionX 
                  PositionY:(CGFloat)positionY
                  WithColor:(BoxColor)color
{
    if(positionX >X_BOUNDARY_LEFT && positionX < X_BOUNDARY_RIGHT && positionY > Y_BOUNDARY_BOTTOM && positionY < Y_BOUNDARY_TOP)
    {
       // NSLog(@"block positionX: %f  positionY: %f",positionX,positionY);
                if(color==BLUE_BOX)
                {
                
                BoxIcon *block=[BoxIcon spriteWithSpriteFrameName:@"Graphic_BlueBox.png"];
                
                [block setScale:0];
                [block setPosition:ccp(positionX,positionY)];
                [_blockLayer addChild:block];
                    [_boxArray addObject:block];
                //tempSprite=block;
                    
                //_waitToShowBox=0.2;
                    block.waitToShowBox=0.4;
                }
                
                else if(color==ORANGE_BOX)
                {
                    BoxIcon *block=[BoxIcon spriteWithSpriteFrameName:@"Graphic_OrangeBox.png"];
                    
                    [block setScale:0];
                    [block setPosition:ccp(positionX,positionY)];
                    [_blockLayer addChild:block];
                    [_boxArray addObject:block];
                    //tempSprite=block;
                   // _waitToShowBox=0.2;
                    block.waitToShowBox=0.4;
                }
        }
       
       
        
        
        
    
}




-(void)drawEdgeAtPosition:(CGPoint)point 
                           AndColor:(NSString *)edgeColor
                           Vertical:(BOOL)isVertical
{
    EdgeGraphic *edge=[EdgeGraphic spriteWithSpriteFrameName:edgeColor];
    [edge setScale:0];
    [edge setPosition:point];
    [_lastEdge setScale:0];
    [_lastEdge setPosition:point];
   
    if(isVertical)
    {
        edge.rotation=90;
        _lastEdge.rotation=90;
       
    }
    else {
        _lastEdge.rotation=0;
      
    }
    [_lastEdge setVisible:YES];
    _lastEdge.waitToShowEdge=0.2;
    
    [_edgeArray addObject:edge];
    [_edgeLayer addChild:edge];
    edge.waitToShowEdge=0.2;
}

-(void)drawEdgeIndicatorAtPosition:(CGPoint)point
                 Vertical:(BOOL)isVertical
{
    [_edgeIndicator setVisible:YES];
    [_edgeIndicator setPosition:point];
    if(isVertical)
    {
        _edgeIndicator.rotation=90;
    }
    else {
        _edgeIndicator.rotation=0;
    }
    
}

- (void)resetView
{
    [_edgeLayer removeAllChildrenWithCleanup:YES];
    [_blockLayer removeAllChildrenWithCleanup:YES];
    [_orangeScoreBox reset];
    [_blueScoreBox reset];
    //[_gridView removeChild:_gridView.treasureBox1 cleanup:YES];
    for(TreasureBox *obj in _treasureBoxArray)
    {
        [self removeChild:obj cleanup:YES];
    }
    
    for(Cannon *obj in _cannonArray)
    {
        [self removeChild:obj cleanup:YES];
    }
    for(Ship *obj in _shipArray)
    {
        [self removeChild:obj cleanup:YES];
    }
    for(BoxIcon *obj in _boxArray)
    {
        [self removeChild:obj cleanup:YES];
    }
    //[_gridView removeChild:_gridView.cannon1 cleanup:YES];
    
    
    // _gridView.waitToPlayTreasureBoxAnimation=0.3;
    //_gridView.treasureBox1.waitToPlayTreasureBoxAnimation=0.3;
   
    [_lable setString:[NSString stringWithFormat:@"Please Start"]];
    _edgeIndicator =[CCSprite spriteWithSpriteFrameName:[_parentController getEdgeIndicatorColor]];
    [_edgeIndicator setVisible:NO];
    [_lastEdge setVisible:NO];
    
    [_edgeLayer addChild:_edgeIndicator];
    [_treasureBoxArray removeAllObjects];
    [_cannonArray removeAllObjects];
    [_boxArray removeAllObjects];
    [_edgeArray removeAllObjects];
    [_shipArray removeAllObjects];
}
- (void)update:(ccTime)dt {
    /*
    if(_waitToShowBox>0)
    {
        _waitToShowBox=_waitToShowBox-dt;
        [tempSprite setScale:(1-5*_waitToShowBox)];
        if(_waitToShowBox<0)
        {
            [tempSprite setScale:1];
        }
    }
    */
    /*
    
    
    if(_waitToShowSecondBoxBlue>0)
    {
        _waitToShowSecondBoxBlue=_waitToShowSecondBoxBlue-dt;
        if(_waitToShowSecondBoxBlue<0)
        {
            
            //[self blueBlockAtPositionX:_secondBoxPositionX PositionY:_secondBoxPositionY];
            [self fillBlockAtPositionX:_secondBoxPositionX PositionY:_secondBoxPositionY WithColor:BLUE_BOX];
        }
    }
    
    if(_waitToShowSecondBoxOrange>0)
    {
        _waitToShowSecondBoxOrange=_waitToShowSecondBoxOrange-dt;
        if(_waitToShowSecondBoxOrange<0)
        {
            
            //[self orangeBlockAtPositionX:_secondBoxPositionX PositionY:_secondBoxPositionY];
             [self fillBlockAtPositionX:_secondBoxPositionX PositionY:_secondBoxPositionY WithColor:ORANGE_BOX];
        }
    }
     */
    //[_treasureBox1 update:dt];
    //[_cannon1 update:dt];
    for (BoxIcon *obj in _boxArray)
    {
        [obj update:dt];
    }
    [_window update:dt];
    
    for(TreasureBox *obj in _treasureBoxArray)
    {
        [obj update:dt];
    }
    
    for(Cannon *obj in _cannonArray)
    {

        [obj update:dt];
    }
    
    for(Ship *obj in _shipArray)
    {
        [obj update:dt];
    }
    for (EdgeGraphic *obj in _edgeArray)
    {
        [obj update:dt];
    }
    
    [_lastEdge update:dt];
    
    
    
    /*
    if(_waitToPlayTreasureBoxAnimation>0)
    {
        _waitToPlayTreasureBoxAnimation=_waitToPlayTreasureBoxAnimation-dt;
        if(_waitToPlayTreasureBoxAnimation<0)
        {
            [_treasureBox1 playHalfOpenAnimation];
            _waitToPlayTreasureBoxAnimation=2.0;
        }
    }
    
    if(_waitToFadeOutTreasureBoxBlue>0)
    {
        _waitToFadeOutTreasureBoxBlue=_waitToFadeOutTreasureBoxBlue-dt;
       
       if(_waitToFadeOutTreasureBoxBlue<0.5&&_waitToFadeOutTreasureBoxBlue>0)
       {
            [_treasureBox1.boxGraphic setOpacity:_waitToFadeOutTreasureBoxBlue*510];
       }
        if(_waitToFadeOutTreasureBoxBlue<0)
        {
            //[_treasureBox1 setVisible:NO];
            // NSLog(@"opacity%c",_treasureBox1.boxGraphic.opacity);
            [_treasureBox1.boxGraphic setOpacity:0];
            [self fillBlockAtPositionX:_treasureBox1.boxPosition.x PositionY:_treasureBox1.boxPosition.y WithColor:BLUE_BOX];
            
        }
    }
    
    if(_waitToFadeOutTreasureBoxOrange>0)
    {
        _waitToFadeOutTreasureBoxOrange=_waitToFadeOutTreasureBoxOrange-dt;
        
        
        if(_waitToFadeOutTreasureBoxOrange<0.5 && _waitToFadeOutTreasureBoxOrange>0)
        {
            [_treasureBox1.boxGraphic setOpacity:_waitToFadeOutTreasureBoxOrange*510];
        }
        
        if(_waitToFadeOutTreasureBoxOrange<0)
        {
            //[_treasureBox1 setVisible:NO];
            //NSLog(@"opacity%c",_treasureBox1.boxGraphic.opacity);
              [_treasureBox1.boxGraphic setOpacity:0];
            [self fillBlockAtPositionX:_treasureBox1.boxPosition.x PositionY:_treasureBox1.boxPosition.y WithColor:ORANGE_BOX];
            
        }
    }
    */
    /*
    if(_waitToFadeOutCannonBlue>0)
    {
        _waitToFadeOutCannonBlue=_waitToFadeOutCannonBlue-dt;
        
        
        if(_waitToFadeOutCannonBlue<2 && _waitToFadeOutCannonBlue>1.0)
        {
            [_cannon1.cannonGraphic setOpacity:(_waitToFadeOutCannonBlue-1.0)*255];
            [_cannon1.cannonBallGraphic setOpacity:(_waitToFadeOutCannonBlue-1.0)*255];
        }
        
        if(_waitToFadeOutCannonBlue<0)
        {
            [_cannon1.cannonGraphic setOpacity:0];
            [_cannon1.cannonBallGraphic setOpacity:0];
             [self fillBlockAtPositionX:_cannon1.cannonPosition.x PositionY:_cannon1.cannonPosition.y WithColor:BLUE_BOX];
        }
    }
    
    if(_waitToFadeOutCannonOrange>0)
    {
        _waitToFadeOutCannonOrange=_waitToFadeOutCannonOrange-dt;
        
        if(_waitToFadeOutCannonOrange<2 && _waitToFadeOutCannonOrange>1.0)
        {
            [_cannon1.cannonGraphic setOpacity:(_waitToFadeOutCannonOrange-1.0)*255];
            [_cannon1.cannonBallGraphic setOpacity:(_waitToFadeOutCannonOrange-1.0)*255];
        }
        
        if(_waitToFadeOutCannonOrange<0)
        {
            [_cannon1.cannonGraphic setOpacity:0];
            [_cannon1.cannonBallGraphic setOpacity:0];
            [self fillBlockAtPositionX:_cannon1.cannonPosition.x PositionY:_cannon1.cannonPosition.y WithColor:ORANGE_BOX];
        }
    }
    */
    /*
    if(_waitToFadeInTreasureBoxMessageBox>0)
    {
        _waitToFadeInTreasureBoxMessageBox=_waitToFadeInTreasureBoxMessageBox-dt;
        [_window setOpacity:(1.0-_waitToFadeInTreasureBoxMessageBox)*255]; 
        if(_waitToFadeInTreasureBoxMessageBox<0)
        {
            [_window setOpacity:255];
            _window.waitToFadeOutTreasureBoxMessageBox=3.0;
        }
    }
    
    if(_waitToFadeOutTreasureBoxMessageBox>0)
    {
        _waitToFadeOutTreasureBoxMessageBox=_waitToFadeOutTreasureBoxMessageBox-dt;
        if(_waitToFadeOutTreasureBoxMessageBox<0.5 && _waitToFadeOutTreasureBoxMessageBox>0)
        {
            [_window setOpacity:_waitToFadeOutTreasureBoxMessageBox*510];
        }
        
        if(_waitToFadeOutTreasureBoxMessageBox<0)
        {
            [_window setOpacity:0];
        }
        
    }
     */
}
/*
 -(void)drawEdgeIndicatorAtRowIndex:(NSInteger)rowIndex EdgeIndex:(NSInteger)edgeIndex
 {
 Edge *edge= [self getEdgeAtRowIndex:rowIndex EdgeIndex:edgeIndex];
 if(![edge checkFiled])
 {
 //fill the edge
 NSLog(@"edge touched at row %d, number %d, an edge is drew",rowIndex,edgeIndex);
 
 //[touchPoint setScale:0.5];
 _edgeIndicator.rotation=0;
 CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN;
 // CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN-0.5*EDGE_LENGTH;
 CGFloat pointX=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;
 //CGFloat pointX=rowIndex*EDGE_LENGTH+X_MARGIN;
 
 [_edgeIndicator setPosition:ccp(pointX,pointY)];
 [_edgeIndicator setVisible:YES];
 
 //_changeColor=YES;
 
 } 
 else {
 //[_lable setString:[NSString stringWithFormat:@"edge touched at row %d, number %d, the edge has been drew",rowIndex,edgeIndex]];
 }   
 }
 
 
 
 -(void)drawEdgeIndicatorAtLineIndex:(NSInteger)lineIndex EdgeIndex:(NSInteger)edgeIndex
 {
 Edge *edge= [self getEdgeAtLineIndex:lineIndex EdgeIndex:edgeIndex];
 if(![edge checkFiled])
 {
 //fill the edge
 
 NSLog(@"edge touched at row %d, number %d, an edge is drew",lineIndex,edgeIndex);
 //NSLog(@"an edge is drew");
 //[_lable setString:[NSString stringWithFormat:@"edge touched at line %d, number %d, an edge is drew",lineIndex,edgeIndex]];
 
 // [_edgeIndicator setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[self getEdgeColor]]];
 _edgeIndicator.rotation=90;
 // CGFloat pointX= edgeIndex * EDGE_LENGTH + X_MARGIN-0.5*EDGE_LENGTH;
 CGFloat pointX= edgeIndex * EDGE_LENGTH + X_MARGIN;
 CGFloat pointY=0.5*EDGE_LENGTH+lineIndex*EDGE_LENGTH+Y_MARGIN;
 [_edgeIndicator setPosition:ccp(pointX,pointY)];
 [_edgeIndicator setVisible:YES];
 //[_edgeLayer addChild:touchPoint];
 //_changeColor=YES;
 
 
 
 }
 else {
 // [_lable setString:[NSString stringWithFormat:@"edge touched at line %d, number %d, the edge has been drew",lineIndex,edgeIndex]];
 } 
 }
 */

/*


-(void)drawEdgeAtRowIndex:(NSInteger)rowIndex EdgeIndex:(NSInteger)edgeIndex
{
    
        //fill the edge
        
        NSLog(@"edge touched at row %d, number %d, an edge is drew",rowIndex,edgeIndex);
        // [_lable setString:[NSString stringWithFormat:@"edge touched at row %d, number %d, an edge is drew",rowIndex,edgeIndex]];
        
        CCSprite *touchPoint=[CCSprite spriteWithSpriteFrameName:[self getEdgeColor]];
        //[touchPoint setScale:0.5];
        //CGFloat pointY= edgeIndex * EDGE_LENGTH + Y_MARGIN-0.5*EDGE_LENGTH; //old
        
        //CGFloat pointX=rowIndex*EDGE_LENGTH+X_MARGIN;
        [touchPoint setPosition:ccp(pointX,pointY)];
        [_edgeLayer addChild:touchPoint];
        
        _changeColor=YES;
        
        //[self checkIfSquareExistForEdgeOnARowAtIndex:rowIndex EdgeIndex:edgeIndex];
        //if(!_twoPlayerOnOneDevice && _CPUTurn)
       // {
       //     [brain move:self];
       // }
    
    
}

*/
/*
-(void)drawEdgeAtLineIndex:(NSInteger)lineIndex EdgeIndex:(NSInteger)edgeIndex
{
    Edge *edge= [self getEdgeAtLineIndex:lineIndex EdgeIndex:edgeIndex];
    if(![edge checkFiled])
    {
        //fill the edge
        edge.isFilled=YES;
        NSLog(@"edge touched at row %d, number %d, an edge is drew",lineIndex,edgeIndex);
        //NSLog(@"an edge is drew");
        //[_lable setString:[NSString stringWithFormat:@"edge touched at line %d, number %d, an edge is drew",lineIndex,edgeIndex]];
        
        CCSprite *touchPoint=[CCSprite spriteWithSpriteFrameName:[self getEdgeColor]];
        touchPoint.rotation=90;
        //CGFloat pointX= edgeIndex * EDGE_LENGTH + X_MARGIN-0.5*EDGE_LENGTH; //old
        CGFloat pointX= edgeIndex * EDGE_LENGTH + X_MARGIN;
        CGFloat pointY=0.5*EDGE_LENGTH+lineIndex*EDGE_LENGTH+Y_MARGIN;
        [touchPoint setPosition:ccp(pointX,pointY)];
        [_edgeLayer addChild:touchPoint];
        _changeColor=YES;
        
        
        [self checkIfSquareExistForEdgeOnALineAtIndex:lineIndex EdgeIndex:edgeIndex];
        if(!_twoPlayerOnOneDevice &&_CPUTurn)
        {
            [brain move:self];
        }
         
        
        
    }
    else {
        // [_lable setString:[NSString stringWithFormat:@"edge touched at line %d, number %d, the edge has been drew",lineIndex,edgeIndex]];
    } 
}
*/
-(void)dealloc
{
    [_treasureBoxArray release];
    [_cannonArray release];
    [_boxArray release];
    [_edgeArray release];
    [_shipArray release];
    [super dealloc];
    
}
@end
