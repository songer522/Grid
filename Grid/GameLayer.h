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
@interface GameLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate,GKPeerPickerControllerDelegate,GKSessionDelegate>
{
    GridView *_gridView;
    GridModel *_gridModel;
    
    CPUBrain *_brain;
    BOOL _isBlueColor;
    BOOL _changeColor;
    int _blueScore;
    int _orangeScore;
    BOOL _CPUTurn;
    BOOL _touchEnable;
    BOOL _isNewGame;
    BOOL _twoPlayerOnOneDevice;
    NSString *_gameMode;
   
    CGPoint _drawPosition;
    GKSession *currentSession;
    GKPeerPickerController *_picker;
}
@property BOOL CPUTurn;
@property BOOL isNewGame;
@property (retain,nonatomic)GridView *gridView;
@property (retain,nonatomic)GridModel *gridModel;
@property BOOL touchEnable;

@property (nonatomic, retain) GKSession *currentSession;
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

- (void)loadTreasureBoxAtRow:(int)rowIndex ItemIndex:(int)edgeIndex;
-(void)loadCannonAtRow:(int)rowIndex ItemIndex:(int)edgeIndex Flip:(BOOL)flipOrNot;
-(void)loadShipAtRow:(int)rowIndex ItemIndex:(int)edgeIndex Flip:(BOOL)flipOrNot;
-(void)loadTreasureMapAtRow:(int)rowIndex ItemIndex:(int)edgeIndex Part:(TreasureMapNumber)number;
@end
