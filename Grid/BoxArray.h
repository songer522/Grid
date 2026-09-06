//
//  BoxArray.h
//  Grid
//
//  Created by Yang Song on 4/30/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Box.h"
@interface BoxArray : NSMutableArray
+(id)BoxArrayWithNumOfBoxes:(int)numberOfBoxes;
-(BoxInfo)checkBoxInfoAtIndex:(NSUInteger)indexNumber;
@end
