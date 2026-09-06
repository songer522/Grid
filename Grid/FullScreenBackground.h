//
//  FullScreenBackground.h
//  Grid
//
//  Keeps the authored background sprite at its native size in the design box
//  and stretches 2-point edge slivers to fill any extra scene space.
//

#import "cocos2d.h"

@interface FullScreenBackground : CCNode
{
	CCSprite *_main;
	CCSprite *_topSliver;
	CCSprite *_bottomSliver;
	CCSprite *_leftSliver;
	CCSprite *_rightSliver;
	CGSize _laidOutSize;
}

+ (id)backgroundWithSpriteFrameName:(NSString *)frameName;
+ (void)stretchSpriteToFillScene:(CCSprite *)sprite;

@end
