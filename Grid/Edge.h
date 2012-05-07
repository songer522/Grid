//
//  Edge.h
//  grid
//
//  Created by Yang Song on 4/5/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Edge : NSObject
{
    BOOL _isFilled;
   
}
@property BOOL isFilled;


+(id)instance;
-(BOOL)checkFiled;
@end
