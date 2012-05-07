//
//  EdgeArray.h
//  grid
//
//  Created by Yang Song on 4/5/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EdgeArray : NSMutableArray
{
 
}





+(id)EdgeArrayWithNumOfEdges:(int)numberOfEdges;
-(BOOL)checkEdgeFilledAtIndex:(NSUInteger)indexNumber;
@end
