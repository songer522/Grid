//
//  AlertView.h
//  Grid
//
//  Drop-in replacement for UIAlertView, which was removed from the SDK.
//  Backed by UIAlertController, but keeps the original delegate-and-tag
//  API so the existing call sites and dispatch logic stay unchanged.
//
//  Unlike UIAlertController, alerts shown here are queued: presenting one
//  while another is still on screen (or still animating away) is safe and
//  matches how UIAlertView used to behave.
//

#import <UIKit/UIKit.h>

@class AlertView;

@protocol AlertViewDelegate <NSObject>
@optional
- (void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface AlertView : NSObject

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id<AlertViewDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, assign) id<AlertViewDelegate> delegate;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;

- (void)show;

/** Dismisses the alert. A negative index dismisses without notifying the delegate. */
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end
