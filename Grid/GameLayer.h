//
//  HelloWorldLayer.h
//  Grid
//
//  Created by Yang Song on 4/12/12.
//  Copyright XecuDev 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

#import "GridModel.h"
#import "GridView.h"
#import "CPUBrain.h"
#import "TreasureMap.h"
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@class CPUBrain;
@interface GameLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate,GKSessionDelegate,GKMatchDelegate>
{
    GridView *_gridView;
    GridModel *_gridModel;
    
    CPUBrain *_brain;
    BOOL _isBlueColor;
    BOOL _changeColor;
    BOOL _winOrLose;
    int _blueScore;
    int _orangeScore;
    int _boxCount;
    BOOL _CPUTurn;
    BOOL _otherPlayerTurn;
    BOOL _touchEnable;
    BOOL _isNewGame;
    BOOL _CPUThinking;
    BOOL _isReceiving;
    BOOL _twoPlayerOnOneDevice;
    BOOL _GameOver;
   // BOOL _receiveInvite;
    NSString *_gameMode;
    UIAlertView *_waitingAlert;
    CGPoint _drawPosition;
    GKSession *currentSession;
    GKMatch *myMatch;
    
}
@property BOOL CPUTurn;
@property BOOL winOrLose;
@property BOOL CPUThinking;
@property BOOL twoPlayerOnOneDevice;
@property int boxCount;
@property BOOL isNewGame;
@property (retain,nonatomic)GridView *gridView;
@property (retain,nonatomic)GridModel *gridModel;
@property BOOL touchEnable;
@property (nonatomic,retain)NSString *gameMode;
@property (nonatomic, retain) GKSession *currentSession;
@property (nonatomic,retain) UIAlertView *waitingAlert;
@property (nonatomic, retain) GKPeerPickerController *picker;
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void)checkTouchOnEdgeAndDrawAtPosition:(CGPoint)point;
-(void)showEdgeIndicatorAtPosition:(CGPoint)point;
-(BOOL)checkWinner;
-(void)drawEdgeAtRowIndex:(NSInteger)rowIndex EdgeIndex:(NSInteger)edgeIndex;
-(void)drawEdgeAtLineIndex:(NSInteger)lineIndex EdgeIndex:(NSInteger)edgeIndex;
-(NSString *)getEdgeIndicatorColor;
-(NSString *)getEdgeColor;
-(NSString *)getInitialEdgeColor;
-(void)newGame;
-(void)reply:(NSString *)yesOrNo;
- (void)loadTreasureBoxAtRow:(int)rowIndex ItemIndex:(int)edgeIndex;
- (void)loadSkullAtRow:(int)rowIndex ItemIndex:(int)edgeIndex;
-(void)loadCannonAtRow:(int)rowIndex ItemIndex:(int)edgeIndex Flip:(BOOL)flipOrNot;
-(void)loadShipAtRow:(int)rowIndex ItemIndex:(int)edgeIndex Flip:(BOOL)flipOrNot;
-(void)loadTreasureMapAtRow:(int)rowIndex ItemIndex:(int)edgeIndex Part:(TreasureMapNumber)number;
- (void)loadFogAtRow:(int)rowIndex ItemIndex:(int)edgeIndex;
-(void)loadBoxPatternAtRow:(int)rowIndex ItemIndex:(int)edgeIndex;
- (void)showMessage:(NSString *)buttonID;
- (void)networkShowMessage:(NSString *)buttonID;
-(void)sendFogInfoToTheOtherPlayer:(int)RowIndex
                         ItemIndex:(int)itemIndex
                         FlipOrNot:(NSString *)FlipOrNot
                          ItemName:(NSString *)ItemName;
-(void)networkSendFogInfoToTheOtherPlayer:(int)RowIndex
                                ItemIndex:(int)itemIndex
                                FlipOrNot:(NSString *)FlipOrNot
                                 ItemName:(NSString *)ItemName;
-(void)updateBoxNumber;
@end
