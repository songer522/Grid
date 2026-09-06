//
//  ScreenLayout.m
//  Grid
//

#import "ScreenLayout.h"
#import "DeviceSettings.h"
#import "cocos2d.h"

static BOOL sValid = NO;
static CGSize sSceneSize;
static CGPoint sContentOrigin;
static UIEdgeInsets sSafeInsets;

void GridScreenLayoutInvalidate(void)
{
	sValid = NO;
}

static void GridScreenLayoutEnsure(void)
{
	CCDirectorIOS *director = (CCDirectorIOS *)[CCDirector sharedDirector];
	CGSize size = [director winSize];
	CGPoint origin = [director contentOrigin];
	UIEdgeInsets insets = [director safeAreaInsetsInPoints];

	if( sValid
	   && CGSizeEqualToSize(size, sSceneSize)
	   && CGPointEqualToPoint(origin, sContentOrigin)
	   && UIEdgeInsetsEqualToEdgeInsets(insets, sSafeInsets) )
		return;

	sSceneSize = size;
	sContentOrigin = origin;
	sSafeInsets = insets;
	sValid = YES;
}

CGSize GridSceneSize(void)
{
	GridScreenLayoutEnsure();
	return sSceneSize;
}

CGPoint GridContentOrigin(void)
{
	GridScreenLayoutEnsure();
	return sContentOrigin;
}

UIEdgeInsets GridSafeInsets(void)
{
	GridScreenLayoutEnsure();
	return sSafeInsets;
}

float GridTopY(float insetFromDesignTop)
{
	GridScreenLayoutEnsure();
	float original = ADJUST_Y(kScreenHeight - insetFromDesignTop);
	float pinned = sSceneSize.height - sSafeInsets.top - ADJUST_LEN_Y(insetFromDesignTop);
	return original + kEdgePushRatio * (pinned - original);
}

float GridBottomY(float insetFromDesignBottom)
{
	GridScreenLayoutEnsure();
	float original = ADJUST_Y(insetFromDesignBottom);
	float pinned = sSafeInsets.bottom + ADJUST_LEN_Y(insetFromDesignBottom);
	return original + kEdgePushRatio * (pinned - original);
}
