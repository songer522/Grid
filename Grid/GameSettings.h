//
//  GameSetting.h
//  Grid
//
//  Created by Yang Song on 5/3/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSettings : NSObject
{
    NSMutableDictionary *_settings;
    NSMutableDictionary *_savedSettings;

}
+(GameSettings*)shared;

-(void)setGlobal:(NSString*)setting ForKey:(NSString*)key;
-(void)setSerializedGlobal:(NSString*)setting ForKey:(NSString*)key; //these values get saved in between app sessions
-(NSString*)getGlobalForKey:(NSString*)key;
-(void)loadFromSettingsPlist;
-(void)saveToDisk;
-(void)eraseData;

-(id)getObjForKey:(NSString*)key;
-(void)saveObj:(id)obj ForKey:(NSString*)key;
@end
