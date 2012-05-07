//
//  GridModel.h
//  Grid
//
//  Created by Yang Song on 4/20/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridModel : NSObject
{
    NSMutableArray *_lines;
    NSMutableArray *_rows;
    NSMutableArray *_boxs;
    int _blueScore;
    int _orangeScore;
    int _damageCount;
}
@property (retain,nonatomic)NSMutableArray *lines;
@property (retain,nonatomic)NSMutableArray *rows;
@property (retain,nonatomic)NSMutableArray *boxs;
@property int blueScore;
@property int orangeScore;
@property int damageCount;
+(id)GridWithNumOfLines:(int)numberOfLines NumberOfRows:(int)numberOfRows;
-(id)getEdgeAtLineIndex:(NSUInteger)lineIndex EdgeIndex:(NSUInteger)edgeIndex;
-(id)getEdgeAtRowIndex:(NSUInteger)rowIndex EdgeIndex:(NSUInteger)edgeIndex;
-(id)getBoxAtLineIndex:(NSInteger)lineIndex BoxIndex:(NSUInteger)boxIndex;
-(void)resetModel;
@end
