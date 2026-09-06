//
//  GCHelper.h
//  Clay
//
//  Created by Dustin Werner on 10/17/11.
//  Copyright (c) 2011 Xecudev, LLC. All rights reserved.
//
//  Helper class for using the Game Center. Used to verify that the current device supports game center, that the user has logged in and is authenticated, and to report achievements and leaderboard scores.

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>




#define gcLeaderboardIsland1Score @"com.xecudev.piratelines.leaderboard.island1"
//#define gcLeaderboardIsland2Score @"com.xecudev.piratelines.leaderboard.island2"
//#define gcLeaderboardIsland3Score @"com.xecudev.piratelines.leaderboard.island3"
//#define gcLeaderboardIsland4Score @"com.xecudev.piratelines.leaderboard.island4"
//#define gcLeaderboardIsland5Score @"com.xecudev.piratelines.leaderboard.island5"
//#define gcLeaderboardIsland6Score @"com.xecudev.piratelines.leaderboard.island6"
#define gcLeaderboardPVPscore @"com.xecudev.piratelines.leaderboard.pvp"



@interface GCHelper : NSObject <NSCoding,GKLeaderboardViewControllerDelegate> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    NSMutableArray *leaderboardToReport;
    //NSMutableArray *achievementsToReport;
    bool _enabled;
    //NSMutableDictionary *achievementDictionary;
}
@property (retain) NSMutableArray *leaderboardToReport;
//@property (retain) NSMutableArray *achievementsToReport;
//@property (nonatomic, retain) NSMutableDictionary *achievementDictionary;

+ (GCHelper *) sharedInstance;
- (void)authenticationChanged;
//- (void)authenticateLocalUser;

-(void)resendData;
-(void)save;
-(id)initWithLeaderboardToReport:(NSMutableArray *)leaderboardToReport;
//-(void)reportAchievement:(NSString *)identifier percentComplete:(double)percentComplete;
-(void)reportLeaderboard:(NSString *)identifier score:(float)rawScore;
- (void)reportLeaderboardOnlineWinning:(NSString *)identifier;
- (void) showLeaderboards;
//- (void) showAchievements;

//-(GKAchievement*)getAchievementByID:(NSString *)identifier;
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;

@end
