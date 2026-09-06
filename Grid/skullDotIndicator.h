//
//  skullDotIndicator.h
//  Grid
//
//  Created by Song Yang on 5/31/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface skullDotIndicator : CCLayer
{
    NSMutableArray *_dotArray;
}

+(id)skullDotIndicatorWithNumberOfDots:(int)number AndPosition:(CGPoint)position CurrentPage:(int)currentPage;
-(void)changeDotForPage:(int)pageNumber;
@end
