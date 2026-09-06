//
//  PeerSession.h
//  Grid
//
//  Replacement for GKSession, which Apple removed along with the rest of the
//  peer-to-peer GameKit API. Backed by MultipeerConnectivity but keeps the
//  GKSession surface the game was written against, so the nearby-play code in
//  the menus and the game layer is unchanged.
//
//  MultipeerConnectivity delivers its callbacks on a background queue; this
//  class forwards everything on the main thread, because every caller here
//  touches cocos2d scene state.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

/** Bonjour service type shared by the browser and the advertiser. */
extern NSString * const kPeerServiceType;

typedef NS_ENUM(NSInteger, PeerConnectionState) {
	PeerStateAvailable,
	PeerStateUnavailable,
	PeerStateConnected,
	PeerStateConnecting,
	PeerStateDisconnected,
};

typedef NS_ENUM(NSInteger, PeerSendDataMode) {
	PeerSendDataReliable,
	PeerSendDataUnreliable,
};

@class PeerSession;

@protocol PeerSessionDelegate <NSObject>
@optional
- (void)session:(PeerSession *)session peer:(NSString *)peerID didChangeState:(PeerConnectionState)state;
- (void)session:(PeerSession *)session didFailWithError:(NSError *)error;
@end

@protocol PeerSessionDataReceiveHandler <NSObject>
- (void)receiveData:(NSMutableData *)data
           fromPeer:(NSString *)peer
          inSession:(PeerSession *)session
            context:(void *)context;
@end

@interface PeerSession : NSObject

- (id)initWithMCSession:(MCSession *)session;

@property (nonatomic, assign) id<PeerSessionDelegate> delegate;
@property (nonatomic, readonly) MCSession *mcSession;

- (void)setDataReceiveHandler:(id<PeerSessionDataReceiveHandler>)handler withContext:(void *)context;
- (BOOL)sendDataToAllPeers:(NSData *)data withDataMode:(PeerSendDataMode)mode error:(NSError **)error;
- (void)disconnectFromAllPeers;

@end
