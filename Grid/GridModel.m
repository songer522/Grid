//
//  GridModel.m
//  Grid
//
//  Created by Yang Song on 4/20/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "GridModel.h"
#import "Edge.h"
#import "EdgeArray.h"
#import "Box.h"
#import "BoxArray.h"

@implementation GridModel
@synthesize lines=_lines;
@synthesize rows=_rows;
@synthesize blueScore=_blueScore;
@synthesize orangeScore=_orangeScore;
@synthesize boxs=_boxs;
@synthesize damageCount=_damageCount;
@synthesize blueMapCount=_blueMapCount;
@synthesize orangeMapCount=_orangeMapCount;
@synthesize skullDamageCount=_skullDamageCount;
@synthesize skullHalfDamageCount=_skullHalfDamageCount;
@synthesize skullLeft=_skullLeft;

+(id)GridWithNumOfLines:(int)numberOfLines NumberOfRows:(int)numberOfRows
{
    return [[self alloc] initWithNumOfLines:numberOfLines NumberOfRows:numberOfRows];
}
-(id)initWithNumOfLines:(int)numberOfLines NumberOfRows:(int)numberOfRows
{ 
    if ((self=[super init])) {
        _lines=[[NSMutableArray alloc] init ];
        _rows=[[NSMutableArray alloc] init ];
        _boxs=[[NSMutableArray alloc] init];
        for (int i=0; i<numberOfLines; i++) {
            [_lines addObject:[EdgeArray EdgeArrayWithNumOfEdges:(numberOfRows+1)]];
            //NSLog(@"line:%@",_lines);
            
        }
        for(int j=0;j<numberOfRows;j++)
        {
            [_rows addObject:[EdgeArray EdgeArrayWithNumOfEdges:(numberOfLines+1)]];
            // NSLog(@"row:%@",_rows);
        }
        for (int q=0; q<numberOfRows; q++) {
            [_boxs addObject:[BoxArray BoxArrayWithNumOfBoxes:numberOfRows]];
        }
        
        
        _blueScore=0;
        _orangeScore=0;
        _damageCount=0;
        _blueMapCount=0;
        _orangeMapCount=0;
        _skullDamageCount=0;
        _skullLeft=0;
        
  
        
    }
    
    return self;
}

-(id)getBoxAtLineIndex:(NSInteger)lineIndex BoxIndex:(NSUInteger)boxIndex
{
   
    if (boxIndex>4 ) {
        return nil;
    }
    
    if(lineIndex>4||lineIndex<0)
    {
        return nil;
    }
    Box *box=[(BoxArray*)[_boxs objectAtIndex:lineIndex] objectAtIndex:boxIndex];
    return box;
}



-(id)getEdgeAtLineIndex:(NSUInteger)lineIndex EdgeIndex:(NSUInteger)edgeIndex
{
    if(lineIndex>4)
    {
        //lineIndex=5;
        return nil;
    }
    if(edgeIndex>5)
    {
        //edgeIndex=6;
        return nil;
    }
    Edge *edge=[(EdgeArray*)[_lines objectAtIndex:lineIndex] objectAtIndex:edgeIndex];
    edge.rowOrLine=ON_LINE;
    edge.rowOrLineIndex=(int)lineIndex;
    edge.edgeIndex=(int)edgeIndex;
    return  edge;
    
}

-(id)getEdgeAtRowIndex:(NSUInteger)rowIndex EdgeIndex:(NSUInteger)edgeIndex
{
    if(rowIndex>4)
    {
        //rowIndex=5;
        return nil;
    }
    if(edgeIndex>5)
    {
        //edgeIndex=6;
        return nil;
    }
    Edge  *edge=[(EdgeArray*)[_rows objectAtIndex:rowIndex] objectAtIndex:edgeIndex];
    edge.rowOrLine=ON_ROW;
    edge.rowOrLineIndex=(int)rowIndex;
    edge.edgeIndex=(int)edgeIndex;
    return edge;
}
-(void)resetModel
{
    _blueScore=0;
    _orangeScore=0;
    _damageCount=0;
    _orangeMapCount=0;
    _blueMapCount=0;
    _skullDamageCount=0;
    _skullLeft=0;
    _skullHalfDamageCount=0;
    for(EdgeArray *array in _lines)
    {
        for(Edge *edge in array)
        {
            edge.isFilled=YES;
        }
    }
    
    for(EdgeArray *array in _rows)
    {
        for(Edge *edge in array)
        {
            edge.isFilled=YES;
        }
    }
    
    for(BoxArray *array in _boxs)
    {
        for(Box *box in array)
        {
            box.status=UNAVAILABLE;
        }
    }

}
-(void)dealloc
{
    [_lines release];
    [_rows release];
    [_boxs release];
    
    [super dealloc];
}


@end
