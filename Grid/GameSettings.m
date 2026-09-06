//
//  GameSetting.m
//  Grid
//
//  Created by Yang Song on 5/3/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import "GameSettings.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "PListLoader.h"
#import "Database.h"
@implementation GameSettings
static GameSettings *_shared = nil;

+(GameSettings*)shared
{
	if (!_shared) {
        _shared = [[self alloc] init];
	}
	return _shared;
}

-(id)init
{
    if ((self=[super init])) {
        NSDictionary *gameSettings = loadData(@"savedSettings");
        _savedSettings = [[NSMutableDictionary alloc] initWithDictionary:gameSettings];
        _settings = [[NSMutableDictionary alloc] initWithDictionary:gameSettings];
        [self loadFromSettingsPlist];
                
    }
    return self;
}

-(void)eraseData
{
    if (_savedSettings!=nil) {
        [_savedSettings removeAllObjects];
        [_savedSettings release];
    }
    
    if (_settings!=nil) {
        [_settings removeAllObjects];
        [_settings release];
    }
    _savedSettings = [[NSMutableDictionary alloc] initWithCapacity:30];
    
    _settings = [[NSMutableDictionary alloc] initWithCapacity:30];
    [self loadFromSettingsPlist];
    
    [self saveToDisk];
}
-(void)setGlobal:(NSString*)setting ForKey:(NSString*)key
{
    [_settings setValue:[NSString stringWithString:setting] forKey:key];
}

-(NSString*)getGlobalForKey:(NSString*)key
{
    NSString *returnVal = [_settings valueForKey:key];
    
    if (returnVal) {
        return returnVal;        
    }
    
    return @"";
}

-(id)getObjForKey:(NSString*)key
{
    id returnVal = [_savedSettings valueForKey:key];
    
    if (returnVal) {
        return returnVal;        
    }
    
    return @"";
}


-(void)saveObj:(id)obj ForKey:(NSString*)key
{
    [_savedSettings setValue:obj forKey:key];
}




-(void)loadFromSettingsPlist
{
}

-(void)setSerializedGlobal:(NSString*)setting ForKey:(NSString*)key
{
    [_savedSettings setValue:[NSString stringWithString:setting] forKey:key];
    [_settings setValue:[NSString stringWithString:setting] forKey:key];
}


-(void)saveToDisk
{
    saveData(_settings, @"savedSettings");
}

@end
