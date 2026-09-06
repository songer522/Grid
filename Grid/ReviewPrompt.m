//
//  ReviewPrompt.m
//  Grid
//

#import "ReviewPrompt.h"

#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>

// Matches the threshold Appirater used.
static NSString * const kLaunchCountKey = @"ReviewPromptLaunchCount";
static NSString * const kAppiraterLaunchCountKey = @"kAppiraterUseCount";
static const NSInteger kLaunchesUntilPrompt = 3;

@implementation ReviewPrompt

+ (void)appLaunched
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	// Carry over the count Appirater kept, so players who already have the game
	// aren't treated as first-time users.
	if (![defaults objectForKey:kLaunchCountKey]) {
		NSInteger inherited = [defaults integerForKey:kAppiraterLaunchCountKey];
		if (inherited > 0)
			[defaults setInteger:inherited forKey:kLaunchCountKey];
	}

	NSInteger launches = [defaults integerForKey:kLaunchCountKey] + 1;
	[defaults setInteger:launches forKey:kLaunchCountKey];

	if (launches < kLaunchesUntilPrompt)
		return;

	// StoreKit decides whether to actually show anything, and will not show
	// the prompt more than a few times a year.
	dispatch_async(dispatch_get_main_queue(), ^{
		for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
			if ([scene isKindOfClass:[UIWindowScene class]]) {
				[SKStoreReviewController requestReviewInScene:(UIWindowScene *)scene];
				return;
			}
		}
	});
}

@end
