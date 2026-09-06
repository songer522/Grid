//
//  PeerPickerController.h
//  Grid
//
//  Replacement for GKPeerPickerController, which no longer exists. Presents
//  MultipeerConnectivity's browser while also advertising this device, so two
//  players who both open nearby play can find each other — the symmetric
//  behaviour GKPeerPickerController used to provide.
//

#import <Foundation/Foundation.h>

@class PeerPickerController;
@class PeerSession;

@protocol PeerPickerControllerDelegate <NSObject>
@optional
- (void)peerPickerController:(PeerPickerController *)picker
              didConnectPeer:(NSString *)peerID
                   toSession:(PeerSession *)session;
- (void)peerPickerControllerDidCancel:(PeerPickerController *)picker;
@end

@interface PeerPickerController : NSObject

@property (nonatomic, assign) id<PeerPickerControllerDelegate> delegate;

- (void)show;
- (void)dismiss;

@end
