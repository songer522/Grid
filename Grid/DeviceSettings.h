//
//  DeviceSettings.h
//  grid
//
//  Created by Yang Song on 4/12/12.
//  Copyright (c) 2012 XecuDev. All rights reserved.
//

#import <UIKit/UIDevice.h>
#import "ScreenLayout.h"

/*  DETERMINE THE DEVICE USED  */
// UI_USER_INTERFACE_IDIOM is no longer a preprocessor macro, so the #ifdef this
// used to sit behind silently compiled the whole iPad layout out of existence.
#define IS_IPAD() ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

/*  NORMAL DETAILS */
#define kScreenHeight       480
#define kScreenWidth        320

/* OFFSETS TO ACCOMMODATE IPAD */
#define kXoffsetiPad        64
#define kYoffsetiPad        32

/* 1.0 pins HUD to the safe-area edge; 0.0 keeps the authored 320x480 seat. */
#define kEdgePushRatio      1.0f

#define SD_PNG      @".png"
#define HD_PNG      @"-hd.png"

#define ADJUST_LEN_X(__x__)     \
(IS_IPAD() == YES ?             \
( __x__ * 2 ) :                 \
__x__)

#define ADJUST_LEN_Y(__y__)     \
(IS_IPAD() == YES ?             \
( __y__ * 2 ) :                 \
__y__)

#define ADJUST_CCP(__p__)       \
(IS_IPAD() == YES ?             \
ccp( ( __p__.x * 2 ) + kXoffsetiPad + GridContentOrigin().x, ( __p__.y * 2 ) + kYoffsetiPad + GridContentOrigin().y ) : \
ccp( __p__.x + GridContentOrigin().x, __p__.y + GridContentOrigin().y ))

#define REVERSE_CCP(__p__)      \
(IS_IPAD() == YES ?             \
ccp( ( __p__.x - GridContentOrigin().x - kXoffsetiPad ) / 2, ( __p__.y - GridContentOrigin().y - kYoffsetiPad ) / 2 ) : \
ccp( __p__.x - GridContentOrigin().x, __p__.y - GridContentOrigin().y ))

#define ADJUST_XY(__x__, __y__)     \
(IS_IPAD() == YES ?                     \
ccp( ( __x__ * 2 ) + kXoffsetiPad + GridContentOrigin().x, ( __y__ * 2 ) + kYoffsetiPad + GridContentOrigin().y ) : \
ccp((__x__) + GridContentOrigin().x, (__y__) + GridContentOrigin().y))

#define ADJUST_X(__x__)         \
(IS_IPAD() == YES ?             \
( __x__ * 2 ) + kXoffsetiPad + GridContentOrigin().x :      \
(__x__) + GridContentOrigin().x)

#define ADJUST_Y(__y__)         \
(IS_IPAD() == YES ?             \
( __y__ * 2 ) + kYoffsetiPad + GridContentOrigin().y :      \
(__y__) + GridContentOrigin().y)

#define TOP_Y(__inset__)            GridTopY(__inset__)
#define BOTTOM_Y(__inset__)         GridBottomY(__inset__)
#define TOP_CCP(__x__, __inset__)   ccp(ADJUST_X(__x__), TOP_Y(__inset__))
#define BOTTOM_CCP(__x__, __inset__) ccp(ADJUST_X(__x__), BOTTOM_Y(__inset__))

#define HD_PIXELS(__pixels__)       \
(IS_IPAD() == YES ?             \
( __pixels__ * 2 ) :                \
__pixels__)

#define HD_TEXT(__size__)   \
(IS_IPAD() == YES ?         \
( __size__ * 2.0 ) :            \
__size__)
#define HD_TEXT2(__size__)   \
(IS_IPAD() == YES ?         \
( __size__ * 2.5 ) :            \
__size__)

#define HD_TEXT3(__size__)   \
(IS_IPAD() == YES ?         \
( __size__ * 3.0 ) :            \
__size__)

#define SD_OR_HD(__filename__)  \
(IS_IPAD() == YES ?             \
[__filename__ stringByReplacingOccurrencesOfString:SD_PNG withString:HD_PNG] :  \
__filename__)

/* SD/HD Font file */
#define SD_FNT          @".fnt"
#define HD_FNT          @"-hd.fnt"

/* SD/HD Spritesheet plist */
#define SD_PLIST                @".plist"
#define HD_PLIST                @"-hd.plist"

#define SD_HD_FONT(__filename__)   \
(IS_IPAD() == YES ?     \
[__filename__ stringByReplacingOccurrencesOfString:SD_FNT withString:HD_FNT] :  \
__filename__)

#define SD_HD_PLIST(__filename__)   \
(IS_IPAD() == YES ?     \
[__filename__ stringByReplacingOccurrencesOfString:SD_PLIST withString:HD_PLIST] :   \
__filename__)
