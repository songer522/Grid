//
//  AppDelegate.m
//  Grid
//
//  Created by Yang Song on 4/12/12.
//  Copyright XecuDev 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameLayer.h"
#import "MainMenu.h"
#import "ChooseLevelMenu.h"
#import "GameSettings.h"
#import "ChooseIslandMenu.h"
#import "Appirater.h"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	// Display FSP and SPF
	[director_ setDisplayStats:NO];

	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
//	[director setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;

	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];

	// make main window visible
	[window_ makeKeyAndVisible];
    [self authenticateLocalPlayer];
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// When in iPhone RetinaDisplay, iPad, iPad RetinaDisplay mode, CCFileUtils will append the "-hd", "-ipad", "-ipadhd" to all loaded files
	// If the -hd, -ipad, -ipadhd files are not found, it will load the non-suffixed version
	[CCFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[CCFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "" (empty string)
	[CCFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
	//[director_ pushScene: [GameLayer scene]]; 
   // [director_ pushScene: [ChooseLevelMenu scene]]; 
    [director_ pushScene: [MainMenu scene]]; 
    
    [Appirater appLaunched:YES];

	return YES;
}

// Supported orientations: Portrait only.
- (UIInterfaceOrientationMask)supportedInterfaceOrientationsForDirector
{
	return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
	return UIInterfaceOrientationMaskPortrait;
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
     [[GameSettings shared] saveToDisk];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
    [[GameSettings shared] saveToDisk];

}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[GameSettings shared] saveToDisk];

	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
     [[GameSettings shared] saveToDisk];
	[[CCDirector sharedDirector] purgeCachedData];
   

}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
     [[GameSettings shared] saveToDisk];
}

- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        if (localPlayer.isAuthenticated)
        {
            // Perform additional tasks for the authenticated player.
        }
    }];
    
    [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) {
        // Insert application-specific code here to clean up any games in progress.
        if (acceptedInvite)
        {
            GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithInvite:acceptedInvite] autorelease];
            mmvc.matchmakerDelegate = self;
            [navController_ presentViewController:mmvc animated:YES completion:nil];
        }
        else if (playersToInvite)
        {
            GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
            request.minPlayers = 2;
            request.maxPlayers = 2;
            request.playersToInvite = playersToInvite;
            
            GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
            mmvc.matchmakerDelegate = self;
            [navController_ presentViewController:mmvc animated:YES completion:nil];
        }
    };
}
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [navController_ dismissViewControllerAnimated:YES completion:nil];
    // implement any specific code in your application here.
}
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    [navController_ dismissViewControllerAnimated:YES completion:nil];
    // Display the error to the user.
   // NSLog(@"error");
}
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    [navController_ dismissViewControllerAnimated:YES completion:nil];
   // NSLog(@"find a match");
   // myMatch = match; // Use a retaining property to retain the match.
    //myMatch.delegate = self;
    [[GameSettings shared] saveObj:match ForKey:@"GKMatch"];
      [[GameSettings shared] setGlobal:@"network" ForKey:@"gameMode"];
     [[GameSettings shared] setGlobal:@"NO" ForKey:@"isHost"];
    [[GameSettings shared] setGlobal:@"NO" ForKey:@"ShowNotHostWindow"];
    CCDirectorIOS	*director1= (CCDirectorIOS*) [CCDirector sharedDirector];
    
    [director1 pushScene: [CCTransitionFade transitionWithDuration:1.0f scene:[ChooseIslandMenu scene]]];
    
    //if (!self.matchStarted && match.expectedPlayerCount == 0)
    //{
    //  self.matchStarted = YES;
    // Insert application-specific code to begin the match.
    //}
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];

	[super dealloc];
}
@end
