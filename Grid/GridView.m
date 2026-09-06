//
//  GridView.m
//  Grid
//
//  Created by Yang Song on 4/20/12.
//  Copyright 2012 XecuDev. All rights reserved.
//

#import "GridView.h"
#import "DeviceSettings.h"
#import "Edge.h"
#import "MapSettings.h"
#import "BoxIcon.h"
#import "EdgeGraphic.h"
#import "Ship.h"
#import "TreasureBox.h"
#import "Cannon.h"
#import "TreasureMap.h"
#import "Skull.h"
#import "Fog.h"
#import "GameLayer.h"
#import "GameSettings.h"
#import "Box.h"
#import "SimpleAudioEngine.h"




@implementation GridView
@synthesize edgeIndicator=_edgeIndicator;
//@synthesize lable=_lable;
@synthesize tileMap=_tileMap;
@synthesize itemLayer=_itemLayer;
@synthesize edgeLayer=_edgeLayer;
@synthesize blockLayer=_blockLayer;
@synthesize orangeScoreBox=_orangeScoreBox;
@synthesize blueScoreBox=_blueScoreBox;
@synthesize menuButton=_menuButton;
@synthesize theNewGameButton=_theNewGameButton;
@synthesize secondBoxPositionX=_secondBoxPositionX;
@synthesize secondBoxPositionY=_secondBoxPositionY;
@synthesize waitToShowBlueIndicator=_waitToShowBlueIndicator;
@synthesize waitToShowOrangeIndicator=_waitToShowOrangeIndicator;
@synthesize gameoverWindow=_gameoverWindow;
@synthesize treasureBoxArray=_treasureBoxArray;
@synthesize cannonArray=_cannonArray;
@synthesize boxArray=_boxArray;
@synthesize edgeArray=_edgeArray;
@synthesize shipArray=_shipArray;
@synthesize mapArray=_mapArray;
@synthesize skullArray=_skullArray;
@synthesize fogArray=_fogArray;
//@synthesize playerIndicator=_playerIndicator;
//@synthesize playerIndicator2=_playerIndicator2;
@synthesize blueIndicator=_blueIndicator;
@synthesize orangeIndicator=_orangeIndicator;
@synthesize parentController=_parentController;
@synthesize lastEdge=_lastEdge;
@synthesize dot1=_dot1;
@synthesize dot2=_dot2;
@synthesize dots=_dots;
@synthesize soundButton=_soundButton;
@synthesize helpButton=_helpButton;
@synthesize isSoundOn=_isSoundOn;
@synthesize howToPlayPage=_howToPlayPage;
@synthesize waitToPlayBackgroundMusic=_waitToPlayBackgroundMusic;

+(id)gridViewInController:(id)controller
{
    return [[self alloc] initInController:controller];
}

-(id)initInController:(id)controller
{
    if ((self=[super init])) {
        _parentController=controller;
        _background=[CCSprite spriteWithSpriteFrameName:@"Graphic_Background.png"];
        [_background setPosition:ADJUST_CCP(ccp(160,240))];
        //[_background setScale:0.5];
        
        _dashLines=[CCLayer node];        
        _dots=[CCLayer node];
        
       // [self loadDots];
      // [self loadDashLines];
       
        
        
        
        _waitToShowBox=0;
       // _waitToPlayTreasureBoxAnimation=0.3;
       // _waitToFadeOutTreasureBoxBlue=0;
        //_waitToFadeOutTreasureBoxOrange=0;
       
        NSString *islandNumber=[[GameSettings shared] getGlobalForKey:@"island"];
       // int newNumber=[islandNumber intValue];
       // NSString *newIslandNumber=[NSString stringWithFormat:@"%d",(newNumber+1)];
        NSString *newIslandName=[self getIslandName:islandNumber];
        NSString *levelNumber=[[GameSettings shared] getGlobalForKey:@"levelNumberOnButton"];
        
        
        _lable=[CCLabelTTF labelWithString:[NSString stringWithFormat: @"%@",newIslandName] fontName:@"Impact" fontSize: HD_TEXT(14)];
        [_lable setColor:ccc3(25, 25, 25)];
        _lable.position=ADJUST_CCP(ccp(160,452)) ;//FULL VERSION CHANGE BACK 110 to 415
        _lable2=[CCLabelTTF labelWithString:[NSString stringWithFormat: @"Level %@",levelNumber] fontName:@"Impact" fontSize: HD_TEXT(14)];
        [_lable2 setColor:ccc3(25, 25, 25)];
        _lable2.position=ADJUST_CCP(ccp(160,435)) ;//FULL VERSION CHANGE BACK 110 to 415
        
        //_playerIndicator=[CCSprite spriteWithSpriteFrameName:@"Graphic_TextBlue.png"];
        //[_playerIndicator setPosition:ADJUST_CCP(ccp(60,415))];
        
        //_playerIndicator2=[CCSprite spriteWithSpriteFrameName:@"Graphic_TextBlue.png"];
        //[_playerIndicator2 setPosition:ADJUST_CCP(ccp(260,415))];
       
        _blueIndicator=[CCSprite spriteWithSpriteFrameName:@"Graphic_Arrow_1.png"];
        [_blueIndicator setPosition:ADJUST_CCP(ccp(30,110))];
        [_blueIndicator setOpacity:0];
        
        _orangeIndicator=[CCSprite spriteWithSpriteFrameName:@"Graphic_Arrow_1.png"];
        [_orangeIndicator setPosition:ADJUST_CCP(ccp(290,110))];
       [_orangeIndicator setOpacity:0];
        
        CCSprite *levelNumBack=[CCSprite spriteWithSpriteFrameName:@"Graphic_LevelNumber.png"];
        [levelNumBack setPosition:ADJUST_CCP(ccp(155,445))];
        
        _edgeLayer=[CCLayer node];
        _blockLayer=[CCLayer node];
        
        _blueScoreBox=[ScoreBox ScoreBoxWithImage:@"Graphic_BlueScore.png" andPosition:ADJUST_CCP(ccp(50,86))]; //FULL VERSION 76

        _orangeScoreBox=[ScoreBox ScoreBoxWithImage:@"Graphic_OrangeScore.png" andPosition:ADJUST_CCP(ccp(270,86))];//FULL VERSION 76

        
        _theNewGameButton=[CCSprite spriteWithSpriteFrameName:@"Button_NewGame.png"];
        _menuButton=[CCSprite spriteWithSpriteFrameName:@"Button_Menu.png"];
        _helpButton=[CCSprite spriteWithSpriteFrameName:@"Button_HTP.png"];
        
        
        _isSoundOn=YES;
        NSString *soundSetting=[[GameSettings shared] getGlobalForKey:@"isSoundOn"];
        if([soundSetting isEqualToString:@"NO"])
        {
            _isSoundOn=NO;
              [[SimpleAudioEngine sharedEngine] setMute:YES];
        }
        else 
        {
            _isSoundOn=YES;
              [[SimpleAudioEngine sharedEngine] setMute:NO];
        }
        if(_isSoundOn)
        {
            _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOn.png"];
        }
        else {
            _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOff.png"];
        }

        [_soundButton setPosition:ADJUST_CCP(ccp(290,445))];
        
        [_helpButton setPosition:ADJUST_CCP(ccp(240,445))];
        
        
        
        [_theNewGameButton setPosition:ADJUST_CCP(ccp(30,445))];
        [_menuButton setPosition:ADJUST_CCP(ccp(80,445))];
        _window=[MessageWindow GameWindowWithImage:@"Graphic_TBox_1.png" text:@"Treasure Points" number:@"+5" andPosition:ADJUST_CCP(ccp(160,86))];//FULL VERSION CHANGE BACK 110 to 70

        [_window setOpacity:0];  
       
       
        //tileMap = [CCTMXTiledMap tiledMapWithTMXFile: [CCFileUtils fullPathFromRelativePath:@"DAL_Level1.tmx"]];
        
        NSString *LevelNumber=[[GameSettings shared] getGlobalForKey:@"selectedLevel"];
        
        _tileMap = [CCTMXTiledMap tiledMapWithTMXFile: [NSString stringWithFormat:@"DAL_Level%@.tmx",LevelNumber ]];
        
        _itemLayer = [_tileMap layerNamed:@"Items"];
        _itemLayer.visible = NO;
        
        _lineRightLayer=[_tileMap layerNamed:@"Right"];
        _lineDownLayer=[_tileMap layerNamed:@"Down"];
        
        [_tileMap setPosition:ADJUST_CCP(ccp(1,103.5))];//93.5  FULL VERSION CHANGE BACK
       // _powerUpsArray=[NSMutableArray arrayWithObjects:_treasureBox1, nil];

        
        
        
        
        
        _treasureBoxArray=[[NSMutableArray alloc] init ];
        _cannonArray=[[NSMutableArray alloc] init];
        _boxArray=[[NSMutableArray alloc] init];
        _edgeArray=[[NSMutableArray alloc] init];
        _shipArray=[[NSMutableArray alloc] init];
        _mapArray=[[NSMutableArray alloc] init];
        _skullArray=[[NSMutableArray alloc] init];
        _fogArray=[[NSMutableArray alloc] init];
        [self addChild:_background];
        [self addChild:_tileMap];
        //[self addChild:_dashLines];
        [self addChild:_blockLayer];
        [self addChild:_edgeLayer];
        [self addChild:_dots];
        
       // [self addChild:_playerIndicator];
       // [self addChild:_playerIndicator2];
       
        [self addChild:levelNumBack];
        [self addChild:_lable];
        [self addChild:_lable2];
        [self addChild:_blueScoreBox];
        [self addChild:_orangeScoreBox];
        [self addChild:_blueIndicator];
        [self addChild:_orangeIndicator];
        
        [self blueIsOn];
        //[_orangeIndicator setOpacity:51];
        //[[GameSettings shared] getGlobalForKey:@""];
        if( [_parentController.gameMode isEqualToString:@"solo"])
        {
            CCLabelTTF *player1= [CCLabelTTF labelWithString:[[GameSettings shared] getGlobalForKey:@"Player1Name"] dimensions:CGSizeMake(HD_PIXELS(100), HD_PIXELS(25)) alignment:UITextAlignmentLeft fontName:@"Impact" fontSize:HD_TEXT(20)];
           // CCLabelTTF *player1=[CCLabelTTF labelWithString:[[GameSettings shared] getGlobalForKey:@"Player1Name"] fontName:@"Impact" fontSize:HD_TEXT(20)];
            //CCLabelTTF *player2=[CCLabelTTF labelWithString:@"CPU" fontName:@"Impact" fontSize:HD_TEXT(20)];
            CCLabelTTF *player2=[CCLabelTTF labelWithString:@"CPU" dimensions:CGSizeMake(HD_PIXELS(100), HD_PIXELS(25)) alignment:UITextAlignmentRight fontName:@"Impact" fontSize:HD_TEXT(20)];
            [player1 setPosition:ADJUST_CCP(ccp(131,66))];
            [player2 setPosition:ADJUST_CCP(ccp(189,66))];
            [player1 setColor:ccc3(25, 25, 25)];
            [player2 setColor:ccc3(25, 25, 25)];
           // player1.fontSize=HD_TEXT([self getTextName:player1]);
            // player2.fontSize=HD_TEXT([self getTextName:player2]);
            player1.fontSize=HD_TEXT(16);
            player2.fontSize=HD_TEXT(16);
            [self addChild:player1];
            [self addChild:player2];
        }
        
        else if([_parentController.gameMode isEqualToString:@"oneDevice"])
        {
            CCLabelTTF *player1=[CCLabelTTF labelWithString:[[GameSettings shared] getGlobalForKey:@"Player1Name"] dimensions:CGSizeMake(HD_PIXELS(80), HD_PIXELS(25)) alignment:UITextAlignmentLeft fontName:@"Impact" fontSize:HD_TEXT(20)];
            CCLabelTTF *player2=[CCLabelTTF labelWithString:[[GameSettings shared] getGlobalForKey:@"Player2Name"] dimensions:CGSizeMake(HD_PIXELS(80), HD_PIXELS(25)) alignment:UITextAlignmentRight fontName:@"Impact" fontSize:HD_TEXT(20)];
            
            [player1 setPosition:ADJUST_CCP(ccp(121,66))];
            [player2 setPosition:ADJUST_CCP(ccp(199,66))];
            [player1 setColor:ccc3(25, 25, 25)];
            [player2 setColor:ccc3(25, 25, 25)];
            //player1.fontSize=HD_TEXT([self getTextName:player1]);
            //player2.fontSize=HD_TEXT([self getTextName:player2]);
            player1.fontSize=HD_TEXT(16);
             player2.fontSize=HD_TEXT(16);
            
            [self addChild:player1];
            [self addChild:player2];
        
        }
        
        else if([_parentController.gameMode isEqualToString:@"blueTooth"])
        {
            CCLabelTTF *player1=[CCLabelTTF labelWithString:[[GameSettings shared] getGlobalForKey:@"BluePlayer"] dimensions:CGSizeMake(HD_PIXELS(100), HD_PIXELS(25)) alignment:UITextAlignmentLeft fontName:@"Impact" fontSize:HD_TEXT(20)];
            CCLabelTTF *player2=[CCLabelTTF labelWithString:[[GameSettings shared] getGlobalForKey:@"OrangePlayer"] dimensions:CGSizeMake(HD_PIXELS(100), HD_PIXELS(25)) alignment:UITextAlignmentRight fontName:@"Impact" fontSize:HD_TEXT(20)];
            [player1 setPosition:ADJUST_CCP(ccp(131,66))];
            [player2 setPosition:ADJUST_CCP(ccp(189,66))];
            [player1 setColor:ccc3(25, 25, 25)];
            [player2 setColor:ccc3(25, 25, 25)];
           // player1.fontSize=HD_TEXT([self getTextName:player1]);
            //player2.fontSize=HD_TEXT([self getTextName:player2]);
            player1.fontSize=HD_TEXT(16);
            player2.fontSize=HD_TEXT(16);
            [self addChild:player1];
            [self addChild:player2];
        }
        
        else if([_parentController.gameMode isEqualToString:@"network"])
        {
            NSString *player1Name=[[GameSettings shared] getGlobalForKey:@"BluePlayer"];
             NSString *player2Name=[[GameSettings shared] getGlobalForKey:@"OrangePlayer"];
           
            if(player1Name.length>10)
            {
                player1Name= [[player1Name substringToIndex:8] stringByAppendingFormat:@".."];
            }
            if(player2Name.length>10)
            {
                player2Name= [[player2Name substringToIndex:8] stringByAppendingFormat:@".."];
            }
            
            CCLabelTTF *player1=[CCLabelTTF labelWithString:player1Name dimensions:CGSizeMake(HD_PIXELS(80), HD_PIXELS(50)) alignment:UITextAlignmentLeft fontName:@"Impact" fontSize:HD_TEXT(20)];
            CCLabelTTF *player2=[CCLabelTTF labelWithString:player2Name dimensions:CGSizeMake(HD_PIXELS(80), HD_PIXELS(50)) alignment:UITextAlignmentRight fontName:@"Impact" fontSize:HD_TEXT(20)];
            [player1 setPosition:ADJUST_CCP(ccp(121,51))];
            [player2 setPosition:ADJUST_CCP(ccp(199,51))];
            [player1 setColor:ccc3(25, 25, 25)];
            [player2 setColor:ccc3(25, 25, 25)];
            // player1.fontSize=HD_TEXT([self getTextName:player1]);
            //player2.fontSize=HD_TEXT([self getTextName:player2]);
            player1.fontSize=HD_TEXT(16);
            player2.fontSize=HD_TEXT(16);
            [self addChild:player1];
            [self addChild:player2];
        }
        [self addChild:_menuButton];
        [self addChild:_theNewGameButton];
        [self addChild:_soundButton];
        [self addChild:_helpButton];
         [self addChild:_window];
               
       [self loadEdgeIndicator];
       
        //[self loadPowerUpsAndsetupModel];
        _lastEdge=[EdgeGraphic spriteWithSpriteFrameName:@"Graphic_Dot.png"];
        [_lastEdge setPosition:ADJUST_CCP(ccp(0,0))];
        [_lastEdge setVisible:NO];
        [_dots addChild:_lastEdge];
        _dot1=[FlashDot spriteWithSpriteFrameName:@"TileGraphic_Dot_Red.png"];
        [_dot1 setPosition:ADJUST_CCP(ccp(0,0))];
        [_dot1 setVisible:NO];
        [_dots addChild:_dot1];
        
        _dot2=[FlashDot spriteWithSpriteFrameName:@"TileGraphic_Dot_Red.png"];
        [_dot2 setPosition:ADJUST_CCP(ccp(0,0))];
        [_dot2 setVisible:NO];
        [_dots addChild:_dot2];
         
        _waitToPlayBackgroundMusic=2.0;
    
        }
        
    return self;
}


-(void)loadPowerUpsAndsetupModel
{
    for(int positionX = HD_PIXELS(27.5); positionX< X_BOUNDARY_RIGHT; positionX=positionX+EDGE_LENGTH )
    {
        for (int positionY= HD_PIXELS(130); positionY<Y_BOUNDARY_TOP; positionY=positionY+EDGE_LENGTH) {
            //CCSprite *dot=[CCSprite spriteWithSpriteFrameName:@"Graphic_Dot.png"];
            //[dot setPosition:ccp(positionX,positionY)];
            //[_dots addChild:dot];
            CGPoint tileCoord = [self tileCoordForPosition:ccp(positionX,positionY)];
            BOOL rightLineFilled=NO;
            int tileGid = [_lineRightLayer tileGIDAt:tileCoord];
            if (tileGid) {
                NSDictionary *properties = [_tileMap propertiesForGID:tileGid];
                if (properties) {
                    NSString *collision = [properties valueForKey:@"RowFilled"];
                    if (collision && [collision compare:@"True"] == NSOrderedSame) {
                        Edge *edge= [_parentController.gridModel getEdgeAtRowIndex:tileCoord.x EdgeIndex:(NUM_OF_LINES-tileCoord.y)];
                        edge.isFilled=NO;
                        rightLineFilled=YES;
                       // NSLog(@"row edge Filled (%f,%f) position (%d,%d), tileGid:%d",tileCoord.x,tileCoord.y,positionX,positionY,tileGid);
                    }
                }
            }
            
            int tileGid2 = [_lineDownLayer tileGIDAt:tileCoord];
            if (tileGid2) {
                NSDictionary *properties = [_tileMap propertiesForGID:tileGid2];
                if (properties) {
                    NSString *collision = [properties valueForKey:@"LineFilled"];
                    if (collision && [collision compare:@"True"] == NSOrderedSame) {
                        Edge *edge=[_parentController.gridModel getEdgeAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) EdgeIndex:tileCoord.x];
                        edge.isFilled=NO;
                       //  NSLog(@"line edge Filled (%f,%f) position (%d,%d), tileGid:%d",tileCoord.x,tileCoord.y,positionX,positionY,tileGid2);
                        
                        if(rightLineFilled)
                        {
                            
                        }
                    }
                }
            }
            int tileGid3 = [_itemLayer tileGIDAt:tileCoord];
            if (tileGid3) {
                NSDictionary *properties = [_tileMap propertiesForGID:tileGid3];
                if (properties) {
                    NSString *collision = [properties valueForKey:@"Item"];
                    if (collision && [collision compare:@"TreasureBox"] == NSOrderedSame) {
                        Box *box=[_parentController.gridModel getBoxAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) BoxIndex:tileCoord.x];
                        box.status=TREASUREBOX;
                        [_parentController loadBoxPatternAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                        [_parentController loadTreasureBoxAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                    }
                    else if (collision && [collision compare:@"Skull"] == NSOrderedSame) {
                        Box *box=[_parentController.gridModel getBoxAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) BoxIndex:tileCoord.x];
                        box.status=SKULL;
                        [_parentController loadBoxPatternAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                         [_parentController loadSkullAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                    }
                    /*
                    else if (collision && [collision compare:@"Fog"] == NSOrderedSame) {
                        Box *box=[_parentController.gridModel getBoxAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) BoxIndex:tileCoord.x];
                     
                        [_parentController loadBoxPatternAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                        [self loadRamdomItem:box position:tileCoord];
                        [_parentController loadFogAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                    }
                     
                     */

                    else if (collision && [collision compare:@"CannonLeft"] == NSOrderedSame) {
                        [_parentController loadBoxPatternAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                        Box *box=[_parentController.gridModel getBoxAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) BoxIndex:tileCoord.x];
                        box.status=CANNON;
                        [_parentController loadCannonAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y) Flip:NO];
                    }
                    else if (collision && [collision compare:@"CannonRight"] == NSOrderedSame) {
                        [_parentController loadBoxPatternAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                        Box *box=[_parentController.gridModel getBoxAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) BoxIndex:tileCoord.x];
                        box.status=CANNON;
                      [_parentController loadCannonAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y) Flip:YES];
                    }
                    else if (collision && [collision compare:@"ShipLeft"] == NSOrderedSame) {
                        [_parentController loadBoxPatternAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                        Box *box=[_parentController.gridModel getBoxAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) BoxIndex:tileCoord.x];
                        box.status=SHIP;
                        [_parentController loadShipAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y) Flip:YES];

                    }
                    else if (collision && [collision compare:@"ShipRight"] == NSOrderedSame) {
                        [_parentController loadBoxPatternAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                        Box *box=[_parentController.gridModel getBoxAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) BoxIndex:tileCoord.x];
                        box.status=SHIP;
                        [_parentController loadShipAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y) Flip:NO];
                    }
                    else if (collision && [collision compare:@"MapOne"] == NSOrderedSame) {
                        [_parentController loadBoxPatternAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                        Box *box=[_parentController.gridModel getBoxAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) BoxIndex:tileCoord.x];
                        box.status=MAP;
                        [_parentController loadTreasureMapAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y) Part:TREASUREMAP_PART_ONE];
                        CCSprite *mapIndicator1=[CCSprite spriteWithSpriteFrameName:@"Graphic_TmapBack.png"];
                        [mapIndicator1 setPosition:ADJUST_CCP(ccp(50,35))];
                        [_blockLayer addChild:mapIndicator1];
                        CCSprite *mapIndicator2=[CCSprite spriteWithSpriteFrameName:@"Graphic_TmapBack.png"];
                        [mapIndicator2 setPosition:ADJUST_CCP(ccp(270,35))];
                        [_blockLayer addChild:mapIndicator2];

                    }
                    else if (collision && [collision compare:@"MapTwo"] == NSOrderedSame) {
                        [_parentController loadBoxPatternAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                        Box *box=[_parentController.gridModel getBoxAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) BoxIndex:tileCoord.x];
                        box.status=MAP;
                        [_parentController loadTreasureMapAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y) Part:TREASUREMAP_PART_TWO];
                    }
                    else if (collision && [collision compare:@"Empty"] == NSOrderedSame) {
                        [_parentController loadBoxPatternAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                        Box *box=[_parentController.gridModel getBoxAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) BoxIndex:tileCoord.x];
                        box.status=EMPTY_BOX;
                    }

                }
            }


            
            
            
        }
    }
    
    
    for(int positionX = HD_PIXELS(27.5); positionX< X_BOUNDARY_RIGHT; positionX=positionX+EDGE_LENGTH )
    {
        for (int positionY= HD_PIXELS(130); positionY<Y_BOUNDARY_TOP; positionY=positionY+EDGE_LENGTH) {
            //CCSprite *dot=[CCSprite spriteWithSpriteFrameName:@"Graphic_Dot.png"];
            //[dot setPosition:ccp(positionX,positionY)];
            //[_dots addChild:dot];
            CGPoint tileCoord = [self tileCoordForPosition:ccp(positionX,positionY)];
                       int tileGid3 = [_itemLayer tileGIDAt:tileCoord];
            if (tileGid3) {
                NSDictionary *properties = [_tileMap propertiesForGID:tileGid3];
                if (properties) {
                    NSString *collision = [properties valueForKey:@"Item"];
                                        
                     if (collision && [collision compare:@"Fog"] == NSOrderedSame) {
                     Box *box=[_parentController.gridModel getBoxAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) BoxIndex:tileCoord.x];
                     
                     [_parentController loadBoxPatternAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                    if(![_parentController.gameMode isEqualToString:@"blueTooth"]&&![_parentController.gameMode isEqualToString:@"network"])
                    {
                     [self loadRamdomItem:box position:tileCoord];
                     [_parentController loadFogAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                    }
                         
                    else if ([_parentController.gameMode isEqualToString:@"blueTooth"]){
                    //    [self loadBluetoothRamdomItem:box position:tileCoord];
                        _waitToLoadFog=1.0;
                    }
                    else if ([_parentController.gameMode isEqualToString:@"network"]){
                    //    [self loadNetworkRamdomItem:box position:tileCoord];
                        _waitToLoadFog=1.0;
                    }
                     }
                     
                    
                                       
                }
            }
            
            
            
            
            
        }
    }
   
     
}
-(void)loadfog
{
    for(int positionX = HD_PIXELS(27.5); positionX< X_BOUNDARY_RIGHT; positionX=positionX+EDGE_LENGTH )
    {
        for (int positionY= HD_PIXELS(130); positionY<Y_BOUNDARY_TOP; positionY=positionY+EDGE_LENGTH) {
            //CCSprite *dot=[CCSprite spriteWithSpriteFrameName:@"Graphic_Dot.png"];
            //[dot setPosition:ccp(positionX,positionY)];
            //[_dots addChild:dot];
            CGPoint tileCoord = [self tileCoordForPosition:ccp(positionX,positionY)];
            int tileGid3 = [_itemLayer tileGIDAt:tileCoord];
            if (tileGid3) {
                NSDictionary *properties = [_tileMap propertiesForGID:tileGid3];
                if (properties) {
                    NSString *collision = [properties valueForKey:@"Item"];
                    
                    if (collision && [collision compare:@"Fog"] == NSOrderedSame) {
                        Box *box=[_parentController.gridModel getBoxAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) BoxIndex:tileCoord.x];
                        
                        //[_parentController loadBoxPatternAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                        
                        if ([_parentController.gameMode isEqualToString:@"blueTooth"]){
                            [self loadBluetoothRamdomItem:box position:tileCoord];
                        }
                        else if ([_parentController.gameMode isEqualToString:@"network"]){
                            [self loadNetworkRamdomItem:box position:tileCoord];
                        }
                    }
                    
                    
                    
                }
            }
            
            
            
            
            
        }
    }

}

-(void)loadRamdomItem:(Box *)box position:(CGPoint)point
{
    int number= arc4random() % 100;
    /*
    switch (number) {
        case 0:
             box.status=TREASUREBOX;
             [_parentController loadTreasureBoxAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
            break;
        case 1:
            box.status=SKULL;
            [_parentController loadSkullAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
            break;
        case 2:
            box.status=CANNON;
             [_parentController loadCannonAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:NO];
            break;
        case 3:
            box.status=CANNON;
            [_parentController loadCannonAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:YES];
            break;
        case 4:
            box.status=SHIP;
            [_parentController loadShipAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:YES];
            break;
        case 5:
            box.status=SHIP;
            [_parentController loadShipAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:NO];
            break;
        default:
            break;
    }
     */
    
    if(number>=0 && number<20)
    {
        box.status=TREASUREBOX;
        [_parentController loadTreasureBoxAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
        return;
    }
    else if(number>=20 && number<60) {
        box.status=SKULL;
        [_parentController loadSkullAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
        return;
    }
    else if(number>=60 && number<70) {
        box.status=CANNON;
        [_parentController loadCannonAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:NO];
        return;
        
    }
    else if (number>=70 && number<80) {
        box.status=CANNON;
        [_parentController loadCannonAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:YES];
        return;
    }
    else if(number>=80 && number<90) {
        box.status=SHIP;
        [_parentController loadShipAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:YES];
        return;
    }
    else if (number>=90 && number <100) {
        box.status=SHIP;
        [_parentController loadShipAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:NO];
        return;
    }
    else {
        return;
    }
}

-(void)loadBluetoothRamdomItem:(Box *)box position:(CGPoint)point
{
    int number= arc4random() % 100;
    NSString *play1Name=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
    NSString *orangePlayerName=[[GameSettings shared] getGlobalForKey:@"OrangePlayer"];
    if([orangePlayerName isEqualToString:play1Name])
    {
    if(number>=0 && number<20)
    {
        box.status=TREASUREBOX;
        [_parentController loadTreasureBoxAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
        [_parentController loadFogAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
        [_parentController sendFogInfoToTheOtherPlayer:point.x ItemIndex:(NUM_OF_LINES-point.y) FlipOrNot:@"NO" ItemName:@"TreasureBox"];
         [_parentController updateBoxNumber];
         _parentController.gridModel.skullLeft=(int)_parentController.gridView.skullArray.count;
        return;
    }
    else if(number>=20 && number<60) {
        box.status=SKULL;
        [_parentController loadSkullAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
         [_parentController loadFogAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
        [_parentController sendFogInfoToTheOtherPlayer:point.x ItemIndex:(NUM_OF_LINES-point.y) FlipOrNot:@"NO" ItemName:@"Skull"];
         [_parentController updateBoxNumber];
        _parentController.gridModel.skullLeft=(int)_parentController.gridView.skullArray.count;
        return;
    }
    else if(number>=60 && number<70) {
        box.status=CANNON;
        [_parentController loadCannonAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:NO];
         [_parentController loadFogAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
        [_parentController sendFogInfoToTheOtherPlayer:point.x ItemIndex:(NUM_OF_LINES-point.y) FlipOrNot:@"NO" ItemName:@"Cannon"];
         [_parentController updateBoxNumber];
        _parentController.gridModel.skullLeft=(int)_parentController.gridView.skullArray.count;
        return;
        
    }
    else if (number>=70 && number<80) {
        box.status=CANNON;
        [_parentController loadCannonAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:YES];
         [_parentController loadFogAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
        [_parentController sendFogInfoToTheOtherPlayer:point.x ItemIndex:(NUM_OF_LINES-point.y) FlipOrNot:@"YES" ItemName:@"Cannon"];
         [_parentController updateBoxNumber];
        _parentController.gridModel.skullLeft=(int)_parentController.gridView.skullArray.count;
        return;
    }
    else if(number>=80 && number<90) {
        box.status=SHIP;
        [_parentController loadShipAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:YES];
         [_parentController loadFogAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
        [_parentController sendFogInfoToTheOtherPlayer:point.x ItemIndex:(NUM_OF_LINES-point.y) FlipOrNot:@"YES" ItemName:@"Ship"];
         [_parentController updateBoxNumber];
        _parentController.gridModel.skullLeft=(int)_parentController.gridView.skullArray.count;
        return;
    }
    else if (number>=90 && number <100) {
        box.status=SHIP;
        [_parentController loadShipAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:NO];
         [_parentController loadFogAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
        [_parentController sendFogInfoToTheOtherPlayer:point.x ItemIndex:(NUM_OF_LINES-point.y) FlipOrNot:@"NO" ItemName:@"Ship"];
         [_parentController updateBoxNumber];
        _parentController.gridModel.skullLeft=(int)_parentController.gridView.skullArray.count;
        return;
    }
    else {
        return;
    }
        
    }
}

-(void)loadNetworkRamdomItem:(Box *)box position:(CGPoint)point
{
    int number= arc4random() % 100;
    //NSString *play1Name=[[GameSettings shared] getGlobalForKey:@"Player1Name"];
     NSString *play1Name=	[[GKLocalPlayer localPlayer] alias];
    NSString *orangePlayerName=[[GameSettings shared] getGlobalForKey:@"OrangePlayer"];
    if([orangePlayerName isEqualToString:play1Name])
    {
        if(number>=0 && number<20)
        {
            box.status=TREASUREBOX;
            [_parentController loadTreasureBoxAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
            [_parentController loadFogAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
            [_parentController networkSendFogInfoToTheOtherPlayer:point.x ItemIndex:(NUM_OF_LINES-point.y) FlipOrNot:@"NO" ItemName:@"TreasureBox"];
            [_parentController updateBoxNumber];
            _parentController.gridModel.skullLeft=(int)_parentController.gridView.skullArray.count;
            return;
        }
        else if(number>=20 && number<60) {
            box.status=SKULL;
            [_parentController loadSkullAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
            [_parentController loadFogAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
            [_parentController networkSendFogInfoToTheOtherPlayer:point.x ItemIndex:(NUM_OF_LINES-point.y) FlipOrNot:@"NO" ItemName:@"Skull"];
            [_parentController updateBoxNumber];
            _parentController.gridModel.skullLeft=(int)_parentController.gridView.skullArray.count;
            return;
        }
        else if(number>=60 && number<70) {
            box.status=CANNON;
            [_parentController loadCannonAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:NO];
            [_parentController loadFogAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
            [_parentController networkSendFogInfoToTheOtherPlayer:point.x ItemIndex:(NUM_OF_LINES-point.y) FlipOrNot:@"NO" ItemName:@"Cannon"];
            [_parentController updateBoxNumber];
            _parentController.gridModel.skullLeft=(int)_parentController.gridView.skullArray.count;
            return;
            
        }
        else if (number>=70 && number<80) {
            box.status=CANNON;
            [_parentController loadCannonAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:YES];
            [_parentController loadFogAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
            [_parentController networkSendFogInfoToTheOtherPlayer:point.x ItemIndex:(NUM_OF_LINES-point.y) FlipOrNot:@"YES" ItemName:@"Cannon"];
            [_parentController updateBoxNumber];
            _parentController.gridModel.skullLeft=(int)_parentController.gridView.skullArray.count;
            return;
        }
        else if(number>=80 && number<90) {
            box.status=SHIP;
            [_parentController loadShipAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:YES];
            [_parentController loadFogAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
            [_parentController networkSendFogInfoToTheOtherPlayer:point.x ItemIndex:(NUM_OF_LINES-point.y) FlipOrNot:@"YES" ItemName:@"Ship"];
            [_parentController updateBoxNumber];
            _parentController.gridModel.skullLeft=(int)_parentController.gridView.skullArray.count;
            return;
        }
        else if (number>=90 && number <100) {
            box.status=SHIP;
            [_parentController loadShipAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y) Flip:NO];
            [_parentController loadFogAtRow:point.x ItemIndex:(NUM_OF_LINES-point.y)];
            [_parentController networkSendFogInfoToTheOtherPlayer:point.x ItemIndex:(NUM_OF_LINES-point.y) FlipOrNot:@"NO" ItemName:@"Ship"];
            [_parentController updateBoxNumber];
            _parentController.gridModel.skullLeft=(int)_parentController.gridView.skullArray.count;
            return;
        }
        else {
            return;
        }
    }
}


-(void)loadDashLines
{
    for(int positionX = X_MARGIN+0.5*EDGE_LENGTH; positionX< X_BOUNDARY_RIGHT; positionX=positionX+EDGE_LENGTH )
    {
        for (int positionY= Y_MARGIN; positionY<Y_BOUNDARY_TOP; positionY=positionY+EDGE_LENGTH) {
            CCSprite *dot=[CCSprite spriteWithSpriteFrameName:@"Graphic_HelpLine.png"];
            [dot setPosition:ccp(positionX,positionY)];
            [_dashLines addChild:dot];
        }
    }
    
    for(int positionX = X_MARGIN; positionX< X_BOUNDARY_RIGHT; positionX=positionX+EDGE_LENGTH )
    {
        for (int positionY= Y_MARGIN+0.5*EDGE_LENGTH; positionY<Y_BOUNDARY_TOP; positionY=positionY+EDGE_LENGTH) {
            CCSprite *dot=[CCSprite spriteWithSpriteFrameName:@"Graphic_HelpLine.png"];
            dot.rotation=90;
            [dot setPosition:ccp(positionX,positionY)];
            [_dashLines addChild:dot];
        }
    }
}

- (void)loadEdgeIndicator
{
    _edgeIndicator =[CCSprite spriteWithSpriteFrameName:[_parentController getInitialEdgeColor]];
    [_edgeIndicator setVisible:NO]; 
    _edgeIndicator =[CCSprite spriteWithSpriteFrameName:[_parentController getInitialEdgeColor]];
    [_edgeIndicator setVisible:NO]; 
    [_edgeLayer addChild:_edgeIndicator];
    
    
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
   
    // int x = (position.x-X_MARGIN) / tileMap.tileSize.width;
    int x = (position.x+1-HD_PIXELS(27.5)) / HD_PIXELS(53);
    //int y = ((tileMap.mapSize.height * tileMap.tileSize.height) - position.y) / tileMap.tileSize.height;
    int y=(HD_PIXELS(395) - position.y) / HD_PIXELS(53);//385
    return ccp(x, y);
}



- (id)getTreasureBoxAtPosition:(CGPoint)point
{
    for(TreasureBox *obj in _treasureBoxArray)
    {
        if (obj.boxPosition.x==point.x && obj.boxPosition.y==point.y) 
        {
            return obj;
        }
            
    }
    NSLog(@"Treasure Box not found!");
    return nil;
    
}

- (id)getSkullAtPosition:(CGPoint)point
{
    for(Skull *obj in _skullArray)
    {
        if(obj.skullPosition.x==point.x && obj.skullPosition.y==point.y)
        {
            return obj;
        }
    }
    NSLog(@"Skull not found!");
    return nil;
}

- (id)getFogAtPosition:(CGPoint)point
{
    for(Fog *obj in _fogArray)
    {
        if(obj.fogPosition.x==point.x && obj.fogPosition.y==point.y)
        {
            return obj;
        }
    }
    NSLog(@"Fog not found!");
    return nil;
}

- (NSString *)getIslandName:(NSString *)islandNumber
{
if([islandNumber isEqualToString:@"0"])
{
    return @"Cabin Boy";
}
else if([islandNumber isEqualToString:@"1"])
{
    return @"Swabbie";
}
else if([islandNumber isEqualToString:@"2"])
{
    return @"Deckhand";
}
else if([islandNumber isEqualToString:@"3"])
{
    return @"Helmsman";
}
else if([islandNumber isEqualToString:@"4"])
{
    return @"Captain";
}
else if([islandNumber isEqualToString:@"5"])
{
    return @"Pirate King";
}
else {
    return nil;
}

}

- (id)getCannoAtPosition:(CGPoint)point
{
    for(Cannon *obj in _cannonArray)
    {
        if (obj.cannonPosition.x==point.x && obj.cannonPosition.y==point.y) 
        {
            return obj;
        }
        
    }
    NSLog(@"cannon not found!");
    return nil;
    
}
- (id)getShipAtPosition:(CGPoint)point
{
    for(Ship *obj in _shipArray)
    {
        if (obj.shipPosition.x==point.x && obj.shipPosition.y==point.y) 
        {
            return obj;
        }
        
    }
    NSLog(@"ship not found!");
    return nil;
    
}


- (id)getMapAtPosition:(CGPoint)point
{
    for(TreasureMap *obj in _mapArray)
    {
        if (obj.mapPosition.x==point.x && obj.mapPosition.y==point.y) 
        {
            return obj;
        }
        
    }
    NSLog(@"map not found!");
    return nil;
    
}

-(id)getBoxAtPosition:(CGPoint)point
{
    for(BoxIcon *obj in _boxArray)
    {
       if (obj.position.x==point.x&&obj.position.y==point.y)
       {
           return obj;
       }
    }
    
    NSLog(@"box not found!");
    return nil;
}

-(CGPoint)getBoxPositionAt:(Direction)direction From:(CGPoint)point
{
    CGPoint newPoint=point;
    if(direction==LEFT)
    {
        newPoint.x=newPoint.x-EDGE_LENGTH;
    }
    else {
        newPoint.x=newPoint.x+EDGE_LENGTH;
    }
    return newPoint;
}

-(CGPoint)getItemPositionAtRowIndex:(int)rowIndex ItemIndex:(int)edgeIndex
{
    CGFloat pointY= rowIndex * EDGE_LENGTH + Y_MARGIN+0.5*EDGE_LENGTH;
    CGFloat pointX=0.5*EDGE_LENGTH+edgeIndex*EDGE_LENGTH+X_MARGIN;
    CGPoint point=ccp(pointX,pointY);
    return point;
}

- (void)showMessageBoxForTreasureBox
{
    [_window setImage:@"Graphic_Box_Small.png" text:@"Treasure Box" number:@"+2"];
    _window.waitToFadeInTreasureBoxMessageBox=1.0;
}

- (void)showMessageBoxForTreasureMap
{
    [_window setImage:@"Graphic_Map_Small.png" text:@"Treasure Map" number:@"+5"];
    //[_window.Icon setScale:0.7];
    _window.waitToFadeInTreasureBoxMessageBox=1.0;

}

- (void)showMessageBoxForSkull
{
    [_window setImage:@"Graphic_Skull_Small.png" text:@"Skull" number:@"-3"];
    _window.waitToFadeInTreasureBoxMessageBox=1.0;
}


-(void)fillBlockAtPositionX:(CGFloat)positionX 
                  PositionY:(CGFloat)positionY
                  WithColor:(BoxColor)color
{
    if(positionX >X_BOUNDARY_LEFT && positionX < X_BOUNDARY_RIGHT && positionY > Y_BOUNDARY_BOTTOM && positionY < Y_BOUNDARY_TOP)
    {
       // NSLog(@"block positionX: %f  positionY: %f",positionX,positionY);
                if(color==BLUE_BOX)
                {
                
                BoxIcon *block=[BoxIcon spriteWithSpriteFrameName:@"Graphic_BlueBox.png"];
                
                [block setScale:0];
                [block setPosition:ccp(positionX,positionY)];
                [_blockLayer addChild:block];
                    [_boxArray addObject:block];
                //tempSprite=block;
                    
                //_waitToShowBox=0.2;
                     [[SimpleAudioEngine sharedEngine] playEffect:@"player1score.wav"];
                    block.waitToShowBox=0.4;
                }
                
                else if(color==ORANGE_BOX)
                {
                    BoxIcon *block=[BoxIcon spriteWithSpriteFrameName:@"Graphic_OrangeBox.png"];
                    
                    [block setScale:0];
                    [block setPosition:ccp(positionX,positionY)];
                    [_blockLayer addChild:block];
                    [_boxArray addObject:block];
                    //tempSprite=block;
                   // _waitToShowBox=0.2;
                     [[SimpleAudioEngine sharedEngine] playEffect:@"player2score.wav"];
                    block.waitToShowBox=0.4;
                }
        }
       
       
        
        
        
    
}

-(void)blueIsOn
{
    //[_blueIndicator setOpacity:255];
    //[_orangeIndicator setOpacity:0];
   
    _waitToShowBlueIndicator=0.8;
    _waitToShowOrangeIndicator=-1;
     _waitToPlayOrangeIndicatorAnimation=-1;
    
}

-(void)orangeIsOn
{
    //[_blueIndicator setOpacity:0];
    //[_orangeIndicator setOpacity:250];
    
    _waitToShowOrangeIndicator=0.8;
    _waitToShowBlueIndicator=-1;
     _waitToPlayBlueIndicatorAnimation=-1;
    
}
-(void)blueIndicatorPlayAnimation
{
    CCAnimation *OpenAnimation=[CCAnimation animation];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_1.png"]];
    //[OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_4.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_3.png"]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_2.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_1.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_1.png"]];
    //[OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_4.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_3.png"]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_2.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_1.png" ]];
    //id OpenAnimationAction=[CCAnimate actionWithDuration:0.5 animation:OpenAnimation restoreOriginalFrame:NO];
    OpenAnimation.restoreOriginalFrame=NO;
    OpenAnimation.delayPerUnit=1.0 / OpenAnimation.frames.count;
    [_blueIndicator runAction:[[[CCAnimate alloc] initWithAnimation:OpenAnimation] autorelease]];
    
    _waitToPlayBlueIndicatorAnimation=3.3;
}

-(void)orangeIndicatorPlayAnimation
{
    CCAnimation *OpenAnimation=[CCAnimation animation];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_1.png"]];
   // [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_4.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_3.png"]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_2.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_1.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_1.png"]];
    //[OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_4.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_3.png"]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_2.png" ]];
    [OpenAnimation addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Graphic_Arrow_1.png" ]];
    //id OpenAnimationAction=[CCAnimate actionWithDuration:0.5 animation:OpenAnimation restoreOriginalFrame:NO];
    OpenAnimation.restoreOriginalFrame=NO;
    OpenAnimation.delayPerUnit=1.0 / OpenAnimation.frames.count;
    [_orangeIndicator runAction:[[[CCAnimate alloc] initWithAnimation:OpenAnimation] autorelease]];
    
    _waitToPlayOrangeIndicatorAnimation=3.3;

}


-(int)getTextName:(CCLabelTTF*)label
{
    
    if(label.string.length>0&&label.string.length<6)
    {
        return 16;
    }
    else if(label.string.length>5&&label.string.length<7)
    {
        return 13;
    }
    else if(label.string.length>6&&label.string.length<9){
        return 10;
    }
    else {
        return 7;
    }
}



-(void)drawEdgeAtPosition:(CGPoint)point 
                           AndColor:(NSString *)edgeColor
                           Vertical:(BOOL)isVertical
{
    EdgeGraphic *edge=[EdgeGraphic spriteWithSpriteFrameName:edgeColor];
    //[edge setScale:0];
    [edge setPosition:point];
   // [_lastEdge setScale:0];
    [_lastEdge setPosition:point];
   
    if(isVertical)
    {
        edge.rotation=90;
        _lastEdge.rotation=90;
        [_dot1 setPosition:ccp(point.x,(point.y+EDGE_LENGTH*0.5)) ];
        [_dot2 setPosition:ccp(point.x,(point.y-EDGE_LENGTH*0.5)) ];
       
    }
    else {
        _lastEdge.rotation=0;
        [_dot1 setPosition:ccp((point.x-EDGE_LENGTH*0.5),point.y) ];
        [_dot2 setPosition:ccp((point.x+EDGE_LENGTH*0.5),point.y) ];
    }
    [_lastEdge setVisible:YES];
   // _lastEdge.waitToShowEdge=0.2;
    [_dot1 setVisible:YES];
    [_dot2 setVisible:YES];
    
    _dot1.waitToShowDot=1.5;
    _dot2.waitToShowDot=1.5;
    [_edgeArray addObject:edge];
    [_edgeLayer addChild:edge];
    //edge.waitToShowEdge=0.2;
}

-(void)drawEdgeIndicatorAtPosition:(CGPoint)point
                 Vertical:(BOOL)isVertical
{
    [_edgeIndicator setVisible:YES];
    [_edgeIndicator setPosition:point];
    if(isVertical)
    {
        _edgeIndicator.rotation=90;
    }
    else {
        _edgeIndicator.rotation=0;
    }
    
}

- (void)resetView
{
    [_edgeLayer removeAllChildrenWithCleanup:YES];
    [_blockLayer removeAllChildrenWithCleanup:YES];
    [_orangeScoreBox reset];
    [_blueScoreBox reset];
    //[_gridView removeChild:_gridView.treasureBox1 cleanup:YES];
   
    for(TreasureBox *obj in _treasureBoxArray)
    {
        [self removeChild:obj cleanup:YES];
    }
    
    for(Cannon *obj in _cannonArray)
    {
        [self removeChild:obj cleanup:YES];
    }
    for(Ship *obj in _shipArray)
    {
        [self removeChild:obj cleanup:YES];
    }
    for(BoxIcon *obj in _boxArray)
    {
        [self removeChild:obj cleanup:YES];
    }
    for(TreasureMap *obj in _mapArray)
    {
        [self removeChild:obj cleanup:YES];
    }
    for(Skull *obj in _skullArray)
    {
        [self removeChild:obj cleanup:YES];
    }
    for (Fog *obj in _fogArray)
    {
        [self removeChild:obj cleanup:YES];
    }
    //[_gridView removeChild:_gridView.cannon1 cleanup:YES];
    
    
    // _gridView.waitToPlayTreasureBoxAnimation=0.3;
    //_gridView.treasureBox1.waitToPlayTreasureBoxAnimation=0.3;
   
    //[_lable setString:[NSString stringWithFormat:@"Please Start"]];
    [self blueIsOn];
    //[_orangeIndicator setOpacity:51];
    _edgeIndicator =[CCSprite spriteWithSpriteFrameName:[_parentController getEdgeIndicatorColor]];
    [_edgeIndicator setVisible:NO];
    [_lastEdge setVisible:NO];
    [_dot1 setVisible:NO];
    [_dot2 setVisible:NO];
    
    [_edgeLayer addChild:_edgeIndicator];
    [_treasureBoxArray removeAllObjects];
    [_cannonArray removeAllObjects];
    [_boxArray removeAllObjects];
    [_edgeArray removeAllObjects];
    [_shipArray removeAllObjects];
    [_mapArray removeAllObjects];
    [_skullArray removeAllObjects];
    [_fogArray removeAllObjects];
    
     [self loadPowerUpsAndsetupModel];
}
- (void)update:(ccTime)dt {
 
    if(_waitToShowBlueIndicator>0)
    {
        _waitToShowBlueIndicator=_waitToShowBlueIndicator-dt;
        if(_waitToShowBlueIndicator<=0.5 && _waitToShowBlueIndicator>=0)
        {
            [_blueIndicator setOpacity:((0.5-_waitToShowBlueIndicator)*510) ];
            
            if(_waitToShowBlueIndicator<0.5)
            {
            [_orangeIndicator setOpacity:(510*_waitToShowBlueIndicator)];
            }
        }
        
        if(_waitToShowBlueIndicator<0)
        {
            [_blueIndicator setOpacity:255];
            [_orangeIndicator setOpacity:0];
            _waitToPlayBlueIndicatorAnimation=1.0;
        }
        
    }
    
    if(_waitToShowOrangeIndicator>0)
    {
        _waitToShowOrangeIndicator=_waitToShowOrangeIndicator-dt;
        if(_waitToShowOrangeIndicator<=0.5 && _waitToShowOrangeIndicator>=0)
        {
            [_orangeIndicator setOpacity:((0.5-_waitToShowOrangeIndicator)*510) ];
            if(_waitToShowOrangeIndicator<0.5)
            {
            [_blueIndicator setOpacity:(510*_waitToShowOrangeIndicator)];
            }
        }
        
        if(_waitToShowOrangeIndicator<0)
        {
           [_orangeIndicator setOpacity:255];
            [_blueIndicator setOpacity:0];
            _waitToPlayOrangeIndicatorAnimation=1.0;
        }
        
    }
    
    
    
    if(_waitToPlayBackgroundMusic>0)
    {
        _waitToPlayBackgroundMusic=_waitToPlayBackgroundMusic-dt;
        if(_waitToPlayBackgroundMusic<0)
        {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusic.mp3"];
           // [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.5];
        }
    }
    if(_waitToPlayBlueIndicatorAnimation>0)
    {
        _waitToPlayBlueIndicatorAnimation=_waitToPlayBlueIndicatorAnimation-dt;
        if(_waitToPlayBlueIndicatorAnimation<0)
        {
            [self blueIndicatorPlayAnimation];
        }
    }
    
    if(_waitToPlayOrangeIndicatorAnimation>0)
    {
        _waitToPlayOrangeIndicatorAnimation=_waitToPlayOrangeIndicatorAnimation-dt;
        if(_waitToPlayOrangeIndicatorAnimation<0)
        {
            [self orangeIndicatorPlayAnimation];
        }
    }
    if(_waitToLoadFog>0)
    {
        _waitToLoadFog=_waitToLoadFog-dt;
        if(_waitToLoadFog<0)
        {
            [self loadfog];
        }
    }
    
    
    for (BoxIcon *obj in _boxArray)
    {
        [obj update:dt];
    }
    [_window update:dt];
    
    for(TreasureBox *obj in _treasureBoxArray)
    {
        [obj update:dt];
    }
    
    for(Cannon *obj in _cannonArray)
    {

        [obj update:dt];
    }
    
    for(Ship *obj in _shipArray)
    {
        [obj update:dt];
    }
    for (EdgeGraphic *obj in _edgeArray)
    {
        [obj update:dt];
    }
    for(TreasureMap *obj in _mapArray)
    {
        [obj update:dt];
    }
    for(Skull *obj in _skullArray)
    {
        [obj update:dt];
    }
    for (Fog *obj in _fogArray)
    {
        [obj update:dt];
    }
    
    [_lastEdge update:dt];
    [_gameoverWindow update:dt];
    [_howToPlayPage update:dt];
    [_dot1 update:dt];
    [_dot2 update:dt];
    
   

}

-(void)dealloc
{
    [_treasureBoxArray release];
    [_cannonArray release];
    [_boxArray release];
    [_edgeArray release];
    [_shipArray release];
    [_mapArray release];
    [_skullArray release];
    [_fogArray release];
    [super dealloc];
    
    
}
@end
