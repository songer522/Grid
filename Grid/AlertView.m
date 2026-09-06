//
//  AlertView.m
//  Grid
//

#import "AlertView.h"

// Alerts waiting for their turn on screen, plus the one currently showing.
static NSMutableArray *sPendingAlerts = nil;
static AlertView *sVisibleAlert = nil;

@interface AlertView ()
{
	NSMutableArray *buttonTitles_;
	BOOL hasCancelButton_;
	UIAlertController *controller_;
}
- (void)presentInViewController:(UIViewController *)host;
- (void)finishWithButtonIndex:(NSInteger)buttonIndex notifyDelegate:(BOOL)notify;
@end

@implementation AlertView

@synthesize delegate = delegate_, tag = tag_, title = title_, message = message_;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<AlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	if ((self = [super init])) {
		title_ = [title copy];
		message_ = [message copy];
		delegate_ = delegate;
		buttonTitles_ = [[NSMutableArray alloc] init];

		// UIAlertView put the cancel button at index 0 when it existed, and
		// numbered the other buttons after it.
		hasCancelButton_ = (cancelButtonTitle != nil);
		if (cancelButtonTitle)
			[buttonTitles_ addObject:cancelButtonTitle];

		if (otherButtonTitles) {
			[buttonTitles_ addObject:otherButtonTitles];

			va_list args;
			va_start(args, otherButtonTitles);
			NSString *next;
			while ((next = va_arg(args, NSString *)))
				[buttonTitles_ addObject:next];
			va_end(args);
		}
	}
	return self;
}

- (BOOL)isVisible
{
	return (sVisibleAlert == self);
}

#pragma mark - Presentation queue

+ (UIViewController *)topmostViewController
{
	UIWindow *keyWindow = nil;
	for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
		if (![scene isKindOfClass:[UIWindowScene class]])
			continue;
		for (UIWindow *candidate in ((UIWindowScene *)scene).windows) {
			if (candidate.isKeyWindow) {
				keyWindow = candidate;
				break;
			}
		}
		if (keyWindow)
			break;
	}

	UIViewController *top = keyWindow.rootViewController;
	while (top.presentedViewController)
		top = top.presentedViewController;

	return top;
}

+ (void)presentNextAlert
{
	// Some call sites (notably the App Store rating check) run on a background
	// thread. UIAlertView tolerated that; UIAlertController does not.
	if (![NSThread isMainThread]) {
		dispatch_async(dispatch_get_main_queue(), ^{ [AlertView presentNextAlert]; });
		return;
	}

	if (sVisibleAlert || sPendingAlerts.count == 0)
		return;

	UIViewController *host = [self topmostViewController];
	if (!host) {
		// No key window yet. Retry rather than return, or the queued alert
		// would sit there and block every alert behind it.
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
					   dispatch_get_main_queue(), ^{ [AlertView presentNextAlert]; });
		return;
	}

	AlertView *next = [[sPendingAlerts objectAtIndex:0] retain];
	[sPendingAlerts removeObjectAtIndex:0];
	sVisibleAlert = next;
	[next presentInViewController:host];
	[next release];
}

- (void)presentInViewController:(UIViewController *)host
{
	controller_ = [[UIAlertController alertControllerWithTitle:(title_.length ? title_ : nil)
	                                                   message:message_
	                                            preferredStyle:UIAlertControllerStyleAlert] retain];

	for (NSUInteger i = 0; i < buttonTitles_.count; i++) {
		UIAlertActionStyle style = (hasCancelButton_ && i == 0)
			? UIAlertActionStyleCancel
			: UIAlertActionStyleDefault;
		NSInteger buttonIndex = (NSInteger)i;

		[controller_ addAction:[UIAlertAction actionWithTitle:[buttonTitles_ objectAtIndex:i]
		                                                style:style
		                                              handler:^(UIAlertAction *action) {
			// UIKit has already dismissed the alert by the time this runs.
			[self finishWithButtonIndex:buttonIndex notifyDelegate:YES];
			[AlertView presentNextAlert];
		}]];
	}

	[host presentViewController:controller_ animated:YES completion:nil];
}

- (void)finishWithButtonIndex:(NSInteger)buttonIndex notifyDelegate:(BOOL)notify
{
	// Autoreleased rather than released: the action handler calling us is
	// owned by this controller.
	[controller_ autorelease];
	controller_ = nil;
	if (sVisibleAlert == self)
		sVisibleAlert = nil;

	if (notify && [delegate_ respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
		[delegate_ alertView:self clickedButtonAtIndex:buttonIndex];

	// Balances the retain taken in -show.
	[self autorelease];
}

#pragma mark - Public API

- (void)show
{
	if (![NSThread isMainThread]) {
		[self retain];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self show];
			[self release];
		});
		return;
	}

	if (!sPendingAlerts)
		sPendingAlerts = [[NSMutableArray alloc] init];

	// UIAlertView kept itself alive while on screen; call sites rely on being
	// able to release right after -show.
	[self retain];
	[sPendingAlerts addObject:self];
	[AlertView presentNextAlert];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
	if (![NSThread isMainThread]) {
		[self retain];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self dismissWithClickedButtonIndex:buttonIndex animated:animated];
			[self release];
		});
		return;
	}

	if ([sPendingAlerts containsObject:self]) {
		[sPendingAlerts removeObject:self];
		[self autorelease];
		return;
	}

	if (sVisibleAlert != self)
		return;

	UIAlertController *presented = [controller_ retain];
	[self finishWithButtonIndex:buttonIndex notifyDelegate:(buttonIndex >= 0)];
	[presented dismissViewControllerAnimated:animated completion:^{
		[presented release];
		// The queue only advances once the previous alert is really gone.
		[AlertView presentNextAlert];
	}];
}

- (void)dealloc
{
	[title_ release];
	[message_ release];
	[buttonTitles_ release];
	[controller_ release];
	[super dealloc];
}

@end
