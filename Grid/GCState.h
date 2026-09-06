//
//  GCState.h
//  Clay
//
//  Created by Dustin Werner on 10/17/11.
//  Copyright (c) 2011 Xecudev, LLC. All rights reserved.
//
//  Records the current state of the achievements to be saved and loaded by the Database class between playthroughs.

#import <Foundation/Foundation.h>

@interface GCState : NSObject <NSCoding> {
    int island1Socre;
    int island2Score;
    int island3Score;
    int island4Score;
    int island5Score;
    int island6Score;
    int pvpSocre;

    
    
    bool _enabled;

}

+ (GCState *) sharedInstance;
- (void)save;

@property (assign) int island1Socre;
@property (assign) int island2Score;
@property (assign) int island3Score;
@property (assign) int island4Score;
@property (assign) int island5Score;
@property (assign) int island6Score;
@property (assign) int pvpSocre;




@end
