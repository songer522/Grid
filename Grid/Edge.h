//
//  Edge.h
//  grid
//
//  Created by Yang Song on 4/5/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ON_ROW,
    ON_LINE
    
} EdgeInfo;
@interface Edge : NSObject
{
    BOOL _isFilled;
    int _rowOrLineIndex;
    int _edgeIndex;
    EdgeInfo _rowOrLine;
    
}
@property BOOL isFilled;
@property int rowOrLineIndex;
@property int edgeIndex;
@property EdgeInfo rowOrLine;


+(id)instance;
-(BOOL)checkFiled;
@end
