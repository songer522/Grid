//
//  GCState.m
//  Clay
//
//  Created by Dustin Werner on 10/17/11.
//  Copyright (c) 2011 Xecudev, LLC. All rights reserved.
//

#import "GCState.h"
#import "Database.h"

@implementation GCState
@synthesize island1Socre;
@synthesize island3Score;
@synthesize island4Score;
@synthesize island5Score;
@synthesize island6Score;
@synthesize pvpSocre;
@synthesize island2Score;
static GCState *sharedInstance = nil;

+(GCState*)sharedInstance {
    @synchronized([GCState class])
    {
        if (!sharedInstance) {
            sharedInstance = [loadData(@"GCState") retain];
            if (!sharedInstance) {
                [[self alloc] init];
            }
        }
        return sharedInstance;
    }
    return nil;
}

+(id)alloc {
    @synchronized([GCState class])
    {
        NSAssert(sharedInstance == nil, @"Attempted to allocate a second instance of the GCState singleton");
        sharedInstance = [super alloc];
        return sharedInstance;
    }
    return nil;
}

-(void)save {
    if(!_enabled) { return; }
    
    saveData(self, @"GCState");
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    if(!_enabled) { return; }
    
    [encoder encodeInt:island1Socre forKey:@"island1Socre"];
    [encoder encodeInt:island2Score forKey:@"island2Socre"];
    [encoder encodeInt:island3Score forKey:@"island3Socre"];
    [encoder encodeInt:island4Score forKey:@"island4Socre"];
    [encoder encodeInt:island5Score forKey:@"island5Socre"];
    [encoder encodeInt:island6Score forKey:@"island6Socre"];
    [encoder encodeInt:pvpSocre forKey:@"pvpSocre"];
   
    
    
    
    
    

}

-(id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super  init])) {
        _enabled = true;
        
        if (_enabled) {
            island1Socre = [decoder decodeIntForKey:@"island1Socre"];
            island2Score = [decoder decodeIntForKey:@"island2Socre"];
            island3Score = [decoder decodeIntForKey:@"island3Socre"];
            island4Score = [decoder decodeIntForKey:@"island4Socre"];
            island5Score = [decoder decodeIntForKey:@"island5Socre"];
            island6Score = [decoder decodeIntForKey:@"island6Socre"];
            pvpSocre = [decoder decodeIntForKey:@"pvpSocre"];
                       
            
        }
    }
    return self;
}

@end
