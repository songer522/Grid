//
//  PeerPickerController.m
//  Grid
//

#import "PeerPickerController.h"

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <UIKit/UIKit.h>

#import "PeerSession.h"

@interface PeerPickerController () <MCBrowserViewControllerDelegate, MCSessionDelegate>
{
	MCPeerID *peerID_;
	MCSession *mcSession_;
	MCAdvertiserAssistant *advertiser_;
	MCBrowserViewController *browser_;
	PeerSession *session_;
	BOOL didFinish_;
}
@end

@implementation PeerPickerController

@synthesize delegate = delegate_;

- (id)init
{
	if ((self = [super init])) {
		peerID_ = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
		mcSession_ = [[MCSession alloc] initWithPeer:peerID_
										securityIdentity:nil
									encryptionPreference:MCEncryptionRequired];
		mcSession_.delegate = self;
	}
	return self;
}

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

- (void)show
{
	// Advertising and browsing at the same time lets either player start the
	// connection, which is how the old picker behaved.
	advertiser_ = [[MCAdvertiserAssistant alloc] initWithServiceType:kPeerServiceType
													  discoveryInfo:nil
															session:mcSession_];
	[advertiser_ start];

	browser_ = [[MCBrowserViewController alloc] initWithServiceType:kPeerServiceType
														   session:mcSession_];
	browser_.delegate = self;
	browser_.minimumNumberOfPeers = 2;
	browser_.maximumNumberOfPeers = 2;

	[[PeerPickerController topmostViewController] presentViewController:browser_ animated:YES completion:nil];
}

- (void)dismiss
{
	[advertiser_ stop];

	if (browser_.presentingViewController)
		[browser_ dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Connection

// Called once, whichever side completes the handshake first.
- (void)finishWithPeer:(NSString *)peerName
{
	if (didFinish_)
		return;
	didFinish_ = YES;

	[advertiser_ stop];

	// Hand the live session over before the browser goes away, so the next
	// scene is already wired up when it appears.
	session_ = [[PeerSession alloc] initWithMCSession:mcSession_];

	void (^notify)(void) = ^{
		if ([self->delegate_ respondsToSelector:@selector(peerPickerController:didConnectPeer:toSession:)])
			[self->delegate_ peerPickerController:self didConnectPeer:peerName toSession:self->session_];
	};

	if (browser_.presentingViewController)
		[browser_ dismissViewControllerAnimated:YES completion:notify];
	else
		notify();
}

#pragma mark - MCBrowserViewControllerDelegate

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
	MCPeerID *peer = mcSession_.connectedPeers.firstObject;
	if (peer)
		[self finishWithPeer:peer.displayName];
	else
		[self browserViewControllerWasCancelled:browserViewController];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
	if (didFinish_)
		return;
	didFinish_ = YES;

	[advertiser_ stop];
	[browser_ dismissViewControllerAnimated:YES completion:^{
		if ([self->delegate_ respondsToSelector:@selector(peerPickerControllerDidCancel:)])
			[self->delegate_ peerPickerControllerDidCancel:self];
	}];
}

#pragma mark - MCSessionDelegate

// PeerSession takes over as the session's delegate once the handshake lands;
// until then this object watches for the first connected peer.
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
	if (state != MCSessionStateConnected)
		return;

	NSString *name = [peerID.displayName copy];
	dispatch_async(dispatch_get_main_queue(), ^{
		[self finishWithPeer:name];
		[name release];
	});
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {}
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {}
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {}
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {}

- (void)dealloc
{
	browser_.delegate = nil;
	[browser_ release];
	[advertiser_ release];
	[session_ release];
	[mcSession_ release];
	[peerID_ release];
	[super dealloc];
}

@end
