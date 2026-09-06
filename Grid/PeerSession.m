//
//  PeerSession.m
//  Grid
//

#import "PeerSession.h"

NSString * const kPeerServiceType = @"piratelines";

@interface PeerSession () <MCSessionDelegate>
{
	MCSession *session_;
	id<PeerSessionDataReceiveHandler> dataHandler_;
	void *dataContext_;
}
@end

@implementation PeerSession

@synthesize delegate = delegate_;

- (id)initWithMCSession:(MCSession *)session
{
	if ((self = [super init])) {
		session_ = [session retain];
		session_.delegate = self;
	}
	return self;
}

- (MCSession *)mcSession
{
	return session_;
}

- (void)setDataReceiveHandler:(id<PeerSessionDataReceiveHandler>)handler withContext:(void *)context
{
	dataHandler_ = handler;
	dataContext_ = context;
}

- (BOOL)sendDataToAllPeers:(NSData *)data withDataMode:(PeerSendDataMode)mode error:(NSError **)error
{
	if (session_.connectedPeers.count == 0)
		return NO;

	MCSessionSendDataMode sendMode = (mode == PeerSendDataUnreliable)
		? MCSessionSendDataUnreliable
		: MCSessionSendDataReliable;

	return [session_ sendData:data toPeers:session_.connectedPeers withMode:sendMode error:error];
}

- (void)disconnectFromAllPeers
{
	[session_ disconnect];
}

#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
	PeerConnectionState mapped;
	switch (state) {
		case MCSessionStateConnected:    mapped = PeerStateConnected;    break;
		case MCSessionStateConnecting:   mapped = PeerStateConnecting;   break;
		case MCSessionStateNotConnected:
		default:                         mapped = PeerStateDisconnected; break;
	}

	NSString *name = [peerID.displayName copy];
	dispatch_async(dispatch_get_main_queue(), ^{
		if ([self->delegate_ respondsToSelector:@selector(session:peer:didChangeState:)])
			[self->delegate_ session:self peer:name didChangeState:mapped];
		[name release];
	});
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
	// The game's handler is declared against NSMutableData, as GKSession's was.
	NSMutableData *payload = [data mutableCopy];
	NSString *name = [peerID.displayName copy];

	dispatch_async(dispatch_get_main_queue(), ^{
		[self->dataHandler_ receiveData:payload
							   fromPeer:name
							  inSession:self
								context:self->dataContext_];
		[payload release];
		[name release];
	});
}

// The game only ever exchanges small archived dictionaries, so the streaming
// and resource callbacks are unused.
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {}
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {}
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {}

- (void)dealloc
{
	session_.delegate = nil;
	[session_ release];
	[super dealloc];
}

@end
