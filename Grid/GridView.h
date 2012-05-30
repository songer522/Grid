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
#import <UIKit/UIKit.h>
#import "MessageWindow.h"
#import "EdgeGraphic.h"
#import "GameoverWindow.h"
#import "HowToPlayPage.h"
#import "FlashDot.h"
#import <iAd/iAd.h>

typedef enum {
   BLUE_BOX,
  ORANGE_BOX
        
    
} BoxColor;

typedef enum {
    LEFT,
    RIGHT
    
    
} Direction;
@class GameLayer;
@class GameoverWindow;
@class HowToPlayPage;
@class FlashDot;
@interface GridView : CCLayer<ADBannerViewDelegate> {
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
    CCSprite *_soundButton;
    CCSprite *_menuButton;
    CCSprite *_helpButton;
    //CCSprite *_playerIndicator;
    //CCSprite *_playerIndicator2;
    
    CCSprite *_blueIndicator;
    CCSprite *_orangeIndicator;
    FlashDot *_dot1;
    FlashDot *_dot2;
    float _waitToShowBox;
    float _waitToShowBlueIndicator;
    float _waitToShowOrangeIndicator;
   

  
    EdgeGraphic *_lastEdge;
    CCTMXTiledMap  *tileMap;
    CCTMXLayer *_itemLayer;
    CCTMXLayer *_lineRightLayer;
    CCTMXLayer *_lineDownLayer;
    
    
    MessageWindow *_window;
    GameoverWindow *_gameoverWindow;
    HowToPlayPage *_howToPlayPage;
    float _secondBoxPositionX;
    float _secondBoxPositionY;
    NSMutableArray *_treasureBoxArray;
    NSMutableArray *_cannonArray;
    NSMutableArray *_boxArray;
    NSMutableArray *_edgeArray;
    NSMutableArray *_shipArray;
    NSMutableArray *_mapArray;
    
    GameLayer *_parentController;
     BOOL _isSoundOn;
}
@property (retain, nonatomic)CCSprite *edgeIndicator;
@property (retain, nonatomic)EdgeGraphic *lastEdge;
@property (retain, nonatomic)FlashDot *dot1;
@property (retain, nonatomic)FlashDot *dot2;
@property (retain, nonatomic)CCSprite *theNewGameButton;
@property (retain, nonatomic)CCSprite *menuButton;
@property (retain, nonatomic)CCSprite *dots;
@property (retain,nonatomic) CCSprite *soundButton;
@property (retain,nonatomic) CCSprite *helpButton;
//@property (retain,nonatomic) CCSprite *playerIndicator;
//@property (retain,nonatomic) CCSprite *playerIndicator2;

@property (retain,nonatomic)CCSprite *blueIndicator;
@property (retain,nonatomic)CCSprite *orangeIndicator;
@property (retain, nonatomic)CCLayer *edgeLayer;
@property (retain, nonatomic)CCLayer *blockLayer;
//@property (retain, nonatomic)CCLabelTTF *lable;
@property (retain, nonatomic)ScoreBox *blueScoreBox;
@property (retain, nonatomic)ScoreBox *orangeScoreBox;
@property float secondBoxPositionX;
@property float secondBoxPositionY;
@property float waitToShowBlueIndicator;
@property float waitToShowOrangeIndicator;
@property (retain,nonatomic)GameoverWindow *gameoverWindow;
@property (retain,nonatomic)HowToPlayPage *howToPlayPage;
@property (nonatomic,retain)NSMutableArray *treasureBoxArray;
@property (nonatomic,retain)NSMutableArray *cannonArray;
@property (nonatomic,retain)NSMutableArray *boxArray;
@property (nonatomic,retain)NSMutableArray *edgeArray;
@property (nonatomic,retain)NSMutableArray *shipArray;
@property (nonatomic,retain)NSMutableArray *mapArray;
@property BOOL isSoundOn;
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
- (void)showMessageBoxForTreasureMap;
- (id)getTreasureBoxAtPosition:(CGPoint)point;
- (id)getCannoAtPosition:(CGPoint)point;
- (id)getBoxAtPosition:(CGPoint)point;
- (id)getShipAtPosition:(CGPoint)point;
- (id)getMapAtPosition:(CGPoint)point;
-(void)blueIsOn;
-(void)orangeIsOn;
- (CGPoint)getBoxPositionAt:(Direction)direction From:(CGPoint)point;
-(CGPoint)getItemPositionAtRowIndex:(int)rowIndex ItemIndex:(int)edgeIndex;
- (void)update:(ccTime)dt;
- (void)resetView;
@end

