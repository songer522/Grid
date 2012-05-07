//
//  CPUBrain.m
//  Grid
//
//  Created by Yang Song on 4/13/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "CPUBrain.h"
#import "EdgeArray.h"
#import "Edge.h"

#include <stdlib.h>

@implementation CPUBrain
@synthesize grid=_grid;
+(id)instance
{
    return [[self alloc] init];
}

-(id)init
{
    if ((self=[super init])) {
        _countForSearchingNonThreeEdgeBox=0;
    }
    return self;
}

//-(void)move:(GameLayer *)grid
-(void)move
{
    int timeInterval=arc4random() %3;
    [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(startBrain) userInfo:nil repeats:NO];
  
    }

-(void)startBrain
{
    _waitToCheckThreeEdgeBox=0.1;
    
    //if(![self checkThreeEdgesfilledBox:grid])
   // [self checkThreeEdgesfilledBox];
   
    /*
    while (hasThreeEdgesBox)
    {
        _waitForCheck=1.0;
        //[self checkThreeEdgesfilledBox]; 
        //[self fillRandomEdge:grid];
        
    }
    */
    /*
    while (![self fillRandomEdge]&&![_grid checkWinner])
    {
        //[self fillRandomEdge];
    }
     */

}



//-(void)fillRandomEdge:(GameLayer *)grid
-(void)fillRandomEdge
{
    //BOOL filledAnEdge=NO;
    int yesOrNo = arc4random() % 2;
    
    int lineIndexOrRowIndex = arc4random() % 5;
    int edgeIndex = arc4random() % 6;
    if(yesOrNo==0)
    {
    Edge *edge= [_grid.gridModel getEdgeAtLineIndex:lineIndexOrRowIndex EdgeIndex:edgeIndex];
    if(!edge.isFilled)
    {
        
        _grid.CPUTurn=NO;
        
        
        [_grid drawEdgeAtLineIndex:lineIndexOrRowIndex EdgeIndex:edgeIndex];
       // filledAnEdge=YES;
        _grid.touchEnable=YES;
        return;
    }
    
    }
    else {
        Edge *edge= [_grid.gridModel getEdgeAtRowIndex:lineIndexOrRowIndex EdgeIndex:edgeIndex];
        if (!edge.isFilled)
        {
        _grid.CPUTurn=NO;
        [_grid drawEdgeAtRowIndex:lineIndexOrRowIndex EdgeIndex:edgeIndex];
         //filledAnEdge=YES;
        _grid.touchEnable=YES;
            return;
        }
    }
    if(![_grid checkWinner])
    {
    _waitToCheckRandomEdge=0.01;
    }
    return;
    //return filledAnEdge;
}

-(void)checkNonThreeEdgesfilledBox
{
    //BOOL filledAnEdge=NO;
    int yesOrNo = arc4random() % 2;
    
    int lineIndexOrRowIndex = arc4random() % 5;
    int edgeIndex = arc4random() % 6;
    if(yesOrNo==0)
    {
        Edge *edge= [_grid.gridModel getEdgeAtLineIndex:lineIndexOrRowIndex EdgeIndex:edgeIndex];
        BoxStatus status= [self getEdgeInfoOnALineAtIndex:lineIndexOrRowIndex EdgeIndex:edgeIndex];
        if(!edge.isFilled&&(status== FILLED_WITH_ONE_EDGES||status==EMPTY))
        {
            
            _grid.CPUTurn=NO;
            
            
            [_grid drawEdgeAtLineIndex:lineIndexOrRowIndex EdgeIndex:edgeIndex];
            // filledAnEdge=YES;
            _grid.touchEnable=YES;
            _countForSearchingNonThreeEdgeBox=0;
            return;
        }
        
    }
    else {
        Edge *edge= [_grid.gridModel getEdgeAtRowIndex:lineIndexOrRowIndex EdgeIndex:edgeIndex];
        BoxStatus status=[self getEdgeInfoOnARowAtIndex:lineIndexOrRowIndex EdgeIndex:edgeIndex];
        if (!edge.isFilled&&(status== FILLED_WITH_ONE_EDGES||status==EMPTY))
        {
            _grid.CPUTurn=NO;
            [_grid drawEdgeAtRowIndex:lineIndexOrRowIndex EdgeIndex:edgeIndex];
            //filledAnEdge=YES;
            _grid.touchEnable=YES;
            _countForSearchingNonThreeEdgeBox=0;
            return;
        }
    }
    if(![_grid checkWinner]&&_countForSearchingNonThreeEdgeBox<50)
    {
        _waitToCheckNonThreeEdgeBox=0.01;
        _countForSearchingNonThreeEdgeBox++;
    }
    else {
        [self fillRandomEdge];
    }
    return;
    //return filledAnEdge;
}
//-(BOOL)checkThreeEdgesfilledBox:(GameLayer *)grid
-(void)checkThreeEdgesfilledBox
{
     //hasThreeEdgesBox=NO;
    for(EdgeArray *array in _grid.gridModel.lines)
    {
        NSUInteger lineIndex=[_grid.gridModel.lines indexOfObject:array];
       // NSLog(@"lineIndex:%d",lineIndex);
    for (Edge *edge in array)
        {
            NSUInteger edgeIndex=[array indexOfObject:edge];
           // NSLog(@"edgeIndex:%d",edgeIndex);
        
         //  if( [self getEdgeInfoOnALineAtIndex:lineIndex EdgeIndex:edgeIndex inGrid:grid] == FILLED_WITH_THREE_EDGES && !edge.isFilled)
            if( [self getEdgeInfoOnALineAtIndex:lineIndex EdgeIndex:edgeIndex] == FILLED_WITH_THREE_EDGES && !edge.isFilled)
           {
               [_grid drawEdgeAtLineIndex:lineIndex EdgeIndex:edgeIndex];
               
               //[self fillRandomEdge:grid];
               //hasThreeEdgesBox=YES;
               _waitToCheckThreeEdgeBox=1.0;
               return;
               //return hasThreeEdgesBox;
           }
        }
    }
    
    
    for(EdgeArray *array in _grid.gridModel.rows)
    {
        NSUInteger rowIndex=[_grid.gridModel.rows indexOfObject:array];
       // NSLog(@"rowIndex:%d",rowIndex);
        for (Edge *edge in array)
        {
            NSUInteger edgeIndex=[array indexOfObject:edge];
           // NSLog(@"edgeIndex:%d",edgeIndex);
           // if( [self getEdgeInfoOnARowAtIndex:rowIndex EdgeIndex:edgeIndex inGrid:grid]== FILLED_WITH_THREE_EDGES && !edge.isFilled)
                 if( [self getEdgeInfoOnARowAtIndex:rowIndex EdgeIndex:edgeIndex]== FILLED_WITH_THREE_EDGES && !edge.isFilled)
            {
                [_grid drawEdgeAtRowIndex:rowIndex EdgeIndex:edgeIndex];
                 //[self fillRandomEdge:grid];
                //hasThreeEdgesBox=YES;
                _waitToCheckThreeEdgeBox=1.0;
                return;
                //return hasThreeEdgesBox;
            }
        }
    }
 if(hasThreeEdgesBox&&!_grid.isNewGame)
   {
      
       
       //[self fillRandomEdge:grid];
      // [self fillRandomEdge];
   }
      //[self fillRandomEdge];
    [self checkNonThreeEdgesfilledBox];
    return;
      //return hasThreeEdgesBox;
}
/*
-(void)checkNonThreeEdgesfilledBox
{
    //hasThreeEdgesBox=NO;
    for(EdgeArray *array in _grid.gridModel.lines)
    {
        NSUInteger lineIndex=[_grid.gridModel.lines indexOfObject:array];
        // NSLog(@"lineIndex:%d",lineIndex);
        for (Edge *edge in array)
        {
            NSUInteger edgeIndex=[array indexOfObject:edge];
            // NSLog(@"edgeIndex:%d",edgeIndex);
            
            //  if( [self getEdgeInfoOnALineAtIndex:lineIndex EdgeIndex:edgeIndex inGrid:grid] == FILLED_WITH_THREE_EDGES && !edge.isFilled)
            if( ([self getEdgeInfoOnALineAtIndex:lineIndex EdgeIndex:edgeIndex] == FILLED_WITH_ONE_EDGES||[self getEdgeInfoOnALineAtIndex:lineIndex EdgeIndex:edgeIndex] == EMPTY) && !edge.isFilled)
            {
                 _grid.CPUTurn=NO;
                
                [_grid drawEdgeAtLineIndex:lineIndex EdgeIndex:edgeIndex];
                 _grid.touchEnable=YES;
                //[self fillRandomEdge:grid];
                //hasThreeEdgesBox=YES;
                //_waitToCheckThreeEdgeBox=1.0;
                return;
                //return hasThreeEdgesBox;
            }
        }
    }
    
    
    for(EdgeArray *array in _grid.gridModel.rows)
    {
        NSUInteger rowIndex=[_grid.gridModel.rows indexOfObject:array];
        // NSLog(@"rowIndex:%d",rowIndex);
        for (Edge *edge in array)
        {
            
            NSUInteger edgeIndex=[array indexOfObject:edge];
            // NSLog(@"edgeIndex:%d",edgeIndex);
            // if( [self getEdgeInfoOnARowAtIndex:rowIndex EdgeIndex:edgeIndex inGrid:grid]== FILLED_WITH_THREE_EDGES && !edge.isFilled)
            if(( [self getEdgeInfoOnARowAtIndex:rowIndex EdgeIndex:edgeIndex]== FILLED_WITH_ONE_EDGES||[self getEdgeInfoOnARowAtIndex:rowIndex EdgeIndex:edgeIndex]== EMPTY )&& !edge.isFilled)
            {
                 _grid.CPUTurn=NO;
                [_grid drawEdgeAtRowIndex:rowIndex EdgeIndex:edgeIndex];
                 _grid.touchEnable=YES;
                //[self fillRandomEdge:grid];
                //hasThreeEdgesBox=YES;
               // _waitToCheckThreeEdgeBox=1.0;
                return;
                //return hasThreeEdgesBox;
            }
        }
    }
    if(hasThreeEdgesBox&&!_grid.isNewGame)
    {
        
        
        //[self fillRandomEdge:grid];
        // [self fillRandomEdge];
    }
    [self fillRandomEdge];
    return;
    //return hasThreeEdgesBox;
}
*/

//-(BoxStatus)getEdgeInfoOnALineAtIndex:(NSUInteger)lineIndex EdgeIndex:(NSUInteger)edgeIndex inGrid:(GameLayer *)grid
-(BoxStatus)getEdgeInfoOnALineAtIndex:(NSUInteger)lineIndex EdgeIndex:(NSUInteger)edgeIndex
{
    NSUInteger M=lineIndex+1-edgeIndex;
    Edge *left=[_grid.gridModel getEdgeAtLineIndex:lineIndex EdgeIndex:(edgeIndex-1)];
    Edge *topLeft=[_grid.gridModel getEdgeAtRowIndex:(lineIndex-M) EdgeIndex:(edgeIndex+M)];
    Edge *bottomLeft=[_grid.gridModel getEdgeAtRowIndex:(lineIndex-M) EdgeIndex:(edgeIndex+M-1)];
    
    Edge *right=[_grid.gridModel getEdgeAtLineIndex:lineIndex EdgeIndex:(edgeIndex+1)];
    Edge *topRight=[_grid.gridModel getEdgeAtRowIndex:(lineIndex+1-M) EdgeIndex:(edgeIndex+M)];
    Edge *bottomRight=[_grid.gridModel getEdgeAtRowIndex:(lineIndex+1-M) EdgeIndex:(edgeIndex+M-1)];
    
    
    int leftCount=0;
    int rightCount=0;
    
    NSArray *array=[NSArray arrayWithObjects:left,topLeft,bottomLeft, nil];
    
    for(Edge *obj in array)
    {
        if (obj.isFilled)
            leftCount++; 
    }
    
    NSArray *array2=[NSArray arrayWithObjects:right,topRight,bottomRight, nil];
    for(Edge *obj in array2)
    {
        if(obj.isFilled)
            rightCount++;
    }
        
    
    if(leftCount==3||rightCount==3)
    {
        return FILLED_WITH_THREE_EDGES;
    }
    else if(leftCount==2||rightCount==2)
    {
        return FILLED_WITH_TWO_EDGES;
    }
    else if (leftCount==1||rightCount==1){
        return FILLED_WITH_ONE_EDGES;
    }
    else {
        return EMPTY;
    }
    }

//-(BoxStatus)getEdgeInfoOnARowAtIndex:(NSUInteger)rowIndex EdgeIndex:(NSUInteger)edgeIndex inGrid:(GameLayer *)grid
-(BoxStatus)getEdgeInfoOnARowAtIndex:(NSUInteger)rowIndex EdgeIndex:(NSUInteger)edgeIndex
{
    Edge *top=[_grid.gridModel getEdgeAtRowIndex:rowIndex EdgeIndex:(edgeIndex+1)];
    Edge *topLeft=[_grid.gridModel getEdgeAtLineIndex:edgeIndex EdgeIndex:rowIndex];
    Edge *topRight=[_grid.gridModel getEdgeAtLineIndex:edgeIndex EdgeIndex:(rowIndex+1)];
    
    Edge *bottom=[_grid.gridModel getEdgeAtRowIndex:rowIndex EdgeIndex:(edgeIndex-1)];
    Edge *bottomLeft=[_grid.gridModel getEdgeAtLineIndex:(edgeIndex-1) EdgeIndex:rowIndex];
    Edge *bottomRight=[_grid.gridModel getEdgeAtLineIndex:(edgeIndex-1) EdgeIndex:(rowIndex+1)];
    
    
    int topCount=0;
    int bottomCount=0;
    
    NSArray *array=[NSArray arrayWithObjects:top,topLeft,topRight, nil];
    
    for(Edge *obj in array)
    {
        if (obj.isFilled)
            topCount++;
    }
    
    NSArray *array2=[NSArray arrayWithObjects:bottom,bottomLeft,bottomRight, nil];
    for(Edge *obj in array2)
    {
        if(obj.isFilled)
            bottomCount++;
    }

    
    if(topCount==3||bottomCount==3)
    {
        return FILLED_WITH_THREE_EDGES;
    }
    else if(topCount==2||bottomCount==2)
    {
        return FILLED_WITH_TWO_EDGES;
    }
    else if (topCount==1||bottomCount==1){
        return FILLED_WITH_ONE_EDGES;
    }
    else {
        return EMPTY;
    }
}
- (void)update:(ccTime)dt {
if(_waitToCheckThreeEdgeBox>0)
{
    _waitToCheckThreeEdgeBox=_waitToCheckThreeEdgeBox-dt;
    if(_waitToCheckThreeEdgeBox<0)
    {
        [self checkThreeEdgesfilledBox];
    }
}
    
    if(_waitToCheckRandomEdge>0)
    {
        _waitToCheckRandomEdge=_waitToCheckRandomEdge-dt;
        if(_waitToCheckRandomEdge<0)
        {
            [self fillRandomEdge];
        }
    }
    if(_waitToCheckNonThreeEdgeBox>0)
    {
        _waitToCheckNonThreeEdgeBox=_waitToCheckNonThreeEdgeBox-dt;
        if(_waitToCheckNonThreeEdgeBox<0)
        {
            [self checkNonThreeEdgesfilledBox];
        }
    }

    
}

@end
