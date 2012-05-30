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
#import "GameLayer.h"
#import "GameSettings.h"
#import "Box.h"




@implementation GridView
@synthesize edgeIndicator=_edgeIndicator;
//@synthesize lable=_lable;
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
        int newNumber=[islandNumber intValue];
        NSString *newIslandNumber=[NSString stringWithFormat:@"%d",(newNumber+1)];
        NSString *levelNumber=[[GameSettings shared] getGlobalForKey:@"levelNumberOnButton"];
        
        
        _lable=[CCLabelTTF labelWithString:[NSString stringWithFormat: @"Level %@-%@",newIslandNumber,levelNumber] fontName:@"Impact" fontSize: HD_TEXT(14)];
        [_lable setColor:ccc3(25, 25, 25)];
        _lable.position=ADJUST_CCP(ccp(160,465)) ;//FULL VERSION CHANGE BACK 110 to 415
        
        //_playerIndicator=[CCSprite spriteWithSpriteFrameName:@"Graphic_TextBlue.png"];
        //[_playerIndicator setPosition:ADJUST_CCP(ccp(60,415))];
        
        //_playerIndicator2=[CCSprite spriteWithSpriteFrameName:@"Graphic_TextBlue.png"];
        //[_playerIndicator2 setPosition:ADJUST_CCP(ccp(260,415))];
       
        _blueIndicator=[CCSprite spriteWithSpriteFrameName:@"Graphic_BluesTurn.png"];
        [_blueIndicator setPosition:ADJUST_CCP(ccp(155,455))];
        
        _orangeIndicator=[CCSprite spriteWithSpriteFrameName:@"Graphic_OrangesTurn.png"];
        [_orangeIndicator setPosition:ADJUST_CCP(ccp(155,455))];

        CCSprite *levelNumBack=[CCSprite spriteWithSpriteFrameName:@"Graphic_LevelNumber.png"];
        [levelNumBack setPosition:ADJUST_CCP(ccp(155,455))];
        
        _edgeLayer=[CCLayer node];
        _blockLayer=[CCLayer node];
        
        _blueScoreBox=[ScoreBox ScoreBoxWithImage:@"Graphic_BlueScore.png" andPosition:ADJUST_CCP(ccp(50,96))]; //FULL VERSION 76

        _orangeScoreBox=[ScoreBox ScoreBoxWithImage:@"Graphic_OrangeScore.png" andPosition:ADJUST_CCP(ccp(270,96))];//FULL VERSION 76

        
        _theNewGameButton=[CCSprite spriteWithSpriteFrameName:@"Button_NewGame.png"];
        _menuButton=[CCSprite spriteWithSpriteFrameName:@"Button_Menu.png"];
        _helpButton=[CCSprite spriteWithSpriteFrameName:@"Button_HTP.png"];
        
        
        _isSoundOn=YES;
        NSString *soundSetting=[[GameSettings shared] getGlobalForKey:@"isSoundOn"];
        if([soundSetting isEqualToString:@"NO"])
        {
            _isSoundOn=NO;
        }
        else 
        {
            _isSoundOn=YES;
        }
        if(_isSoundOn)
        {
            _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOn.png"];
        }
        else {
            _soundButton=[CCSprite spriteWithSpriteFrameName:@"Button_SoundOff.png"];
        }

        [_soundButton setPosition:ADJUST_CCP(ccp(290,455))];
        
        [_helpButton setPosition:ADJUST_CCP(ccp(240,455))];
        
        
        
        [_theNewGameButton setPosition:ADJUST_CCP(ccp(30,455))];
        [_menuButton setPosition:ADJUST_CCP(ccp(80,455))];
        _window=[MessageWindow GameWindowWithImage:@"Graphic_TBox_1.png" text:@"Treasure Points" number:@"+5" andPosition:ADJUST_CCP(ccp(160,96))];//FULL VERSION CHANGE BACK 110 to 70

        [_window setOpacity:0];  
       
       
        //tileMap = [CCTMXTiledMap tiledMapWithTMXFile: [CCFileUtils fullPathFromRelativePath:@"DAL_Level1.tmx"]];
        
        NSString *LevelNumber=[[GameSettings shared] getGlobalForKey:@"selectedLevel"];
        
        tileMap = [CCTMXTiledMap tiledMapWithTMXFile: [NSString stringWithFormat:@"DAL_Level%@.tmx",LevelNumber ]];
        
        _itemLayer = [tileMap layerNamed:@"Items"];
        _itemLayer.visible = NO;
        
        _lineRightLayer=[tileMap layerNamed:@"Right"];
        _lineDownLayer=[tileMap layerNamed:@"Down"];
        
        [tileMap setPosition:ADJUST_CCP(ccp(1,113.5))];//93.5  FULL VERSION CHANGE BACK
       // _powerUpsArray=[NSMutableArray arrayWithObjects:_treasureBox1, nil];

        
        
        
        
        
        _treasureBoxArray=[[NSMutableArray alloc] init ];
        _cannonArray=[[NSMutableArray alloc] init];
        _boxArray=[[NSMutableArray alloc] init];
        _edgeArray=[[NSMutableArray alloc] init];
        _shipArray=[[NSMutableArray alloc] init];
        _mapArray=[[NSMutableArray alloc] init];
        
        [self addChild:_background];
        [self addChild:tileMap];
        //[self addChild:_dashLines];
        [self addChild:_blockLayer];
        [self addChild:_edgeLayer];
        [self addChild:_dots];
        
       // [self addChild:_playerIndicator];
       // [self addChild:_playerIndicator2];
        [self addChild:_blueIndicator];
        [self addChild:_orangeIndicator];
        [self addChild:levelNumBack];
        [self addChild:_lable];
        [self addChild:_blueScoreBox];
        [self addChild:_orangeScoreBox];
        
        [self blueIsOn];
        //[_orangeIndicator setOpacity:51];
        //[[GameSettings shared] getGlobalForKey:@""];
        if( [_parentController.gameMode isEqualToString:@"solo"])
        {
            CCLabelTTF *player1= [CCLabelTTF labelWithString:[[GameSettings shared] getGlobalForKey:@"Player1Name"] dimensions:CGSizeMake(HD_PIXELS(100), HD_PIXELS(25)) alignment:UITextAlignmentLeft fontName:@"Impact" fontSize:HD_TEXT(20)];
           // CCLabelTTF *player1=[CCLabelTTF labelWithString:[[GameSettings shared] getGlobalForKey:@"Player1Name"] fontName:@"Impact" fontSize:HD_TEXT(20)];
            //CCLabelTTF *player2=[CCLabelTTF labelWithString:@"CPU" fontName:@"Impact" fontSize:HD_TEXT(20)];
            CCLabelTTF *player2=[CCLabelTTF labelWithString:@"CPU" dimensions:CGSizeMake(HD_PIXELS(100), HD_PIXELS(25)) alignment:UITextAlignmentRight fontName:@"Impact" fontSize:HD_TEXT(20)];
            [player1 setPosition:ADJUST_CCP(ccp(131,76))];
            [player2 setPosition:ADJUST_CCP(ccp(189,76))];
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
            CCLabelTTF *player1=[CCLabelTTF labelWithString:[[GameSettings shared] getGlobalForKey:@"Player1Name"] dimensions:CGSizeMake(HD_PIXELS(100), HD_PIXELS(25)) alignment:UITextAlignmentLeft fontName:@"Impact" fontSize:HD_TEXT(20)];
            CCLabelTTF *player2=[CCLabelTTF labelWithString:[[GameSettings shared] getGlobalForKey:@"Player2Name"] dimensions:CGSizeMake(HD_PIXELS(100), HD_PIXELS(25)) alignment:UITextAlignmentRight fontName:@"Impact" fontSize:HD_TEXT(20)];
            
            [player1 setPosition:ADJUST_CCP(ccp(131,76))];
            [player2 setPosition:ADJUST_CCP(ccp(189,76))];
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
            [player1 setPosition:ADJUST_CCP(ccp(131,76))];
            [player2 setPosition:ADJUST_CCP(ccp(189,76))];
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
         
    
       // [self loadiAd];
        
    
        }
        
    return self;
}

-(void)loadiAd
{
    UIViewController *controller = [[UIViewController alloc] init];
    
   if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
   {
       controller.view.frame = CGRectMake(0,ADJUST_Y(463),HD_PIXELS(480),HD_PIXELS(32));
   }
   else {
       controller.view.frame=CGRectMake(0, 430, 480, 32);
   }
       [controller.view setBackgroundColor:[UIColor clearColor]];
    
    //From the official iAd programming guide
    ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    [adView setBackgroundColor:[UIColor clearColor]];
    adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
    
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    
    CGRect adFrame = adView.frame;
    adFrame.origin.y =  [CCDirector sharedDirector].view.frame.size.height-adView.frame.size.height;
    adView.frame = adFrame;
    adView.delegate=self;
    [controller.view addSubview:adView];
    
    //Then I add the adView to the openglview of cocos2d
    //[[[CCDirector sharedDirector] view] addSubview:controller.view];
    [[[CCDirector sharedDirector] view] addSubview:adView];
    
}



-(void)loadPowerUpsAndsetupModel
{
    for(int positionX = HD_PIXELS(27.5); positionX< X_BOUNDARY_RIGHT; positionX=positionX+EDGE_LENGTH )
    {
        for (int positionY= HD_PIXELS(140); positionY<Y_BOUNDARY_TOP; positionY=positionY+EDGE_LENGTH) {
            //CCSprite *dot=[CCSprite spriteWithSpriteFrameName:@"Graphic_Dot.png"];
            //[dot setPosition:ccp(positionX,positionY)];
            //[_dots addChild:dot];
            CGPoint tileCoord = [self tileCoordForPosition:ccp(positionX,positionY)];
            BOOL rightLineFilled=NO;
            int tileGid = [_lineRightLayer tileGIDAt:tileCoord];
            if (tileGid) {
                NSDictionary *properties = [tileMap propertiesForGID:tileGid];
                if (properties) {
                    NSString *collision = [properties valueForKey:@"RowFilled"];
                    if (collision && [collision compare:@"True"] == NSOrderedSame) {
                        Edge *edge= [_parentController.gridModel getEdgeAtRowIndex:tileCoord.x EdgeIndex:(NUM_OF_LINES-tileCoord.y)];
                        edge.isFilled=NO;
                        rightLineFilled=YES;
                        NSLog(@"row edge Filled (%f,%f) position (%d,%d), tileGid:%d",tileCoord.x,tileCoord.y,positionX,positionY,tileGid);
                    }
                }
            }
            
            int tileGid2 = [_lineDownLayer tileGIDAt:tileCoord];
            if (tileGid2) {
                NSDictionary *properties = [tileMap propertiesForGID:tileGid2];
                if (properties) {
                    NSString *collision = [properties valueForKey:@"LineFilled"];
                    if (collision && [collision compare:@"True"] == NSOrderedSame) {
                        Edge *edge=[_parentController.gridModel getEdgeAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) EdgeIndex:tileCoord.x];
                        edge.isFilled=NO;
                         NSLog(@"line edge Filled (%f,%f) position (%d,%d), tileGid:%d",tileCoord.x,tileCoord.y,positionX,positionY,tileGid2);
                        
                        if(rightLineFilled)
                        {
                            
                        }
                    }
                }
            }
            int tileGid3 = [_itemLayer tileGIDAt:tileCoord];
            if (tileGid3) {
                NSDictionary *properties = [tileMap propertiesForGID:tileGid3];
                if (properties) {
                    NSString *collision = [properties valueForKey:@"Item"];
                    if (collision && [collision compare:@"TreasureBox"] == NSOrderedSame) {
                        Box *box=[_parentController.gridModel getBoxAtLineIndex:(NUM_OF_LINES-1-tileCoord.y) BoxIndex:tileCoord.x];
                        box.status=TREASUREBOX;
                        [_parentController loadBoxPatternAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                        [_parentController loadTreasureBoxAtRow:tileCoord.x ItemIndex:(NUM_OF_LINES-tileCoord.y)];
                    }
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
                        [mapIndicator1 setPosition:ADJUST_CCP(ccp(50,45))];
                        [_blockLayer addChild:mapIndicator1];
                        CCSprite *mapIndicator2=[CCSprite spriteWithSpriteFrameName:@"Graphic_TmapBack.png"];
                        [mapIndicator2 setPosition:ADJUST_CCP(ccp(270,45))];
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
    _edgeIndicator =[CCSprite spriteWithSpriteFrameName:[_parentController getEdgeColor]];
    [_edgeIndicator setVisible:NO]; 
    _edgeIndicator =[CCSprite spriteWithSpriteFrameName:[_parentController getEdgeColor]];
    [_edgeIndicator setVisible:NO]; 
    [_edgeLayer addChild:_edgeIndicator];
    
    
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
   
    // int x = (position.x-X_MARGIN) / tileMap.tileSize.width;
    int x = (position.x+1-HD_PIXELS(27.5)) / HD_PIXELS(53);
    //int y = ((tileMap.mapSize.height * tileMap.tileSize.height) - position.y) / tileMap.tileSize.height;
    int y=(HD_PIXELS(405) - position.y) / HD_PIXELS(53);//385
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
                    block.waitToShowBox=0.4;
                }
        }
       
       
        
        
        
    
}

-(void)blueIsOn
{
    //[_blueIndicator setOpacity:255];
    //[_orangeIndicator setOpacity:51];
   
    _waitToShowBlueIndicator=0.8;
    _waitToShowOrangeIndicator=-1;
    
}

-(void)orangeIsOn
{
    //[_blueIndicator setOpacity:51];
    //[_orangeIndicator setOpacity:250];
    
    _waitToShowOrangeIndicator=0.8;
    _waitToShowBlueIndicator=-1;
    
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
    
     [self loadPowerUpsAndsetupModel];
}
- (void)update:(ccTime)dt {
 
    if(_waitToShowBlueIndicator>0)
    {
        _waitToShowBlueIndicator=_waitToShowBlueIndicator-dt;
        if(_waitToShowBlueIndicator<=0.5 && _waitToShowBlueIndicator>=0.1)
        {
            [_blueIndicator setOpacity:((0.6-_waitToShowBlueIndicator)*510) ];
            
            if(_waitToShowBlueIndicator<0.5)
            {
            [_orangeIndicator setOpacity:(510*_waitToShowBlueIndicator)];
            }
        }
        
        if(_waitToShowBlueIndicator<0)
        {
            [_blueIndicator setOpacity:255];
            [_orangeIndicator setOpacity:51];
        }
        
    }
    
    if(_waitToShowOrangeIndicator>0)
    {
        _waitToShowOrangeIndicator=_waitToShowOrangeIndicator-dt;
        if(_waitToShowOrangeIndicator<=0.5 && _waitToShowOrangeIndicator>=0.1)
        {
            [_orangeIndicator setOpacity:((0.6-_waitToShowOrangeIndicator)*510) ];
            if(_waitToShowOrangeIndicator<0.5)
            {
            [_blueIndicator setOpacity:(510*_waitToShowOrangeIndicator)];
            }
        }
        
        if(_waitToShowOrangeIndicator<0)
        {
           [_orangeIndicator setOpacity:255];
            [_blueIndicator setOpacity:51];
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
    
    [_lastEdge update:dt];
    [_gameoverWindow update:dt];
    [_howToPlayPage update:dt];
    [_dot1 update:dt];
    [_dot2 update:dt];
    
   

}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
}


-(void)dealloc
{
    [_treasureBoxArray release];
    [_cannonArray release];
    [_boxArray release];
    [_edgeArray release];
    [_shipArray release];
    [_mapArray release];
    [super dealloc];
    
}
@end
