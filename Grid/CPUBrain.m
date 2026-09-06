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
#import "Box.h"
#import "MapSettings.h"
#import "DeviceSettings.h"

#include <stdlib.h>

@implementation CPUBrain
@synthesize grid=_grid;
@synthesize waitToCheckRandomEdge=_waitToCheckRandomEdge;
+(id)instance
{
    return [[self alloc] init];
}

-(id)init
{
    if ((self=[super init])) {
        _countForSearchingNonThreeEdgeBox=0;
        _nonThirdEdgeArray=[[NSMutableArray alloc] init];
    }
    return self;
}

//-(void)move:(GameLayer *)grid
-(void)move
{
    int timeInterval=(arc4random()%2)+1;
    //[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(startBrain) userInfo:nil repeats:NO];
    _waitToStartBrain=timeInterval;
  
    }

-(void)startBrain
{
    _grid.CPUThinking=YES;
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

-(void)fillRandomEdge
{
    NSMutableArray *nonThirdEdgeArray=[[NSMutableArray alloc] init];
    
    NSUInteger lineCount=[_grid.gridModel.lines count];
    for(NSUInteger lineIndex=0; lineIndex<lineCount; lineIndex++)
    {
        EdgeArray *array=[_grid.gridModel.lines objectAtIndex:lineIndex];
        NSUInteger edgeCount=[array count];
        for(NSUInteger edgeIndex=0; edgeIndex<edgeCount; edgeIndex++)
        {
            Edge *obj=[array objectAtIndex:edgeIndex];
            if(!obj.isFilled)
            {
                obj.rowOrLine=ON_LINE;
                obj.rowOrLineIndex=(int)lineIndex;
                obj.edgeIndex=(int)edgeIndex;
                [nonThirdEdgeArray addObject:obj];
            }
        }
    }
    
    NSUInteger rowCount=[_grid.gridModel.rows count];
    for(NSUInteger rowIndex=0; rowIndex<rowCount; rowIndex++)
    {
        EdgeArray *array=[_grid.gridModel.rows objectAtIndex:rowIndex];
        NSUInteger edgeCount=[array count];
        for(NSUInteger edgeIndex=0; edgeIndex<edgeCount; edgeIndex++)
        {
            Edge *obj=[array objectAtIndex:edgeIndex];
            if(!obj.isFilled)
            {
                obj.rowOrLine=ON_ROW;
                obj.rowOrLineIndex=(int)rowIndex;
                obj.edgeIndex=(int)edgeIndex;
                [nonThirdEdgeArray addObject:obj];
            }
        }
    }
    
    if([nonThirdEdgeArray lastObject])
    {
        Edge *edge= [nonThirdEdgeArray objectAtIndex:(arc4random()%[nonThirdEdgeArray count])];
        _grid.CPUTurn=NO;
        _grid.CPUThinking=NO;
        if(edge.rowOrLine==ON_ROW)
        {
            
            BoxStatus status= [self getEdgeInfoOnARowAtIndex:edge.rowOrLineIndex EdgeIndex:edge.edgeIndex];
            if(status==FILLED_WITH_THREE_EDGES_AND_SKULL)
            {
                [_grid drawEdgeAtRowIndex:edge.rowOrLineIndex EdgeIndex:edge.edgeIndex];
                _waitToCheckRandomEdge=1.0;
                [nonThirdEdgeArray release];
                return;
            }
            else {
                [_grid drawEdgeAtRowIndex:edge.rowOrLineIndex EdgeIndex:edge.edgeIndex];
            }
        }
        else if(edge.rowOrLine==ON_LINE) {
            
            BoxStatus status= [self getEdgeInfoOnALineAtIndex:edge.rowOrLineIndex EdgeIndex:edge.edgeIndex];
            if(status==FILLED_WITH_THREE_EDGES_AND_SKULL)
            {
                [_grid drawEdgeAtLineIndex:edge.rowOrLineIndex EdgeIndex:edge.edgeIndex];
                _waitToCheckRandomEdge=1.0;
                [nonThirdEdgeArray release];
                return;
            }
            else {
                [_grid drawEdgeAtLineIndex:edge.rowOrLineIndex EdgeIndex:edge.edgeIndex];
            }
        }
        _grid.touchEnable=YES;
        
        [nonThirdEdgeArray release];
        return;
    }

    _grid.CPUTurn=NO;
    _grid.CPUThinking=NO;
    _grid.touchEnable=YES;
    [nonThirdEdgeArray release];
    return;
}

//-(void)fillRandomEdge:(GameLayer *)grid
/*
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
        _grid.CPUThinking=NO;
        
        
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
             _grid.CPUThinking=NO;
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
 */
/*
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
        if(!edge.isFilled&&(status== FILLED_WITH_ONE_EDGES||status==EMPTY || status==SINGLE_LINE))
        {
            
            _grid.CPUTurn=NO;
             _grid.CPUThinking=NO;
            
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
        if (!edge.isFilled&&(status== FILLED_WITH_ONE_EDGES||status==EMPTY|| status==SINGLE_LINE))
        {
            _grid.CPUTurn=NO;
             _grid.CPUThinking=NO;
            [_grid drawEdgeAtRowIndex:lineIndexOrRowIndex EdgeIndex:edgeIndex];
            //filledAnEdge=YES;
            _grid.touchEnable=YES;
            _countForSearchingNonThreeEdgeBox=0;
            return;
        }
    }
    int multiplier=1250/_grid.boxCount;
    if(![_grid checkWinner]&&_countForSearchingNonThreeEdgeBox<multiplier)
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
 */

-(void)checkTwoEdgesNoSkullfilledBox
{
    NSMutableArray *twoEdgeNoSkullArray=[[NSMutableArray alloc] init];
    
    for(EdgeArray *array in _grid.gridModel.lines)
    {
        for(Edge *obj in array)
        {
            if(obj.rowOrLine ==ON_LINE)
            {
                BoxStatus status= [self getEdgeInfoOnALineAtIndex:obj.rowOrLineIndex EdgeIndex:obj.edgeIndex];
                if(!obj.isFilled&&(status== FILLED_WITH_TWO_EDGES))
                {
                    [twoEdgeNoSkullArray addObject:obj];
                }
                
                
            }
            
        }
    }
    
    for(EdgeArray *array in _grid.gridModel.rows)
    {
        for(Edge *obj in array)
        {
            if(obj.rowOrLine==ON_ROW)
            {
                
                BoxStatus status= [self getEdgeInfoOnARowAtIndex:obj.rowOrLineIndex EdgeIndex:obj.edgeIndex];
                if(!obj.isFilled&&(status== FILLED_WITH_TWO_EDGES))
                {
                    [twoEdgeNoSkullArray addObject:obj];
                }
                
                
                
                
            }
            
        }
    }
    
    if([twoEdgeNoSkullArray lastObject])
    {
        Edge *edge= [twoEdgeNoSkullArray objectAtIndex:(arc4random()%[twoEdgeNoSkullArray count])];
        _grid.CPUTurn=NO;
        _grid.CPUThinking=NO;
        if(edge.rowOrLine==ON_ROW)
        {
            [_grid drawEdgeAtRowIndex:edge.rowOrLineIndex EdgeIndex:edge.edgeIndex];
        }
        else if(edge.rowOrLine==ON_LINE) {
            [_grid drawEdgeAtLineIndex:edge.rowOrLineIndex EdgeIndex:edge.edgeIndex];
        }
        //filledAnEdge=YES;
        _grid.touchEnable=YES;
        // _countForSearchingNonThreeEdgeBox=0;
        
        //[nonThirdEdgeArray removeObject:edge];
        [twoEdgeNoSkullArray release];
        return;
    }
    else {
        [twoEdgeNoSkullArray release];
        [self fillRandomEdge];
    }
    
    
    return;
    
    //return filledAnEdge;
}





-(void)checkNonThreeEdgesfilledBox
{
    NSMutableArray *nonThirdEdgeArray=[[NSMutableArray alloc] init];
    
    for(EdgeArray *array in _grid.gridModel.lines)
    {
       for(Edge *obj in array)
       {
           if(obj.rowOrLine ==ON_LINE)
           {
           BoxStatus status= [self getEdgeInfoOnALineAtIndex:obj.rowOrLineIndex EdgeIndex:obj.edgeIndex];
               if(!obj.isFilled&&(status== FILLED_WITH_ONE_EDGES||status==EMPTY || status==SINGLE_LINE))
               {
                   [nonThirdEdgeArray addObject:obj];
               }

               
           }
                     
       }
    }
    
    for(EdgeArray *array in _grid.gridModel.rows)
    {
        for(Edge *obj in array)
        {
            if(obj.rowOrLine==ON_ROW)
            {
                
                BoxStatus status= [self getEdgeInfoOnARowAtIndex:obj.rowOrLineIndex EdgeIndex:obj.edgeIndex];
                if(!obj.isFilled&&(status== FILLED_WITH_ONE_EDGES||status==EMPTY || status==SINGLE_LINE))
                {
                    [nonThirdEdgeArray addObject:obj];
                }
                
                
                
                
            }

        }
    }

          if([nonThirdEdgeArray lastObject])
          {
             Edge *edge= [nonThirdEdgeArray objectAtIndex:(arc4random()%[nonThirdEdgeArray count])];
              _grid.CPUTurn=NO;
              _grid.CPUThinking=NO;
              if(edge.rowOrLine==ON_ROW)
              {
              [_grid drawEdgeAtRowIndex:edge.rowOrLineIndex EdgeIndex:edge.edgeIndex];
              }
              else if(edge.rowOrLine==ON_LINE) {
                  [_grid drawEdgeAtLineIndex:edge.rowOrLineIndex EdgeIndex:edge.edgeIndex];
              }
              //filledAnEdge=YES;
              _grid.touchEnable=YES;
             // _countForSearchingNonThreeEdgeBox=0;
            
              //[nonThirdEdgeArray removeObject:edge];
              [nonThirdEdgeArray release];
               return;
          }
          else {
              [nonThirdEdgeArray release];
              [self checkTwoEdgesNoSkullfilledBox];
          }
    
    
       return;
    
    //return filledAnEdge;
}


-(void)checkCannonBoxes
{
    NSMutableArray *cannonBoxArray=[[NSMutableArray alloc] init];
    
    for(EdgeArray *array in _grid.gridModel.lines)
    {
        for(Edge *obj in array)
        {
            if(obj.rowOrLine ==ON_LINE)
            {
                BoxStatus status= [self getEdgeInfoOnALineAtIndex:obj.rowOrLineIndex EdgeIndex:obj.edgeIndex];
                if(!obj.isFilled&&(status== EMPTY_WITH_CANNON))
                {
                    [cannonBoxArray addObject:obj];
                }
                
                
            }
            
        }
    }
    
        
    if([cannonBoxArray lastObject])
    {
        Edge *edge= [cannonBoxArray objectAtIndex:(arc4random()%[cannonBoxArray count])];
        _grid.CPUTurn=NO;
        _grid.CPUThinking=NO;
      
       if(edge.rowOrLine==ON_LINE) {
            [_grid drawEdgeAtLineIndex:edge.rowOrLineIndex EdgeIndex:edge.edgeIndex];
        }
        //filledAnEdge=YES;
        _grid.touchEnable=YES;
        // _countForSearchingNonThreeEdgeBox=0;
        
        //[nonThirdEdgeArray removeObject:edge];
        [cannonBoxArray release];
        return;
    }
    else {
        [cannonBoxArray release];
        [self checkNonThreeEdgesfilledBox];
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
               if(!edge.isFilled)
               {
                   [self checkNonThreeEdgesfilledBox];
                   return;
               }
               _waitToCheckThreeEdgeBox=1.0;
               return;
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
                if(!edge.isFilled)
                {
                    [self checkNonThreeEdgesfilledBox];
                    return;
                }
                _waitToCheckThreeEdgeBox=1.0;
                return;
            }
        }
    }

      //[self fillRandomEdge];
   // [self checkCannonBoxes];
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
    CGFloat pointX1=edgeIndex * EDGE_LENGTH + X_MARGIN - 0.5 * EDGE_LENGTH;
    CGFloat pointY1=lineIndex * EDGE_LENGTH + Y_MARGIN + 0.5 * EDGE_LENGTH;
    
    int blockLineIndex1=(pointY1-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int blockBoxIndex1=(pointX1-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    
    Box *box1=  [_grid.gridModel getBoxAtLineIndex:blockLineIndex1 BoxIndex:blockBoxIndex1];
    
//    if(pointX1<X_BOUNDARY_RIGHT&&pointY1<Y_BOUNDARY_TOP)
 //   {
    CGPoint tileCoord = [_grid.gridView tileCoordForPosition:ccp(pointX1,pointY1)];
    
    int tileGid3 = [_grid.gridView safeTileGIDAt:tileCoord inLayer:_grid.gridView.itemLayer];
    if (tileGid3) {
        NSDictionary *properties = [_grid.gridView.tileMap propertiesForGID:tileGid3];
        if (properties) {
            NSString *collision = [properties valueForKey:@"Item"];
            
            if (collision && [collision compare:@"Fog"] == NSOrderedSame)
            {
                box1.hasFog=YES;
            }
        }
    }
//    }
    
    NSArray *array2=[NSArray arrayWithObjects:right,topRight,bottomRight, nil];
    for(Edge *obj in array2)
    {
        if(obj.isFilled)
            rightCount++;
    }
    CGFloat pointX2=edgeIndex * EDGE_LENGTH + X_MARGIN + 0.5 * EDGE_LENGTH;
    CGFloat pointY2=lineIndex * EDGE_LENGTH + Y_MARGIN + 0.5 * EDGE_LENGTH;
    
    int blockLineIndex2=(pointY2-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int blockBoxIndex2=(pointX2-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
   // NSLog(@"blockLineIndex1:%d, blockBoxIndex1:%d",blockBoxIndex1,blockBoxIndex1);
   // NSLog(@"blockLineIndex2:%d, blockBoxIndex2:%d",blockBoxIndex2,blockBoxIndex2);
    
    Box *box2=  [_grid.gridModel getBoxAtLineIndex:blockLineIndex2 BoxIndex:blockBoxIndex2];
    
  //  if(pointX2<X_BOUNDARY_RIGHT&&pointY2<Y_BOUNDARY_TOP)
  //  {
    CGPoint tileCoord2 = [_grid.gridView tileCoordForPosition:ccp(pointX2,pointY2)];
    int tileGid2 = [_grid.gridView safeTileGIDAt:tileCoord2 inLayer:_grid.gridView.itemLayer];
    if (tileGid2) {
        NSDictionary *properties = [_grid.gridView.tileMap propertiesForGID:tileGid2];
        if (properties) {
            NSString *collision = [properties valueForKey:@"Item"];
            
            if (collision && [collision compare:@"Fog"] == NSOrderedSame)
            {
                box2.hasFog=YES;
            }
        }
    }
 //   }
   if(((leftCount==3 &&box1.status==SKULL)||(rightCount==3&& box2.status==SKULL))&&(!box1.hasFog && !box2.hasFog))
    {
        return FILLED_WITH_THREE_EDGES_AND_SKULL;
    }
    
    
      else  if((leftCount==3 && (box1.status==CANNON||box1.status==TREASUREBOX || box1.status==SHIP|| box1.status==MAP|| box1.status==EMPTY_BOX||box1.hasFog))||(rightCount==3 &&  (box2.status==CANNON||box2.status==TREASUREBOX || box2.status==SHIP|| box2.status==MAP|| box2.status==EMPTY_BOX||box2.hasFog)))
    {
        return FILLED_WITH_THREE_EDGES;
    }
    else if((leftCount<2 && box1.status==CANNON && box2.status==EMPTY_BOX)||(rightCount<2 && box2.status==CANNON && box1.status==EMPTY_BOX))
    {
        return EMPTY_WITH_CANNON;
    }
   
    
    
    else if(box1.status==UNAVAILABLE && box2.status==UNAVAILABLE)
    {
        return SINGLE_LINE;
    }

    else if((leftCount==2 && (box1.status==CANNON||box1.status==TREASUREBOX || box1.status==SHIP|| box1.status==MAP|| box1.status==EMPTY_BOX||box1.hasFog==YES))||(rightCount==2 &&  (box2.status==CANNON||box2.status==TREASUREBOX || box2.status==SHIP|| box2.status==MAP|| box2.status==EMPTY_BOX||box2.hasFog==YES)))
    {
        return FILLED_WITH_TWO_EDGES;
    }
    else if((leftCount==1 && (box1.status==CANNON||box1.status==TREASUREBOX || box1.status==SHIP|| box1.status==MAP|| box1.status==EMPTY_BOX||box1.status==SKULL))||(rightCount==1 &&  (box2.status==CANNON||box2.status==TREASUREBOX || box2.status==SHIP|| box2.status==MAP|| box2.status==EMPTY_BOX||box2.status==SKULL))){
        return FILLED_WITH_ONE_EDGES;
    }
    else if((leftCount==0 && (box1.status==CANNON||box1.status==TREASUREBOX || box1.status==SHIP|| box1.status==MAP|| box1.status==EMPTY_BOX||box1.status==SKULL))&&(rightCount==0 &&  (box2.status==CANNON||box2.status==TREASUREBOX || box2.status==SHIP|| box2.status==MAP|| box2.status==EMPTY_BOX||box2.status==SKULL))){
        return EMPTY;
    }
   
    else {
        return FILLED_WITH_THREE_EDGES_AND_ITEM;
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
    CGFloat pointY1= edgeIndex * EDGE_LENGTH + Y_MARGIN+0.5*EDGE_LENGTH;//525
    CGFloat pointX1=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;//320
    
    
    int blockLineIndex1=(pointY1-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int blockBoxIndex1=(pointX1-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    
    Box *box1=  [_grid.gridModel getBoxAtLineIndex:blockLineIndex1 BoxIndex:blockBoxIndex1];
 //   if(pointX1<X_BOUNDARY_RIGHT&&pointY1<Y_BOUNDARY_TOP)
  //  {
    CGPoint tileCoord = [_grid.gridView tileCoordForPosition:ccp(pointX1,pointY1)];
    int tileGid3 = [_grid.gridView safeTileGIDAt:tileCoord inLayer:_grid.gridView.itemLayer];
    if (tileGid3) {
        NSDictionary *properties = [_grid.gridView.tileMap propertiesForGID:tileGid3];
        if (properties) {
            NSString *collision = [properties valueForKey:@"Item"];
            
            if (collision && [collision compare:@"Fog"] == NSOrderedSame)
            {
                box1.hasFog=YES;
            }
        }
    }
 //   }
    
    NSArray *array2=[NSArray arrayWithObjects:bottom,bottomLeft,bottomRight, nil];
    for(Edge *obj in array2)
    {
        if(obj.isFilled)
            bottomCount++;
    }
    CGFloat pointY2= edgeIndex * EDGE_LENGTH + Y_MARGIN-0.5*EDGE_LENGTH;//419
    CGFloat pointX2=0.5*EDGE_LENGTH+rowIndex*EDGE_LENGTH+X_MARGIN;//320
    
    int blockLineIndex2=(pointY2-Y_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
    int blockBoxIndex2=(pointX2-X_MARGIN-0.5*EDGE_LENGTH)/EDGE_LENGTH;
   // NSLog(@"blockLineIndex1:%d, blockBoxIndex1:%d",blockBoxIndex1,blockBoxIndex1);
   // NSLog(@"blockLineIndex2:%d, blockBoxIndex2:%d",blockBoxIndex2,blockBoxIndex2);
    Box *box2=  [_grid.gridModel getBoxAtLineIndex:blockLineIndex2 BoxIndex:blockBoxIndex2];
  //  if(pointX2<X_BOUNDARY_RIGHT&&pointY2<Y_BOUNDARY_TOP)
   // {
    CGPoint tileCoord2 = [_grid.gridView tileCoordForPosition:ccp(pointX2,pointY2)];
    int tileGid2 = [_grid.gridView safeTileGIDAt:tileCoord2 inLayer:_grid.gridView.itemLayer];
    
    if (tileGid2) {
        NSDictionary *properties = [_grid.gridView.tileMap propertiesForGID:tileGid2];
        if (properties) {
            NSString *collision = [properties valueForKey:@"Item"];
            
            if (collision && [collision compare:@"Fog"] == NSOrderedSame)
            {
                box2.hasFog=YES;
            }
        }
    }
  //  }
    
    if(((topCount==3 &&box1.status==SKULL)||(bottomCount==3&& box2.status==SKULL))&&(!box1.hasFog && !box2.hasFog))
    {
        return FILLED_WITH_THREE_EDGES_AND_SKULL;
    }
    else  if((topCount==3 && (box1.status==CANNON||box1.status==TREASUREBOX || box1.status==SHIP|| box1.status==MAP|| box1.status==EMPTY_BOX||box1.hasFog))||(bottomCount==3 &&  (box2.status==CANNON||box2.status==TREASUREBOX || box2.status==SHIP|| box2.status==MAP|| box2.status==EMPTY_BOX||box2.hasFog)))
    {
        return FILLED_WITH_THREE_EDGES;
    }
    else if(box1.status==UNAVAILABLE && box2.status==UNAVAILABLE)
    {
        return SINGLE_LINE;
    }
  
    else if((topCount==2 && (box1.status==CANNON||box1.status==TREASUREBOX || box1.status==SHIP|| box1.status==MAP|| box1.status==EMPTY_BOX||box1.hasFog==YES))||(bottomCount==2 &&  (box2.status==CANNON||box2.status==TREASUREBOX || box2.status==SHIP|| box2.status==MAP|| box2.status==EMPTY_BOX||box2.hasFog==YES)))
    {
        return FILLED_WITH_TWO_EDGES;
    }
    else if((topCount==1 && (box1.status==CANNON||box1.status==TREASUREBOX || box1.status==SHIP|| box1.status==MAP|| box1.status==EMPTY_BOX||box1.status==SKULL))||(bottomCount==1 &&  (box2.status==CANNON||box2.status==TREASUREBOX || box2.status==SHIP|| box2.status==MAP|| box2.status==EMPTY_BOX||box2.status==SKULL))){
        return FILLED_WITH_ONE_EDGES;
    }
    else if((topCount==0 && (box1.status==CANNON||box1.status==TREASUREBOX || box1.status==SHIP|| box1.status==MAP|| box1.status==EMPTY_BOX||box1.status==SKULL))||(bottomCount==0 &&  (box2.status==CANNON||box2.status==TREASUREBOX || box2.status==SHIP|| box2.status==MAP|| box2.status==EMPTY_BOX||box2.status==SKULL))){
        return EMPTY;
    }
 
    else {
        return FILLED_WITH_THREE_EDGES_AND_ITEM;
    }
}
- (void)update:(ccTime)dt {
    
   if( _waitToStartBrain>0)
   {
       _waitToStartBrain=_waitToStartBrain-dt;
       if(_waitToStartBrain<0)
       {
           [self startBrain];
       }
   }
    
    
    
    
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
            //[self checkCannonBoxes];
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

    if(_grid.CPUTurn && _grid.CPUThinking
       && _waitToStartBrain<=0 && _waitToCheckThreeEdgeBox<=0
       && _waitToCheckRandomEdge<=0 && _waitToCheckNonThreeEdgeBox<=0)
    {
        [self fillRandomEdge];
    }
}

-(void)dealloc
{
     [_nonThirdEdgeArray release];
    [super dealloc];
   
}

@end
