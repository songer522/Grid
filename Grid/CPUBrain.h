//
//  CPUBrain.h
//  Grid
//
//  Created by Yang Song on 4/13/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//
 
#import <Foundation/Foundation.h>
#import "GameLayer.h"

typedef enum {
    FILLED_WITH_THREE_EDGES_AND_ITEM,
    FILLED_WITH_THREE_EDGES,
    FILLED_WITH_TWO_EDGES,
    FILLED_WITH_ONE_EDGES,
    EMPTY
    
    
} BoxStatus;
@class GameLayer;

@interface CPUBrain : NSObject
{
    GameLayer *_grid;
    
    BOOL hasThreeEdgesBox;
    float _waitToCheckThreeEdgeBox;
    float _waitToCheckNonThreeEdgeBox;
    float _waitToCheckRandomEdge;
    int _countForSearchingNonThreeEdgeBox;
}


@property (nonatomic,retain)GameLayer *grid;
+(id)instance;

//-(void)move:(GameLayer *)grid;
-(void)move;
- (void)update:(ccTime)dt;
@end
