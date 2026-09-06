//
//  ReviewPrompt.h
//  Grid
//
//  Replaces Appirater. StoreKit now owns the rating prompt's presentation
//  and throttling, so all that is left is deciding when to ask.
//

#import <Foundation/Foundation.h>

@interface ReviewPrompt : NSObject

/** Call once per launch. Asks for a review after a few launches. */
+ (void)appLaunched;

@end
