//
//  ScreenLayout.h
//  Grid
//
//  Cached scene-size / safe-area queries for the extend-mode director.
//

#ifndef Grid_ScreenLayout_h
#define Grid_ScreenLayout_h

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

CGSize GridSceneSize(void);
CGPoint GridContentOrigin(void);
UIEdgeInsets GridSafeInsets(void);
void GridScreenLayoutInvalidate(void);

float GridTopY(float insetFromDesignTop);
float GridBottomY(float insetFromDesignBottom);

#endif
