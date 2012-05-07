//
//  PListLoader.h
//  Grid
//
//  Created by Yang Song on 5/3/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.

#import <Foundation/Foundation.h>

@interface PListLoader : NSObject


+(NSDictionary*)loadPlistWithName:(NSString*)plistName;

@end
