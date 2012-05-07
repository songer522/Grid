//
//  GridView.h
//  Grid
//
//  Created by Yang Song on 4/20/12.
//  Copyright 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ScoreBox.h"

#import "GameWindow.h"
#import "EdgeGraphic.h"

typedef enum {
   BLUE_BOX,
  ORANGE_BOX
        
    
} BoxColor;

typedef enum {
    LEFT,
    RIGHT
    
    
} Direction;
@class GameLayer;
@interface GridView : CCLayer {
    CCLabelTTF *_lable;
    CCSprite *_background;
    CCSprite *_dashLines;
    CCSprite *_dots;
    CCSprite *_edgeIndicator;
    CCLayer *_edgeLayer;
    CCLayer *_blockLayer;
    ScoreBox *_blueScoreBox;
    ScoreBox *_orangeScoreBox;
    CCSprite *_theNewGameButton;
    CCSprite *_menuButton;
    float _waitToShowBox;
    float _waitToShowSecondBoxBlue;
    float _waitToShowSecondBoxOrange;
   // CCSprite *tempSprite;
   // CCSprite *tempSprite2;
    EdgeGraphic *_lastEdge;
    //TreasureBox *_treasureBox1;
    //Cannon *_cannon1;
    GameWindow *_window;
    float _secondBoxPositionX;
    float _secondBoxPositionY;
    NSMutableArray *_treasureBoxArray;
    NSMutableArray *_cannonArray;
    NSMutableArray *_boxArray;
    NSMutableArray *_edgeArray;
    NSMutableArray *_shipArray;
    
    GameLayer *_parentController;
   // float _waitToPlayTreasureBoxAnimation;
    //float _waitToFadeOutTreasureBoxBlue;
    //float _waitToFadeOutTreasureBoxOrange;
    //float _waitToFadeOutCannonBlue;
    //float _waitToFadeOutCannonOrange;
    //float _waitToFadeInTreasureBoxMessageBox;
    //float _waitToFadeOutTreasureBoxMessageBox;
}
@property (retain, nonatomic)CCSprite *edgeIndicator;
@property (retain, nonatomic)EdgeGraphic *lastEdge;
@property (retain, nonatomic)CCSprite *theNewGameButton;
@property (retain, nonatomic)CCSprite *menuButton;
@property (retain, nonatomic)CCSprite *dots;
//@property (retain,nonatomic)TreasureBox *treasureBox1;
//@property (retain,nonatomic)Cannon *cannon1;
@property (retain, nonatomic)CCLayer *edgeLayer;
@property (retain, nonatomic)CCLayer *blockLayer;
@property (retain, nonatomic)CCLabelTTF *lable;
@property (retain, nonatomic)ScoreBox *blueScoreBox;
@property (retain, nonatomic)ScoreBox *orangeScoreBox;
@property float secondBoxPositionX;
@property float secondBoxPositionY;
@property float waitToShowSecondBoxBlue;
@property float waitToShowSecondBoxOrange;
@property (nonatomic,retain)NSMutableArray *treasureBoxArray;
@property (nonatomic,retain)NSMutableArray *cannonArray;
@property (nonatomic,retain)NSMutableArray *boxArray;
@property (nonatomic,retain)NSMutableArray *edgeArray;
@property (nonatomic,retain)NSMutableArray *shipArray;

@property (nonatomic,assign)GameLayer *parentController;
//@property float waitToFadeOutTreasureBoxBlue;
//@property float waitToFadeOutTreasureBoxOrange;
//@property float waitToFadeOutCannonBlue;
//@property float waitToFadeOutCannonOrange;
//@property float waitToPlayTreasureBoxAnimation;
+(id)gridViewInController:(id)controller;

-(void)drawEdgeAtPosition:(CGPoint)point 
                 AndColor:(NSString *)edgeColor
                 Vertical:(BOOL)isVertical;
-(void)drawEdgeIndicatorAtPosition:(CGPoint)point
                          Vertical:(BOOL)isVertical;

-(void)fillBlockAtPositionX:(CGFloat)positionX 
                  PositionY:(CGFloat)positionY
                  WithColor:(BoxColor)color;
- (void)showMessageBoxForTreasureBox;

- (id)getTreasureBoxAtPosition:(CGPoint)point;
- (id)getCannoAtPosition:(CGPoint)point;
- (id)getBoxAtPosition:(CGPoint)point;
- (id)getShipAtPosition:(CGPoint)point;
- (CGPoint)getBoxPositionAt:(Direction)direction From:(CGPoint)point;
-(CGPoint)getItemPositionAtRowIndex:(int)rowIndex ItemIndex:(int)edgeIndex;
- (void)update:(ccTime)dt;
- (void)resetView;
@end

