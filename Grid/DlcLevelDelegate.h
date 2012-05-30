//
//  DlcLevelDelegate.h
//  Grid
//
//  Created by Yang Song on 5/21/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kInAppPurchaseUpgradeToFullVersion @"com.xecudev.Grid.fullVersion"


@protocol DlcLevelDelegate <NSObject>

-(void)updateDlcLevels;
-(void)openErrorWindowCantConnectToStore;
-(void)openErrorWindowCantMakePurchases;
-(void)setCantConnectToStore:(BOOL)CantConnectToStore;
-(void)setCantMakePurchases:(BOOL)CantMakePurchases;


@end
