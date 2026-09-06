//
//  Box.h
//  Grid
//
//  Created by Yang Song on 4/30/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    BLUE,
    ORANGE,
    CANNON,
    TREASUREBOX,
    SKULL,
    SHIP,
    MAP,
    EMPTY_BOX,
    UNAVAILABLE
    
} BoxInfo;
@interface Box : NSObject

{
    BoxInfo _status;
    BOOL _hasFog;
}

@property BoxInfo status;
@property BOOL hasFog;
+(id)instance;
-(BoxInfo)checkStatus;
@end
