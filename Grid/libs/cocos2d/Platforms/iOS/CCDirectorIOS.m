/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2010 Ricardo Quesada
 * Copyright (c) 2011 Zynga Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

// Only compile this code on iOS. These files should NOT be included on your Mac project.
// But in case they are included, it won't be compiled.
#import "../../ccMacros.h"
#ifdef __CC_PLATFORM_IOS

#import <unistd.h>

// cocos2d imports
#import "CCDirectorIOS.h"
#import "CCTouchDelegateProtocol.h"
#import "CCTouchDispatcher.h"
#import "../../CCScheduler.h"
#import "../../CCActionManager.h"
#import "../../CCTextureCache.h"
#import "../../ccMacros.h"
#import "../../CCScene.h"
#import "../../CCGLProgram.h"
#import "../../ccGLStateCache.h"
#import "../../CCLayer.h"

// support imports
#import "../../Support/OpenGL_Internal.h"
#import "../../Support/CGPointExtension.h"
#import "../../Support/TransformUtils.h"

#import "kazmath/kazmath.h"
#import "kazmath/GL/matrix.h"

#if CC_ENABLE_PROFILERS
#import "../../Support/CCProfiling.h"
#endif


#pragma mark -
#pragma mark Director - global variables (optimization)

CGFloat	__ccContentScaleFactor = 1;

#pragma mark -
#pragma mark Director

@interface CCDirector ()
-(void) setNextScene;
-(void) showStats;
-(void) calculateDeltaTime;
-(void) calculateMPF;
@end

@implementation CCDirector (iOSExtensionClassMethods)

+(Class) defaultDirector
{
	return [CCDirectorDisplayLink class];
}

-(void) setInterfaceOrientationDelegate:(id)delegate
{
	// override me
}

-(CCTouchDispatcher*) touchDispatcher
{
	return nil;
}

-(void) setTouchDispatcher:(CCTouchDispatcher*)touchDispatcher
{
	//
}
@end



#pragma mark -
#pragma mark CCDirectorIOS

@interface CCDirectorIOS ()
-(void) updateContentScaleFactor;
-(void) updateViewport;
@end

@implementation CCDirectorIOS

@synthesize viewportInPoints = viewportInPoints_;

- (id) init
{
	if( (self=[super init]) ) {

		__ccContentScaleFactor = 1;
		isContentScaleSupported_ = NO;

		touchDispatcher_ = [[CCTouchDispatcher alloc] init];

		// running thread is main thread on iOS
		runningThread_ = [NSThread currentThread];
		
		// Apparently it comes with a default view, and we don't want it
//		[self setView:nil];
	}

	return self;
}

- (void) dealloc
{
	[touchDispatcher_ release];

	[super dealloc];
}

//
// Draw the Scene
//
- (void) drawScene
{
	/* calculate "global" dt */
	[self calculateDeltaTime];

	CCGLView *openGLview = (CCGLView*)[self view];

	[EAGLContext setCurrentContext: [openGLview context]];

	/* tick before glClear: issue #533 */
	if( ! isPaused_ )
		[scheduler_ update: dt];

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	/* to avoid flickr, nextScene MUST be here: after tick and before draw.
	 XXX: Which bug is this one. It seems that it can't be reproduced with v0.9 */
	if( nextScene_ )
		[self setNextScene];

	kmGLPushMatrix();

	[runningScene_ visit];

	[notificationNode_ visit];

	if( displayStats_ )
		[self showStats];

	kmGLPopMatrix();

	totalFrames_++;

	[openGLview swapBuffers];

	if( displayStats_ )
		[self calculateMPF];
}

-(void) setProjection:(ccDirectorProjection)projection
{
	CGSize size = winSizeInPixels_;
	CGSize sizePoint = winSizeInPoints_;

	// The viewport is the on-screen region, in framebuffer pixels; the
	// projection below stays in the scene's own coordinate space.
	glViewport(viewportInPoints_.origin.x * __ccContentScaleFactor,
			   viewportInPoints_.origin.y * __ccContentScaleFactor,
			   viewportInPoints_.size.width * __ccContentScaleFactor,
			   viewportInPoints_.size.height * __ccContentScaleFactor );

	switch (projection) {
		case kCCDirectorProjection2D:

			kmGLMatrixMode(KM_GL_PROJECTION);
			kmGLLoadIdentity();

			kmMat4 orthoMatrix;
			kmMat4OrthographicProjection(&orthoMatrix, 0, sizePoint.width, 0, sizePoint.height, -1024, 1024 );
			kmGLMultMatrix( &orthoMatrix );

			kmGLMatrixMode(KM_GL_MODELVIEW);
			kmGLLoadIdentity();
			break;

		case kCCDirectorProjection3D:
		{
			// reset the viewport if 3d proj & retina display
			if( CC_CONTENT_SCALE_FACTOR() != 1 )
				glViewport(-size.width/2, -size.height/2, size.width * CC_CONTENT_SCALE_FACTOR(), size.height * CC_CONTENT_SCALE_FACTOR() );

			float zeye = [self getZEye];

			kmMat4 matrixPerspective, matrixLookup;

			kmGLMatrixMode(KM_GL_PROJECTION);
			kmGLLoadIdentity();

			// issue #1334
			kmMat4PerspectiveProjection( &matrixPerspective, 60, (GLfloat)size.width/size.height, 0.1f, zeye*2);
//			kmMat4PerspectiveProjection( &matrixPerspective, 60, (GLfloat)size.width/size.height, 0.1f, 1500);

			kmGLMultMatrix(&matrixPerspective);

			kmGLMatrixMode(KM_GL_MODELVIEW);
			kmGLLoadIdentity();
			kmVec3 eye, center, up;
			kmVec3Fill( &eye, sizePoint.width/2, sizePoint.height/2, zeye );
			kmVec3Fill( &center, sizePoint.width/2, sizePoint.height/2, 0 );
			kmVec3Fill( &up, 0, 1, 0);
			kmMat4LookAt(&matrixLookup, &eye, &center, &up);
			kmGLMultMatrix(&matrixLookup);
			break;
		}

		case kCCDirectorProjectionCustom:
			if( [delegate_ respondsToSelector:@selector(updateProjection)] )
				[delegate_ updateProjection];
			break;

		default:
			CCLOG(@"cocos2d: Director: unrecognized projection");
			break;
	}

	projection_ = projection;

	ccSetProjectionMatrixDirty();
}

#pragma mark Director - TouchDispatcher

-(CCTouchDispatcher*) touchDispatcher
{
	return touchDispatcher_;
}

-(void) setTouchDispatcher:(CCTouchDispatcher*)touchDispatcher
{
	if( touchDispatcher != touchDispatcher_ ) {
		[touchDispatcher_ release];
		touchDispatcher_ = [touchDispatcher retain];
	}
}

#pragma mark Director - Retina Display

-(CGFloat) contentScaleFactor
{
	return __ccContentScaleFactor;
}

-(void) setContentScaleFactor:(CGFloat)scaleFactor
{
	if( scaleFactor != __ccContentScaleFactor ) {

		__ccContentScaleFactor = scaleFactor;
		[self updateViewport];

		if( view_ )
			[self updateContentScaleFactor];

		// update projection
		[self setProjection:projection_];
	}
}

-(void) updateContentScaleFactor
{
	NSAssert( [view_ respondsToSelector:@selector(setContentScaleFactor:)], @"cocos2d v2.0+ runs on iOS 4 or later");

	[view_ setContentScaleFactor: __ccContentScaleFactor];
	isContentScaleSupported_ = YES;
}

-(BOOL) enableRetinaDisplay:(BOOL)enabled
{
	// Already enabled ?
	if( enabled && __ccContentScaleFactor == 2 )
		return YES;

	// Already disabled
	if( ! enabled && __ccContentScaleFactor == 1 )
		return YES;

	// setContentScaleFactor is not supported
	if (! [view_ respondsToSelector:@selector(setContentScaleFactor:)])
		return NO;

	// SD device
	if ([[UIScreen mainScreen] scale] == 1.0)
		return NO;

	float newScale = enabled ? 2 : 1;
	[self setContentScaleFactor:newScale];

	// Load Hi-Res FPS label
	[self createStatsLabel];

	return YES;
}

// overriden, don't call super
-(void) reshapeProjection:(CGSize)size
{
	[self updateViewport];
	[self setProjection:projection_];
}

-(CGSize) designSize
{
	return designSize_;
}

-(void) setDesignSize:(CGSize)designSize
{
	designSize_ = designSize;
	[self updateViewport];
	[self setProjection:projection_];
}

// Works out the scene's coordinate space and the region of the view it maps
// onto. Without a design size this reproduces the original behaviour of
// treating the view's own size as the coordinate space.
-(void) updateViewport
{
	CGSize viewSize = [view_ bounds].size;

	if( designSize_.width <= 0 || designSize_.height <= 0 ) {
		winSizeInPoints_ = viewSize;
		viewportInPoints_ = CGRectMake(0, 0, viewSize.width, viewSize.height);
	} else {
		winSizeInPoints_ = designSize_;

		CGFloat scale = MIN( viewSize.width / designSize_.width,
							 viewSize.height / designSize_.height );
		CGSize scaled = CGSizeMake( designSize_.width * scale, designSize_.height * scale );
		viewportInPoints_ = CGRectMake( (viewSize.width - scaled.width) / 2,
										(viewSize.height - scaled.height) / 2,
										scaled.width, scaled.height );
	}

	winSizeInPixels_ = CGSizeMake(winSizeInPoints_.width * __ccContentScaleFactor,
								  winSizeInPoints_.height * __ccContentScaleFactor);
}

#pragma mark Director Point Convertion

-(CGPoint)convertToGL:(CGPoint)uiPoint
{
	// Undo the letterboxing so touches land in the scene's coordinate space.
	CGFloat scale = viewportInPoints_.size.width / winSizeInPoints_.width;
	CGPoint p = ccp( (uiPoint.x - viewportInPoints_.origin.x) / scale,
					 (uiPoint.y - viewportInPoints_.origin.y) / scale );

	return ccp( p.x, winSizeInPoints_.height - p.y );
}

-(CGPoint)convertToUI:(CGPoint)glPoint
{
	CGFloat scale = viewportInPoints_.size.width / winSizeInPoints_.width;
	CGPoint p = ccp( glPoint.x, winSizeInPoints_.height - glPoint.y );

	return ccp( p.x * scale + viewportInPoints_.origin.x,
				p.y * scale + viewportInPoints_.origin.y);
}

-(void) end
{
	// don't release the event handlers
	// They are needed in case the director is run again
	[touchDispatcher_ removeAllDelegates];

	[super end];
}

#pragma mark Director - UIViewController delegate


-(void) setView:(CCGLView *)view
{
	if( view != view_) {
		[super setView:view];

		// set size
		winSizeInPixels_ = CGSizeMake(winSizeInPoints_.width * __ccContentScaleFactor, winSizeInPoints_.height *__ccContentScaleFactor);

		if( __ccContentScaleFactor != 1 )
			[self updateContentScaleFactor];

		[view setTouchDelegate: touchDispatcher_];
		[touchDispatcher_ setDispatchEvents: YES];
	}
}

// Override to allow orientations other than the default portrait orientation.
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	if( [delegate_ respondsToSelector:@selector(supportedInterfaceOrientationsForDirector)] )
		return [delegate_ supportedInterfaceOrientationsForDirector];

	return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
	return YES;
}


-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self startAnimation];
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
//	[self startAnimation];
}

-(void) viewWillDisappear:(BOOL)animated
{
//	[self stopAnimation];

	[super viewWillDisappear:animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
	[self stopAnimation];

	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
	// Release any cached data, images, etc that aren't in use.
	[super purgeCachedData];

    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

-(void) viewDidLoad
{
	CCLOG(@"cocos2d: viewDidLoad");

	[super viewDidLoad];
}


- (void)viewDidUnload
{
	CCLOG(@"cocos2d: viewDidUnload");

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
@end


#pragma mark -
#pragma mark DirectorDisplayLink

@implementation CCDirectorDisplayLink


-(void) mainLoop:(id)sender
{
	[self drawScene];
}

- (void)setAnimationInterval:(NSTimeInterval)interval
{
	animationInterval_ = interval;
	if(displayLink_){
		[self stopAnimation];
		[self startAnimation];
	}
}

- (void) startAnimation
{
	NSAssert( displayLink_ == nil, @"displayLink must be nil. Calling startAnimation twice?");

	gettimeofday( &lastUpdate_, NULL);

	// approximate frame rate
	// assumes device refreshes at 60 fps
	int frameInterval = (int) floor(animationInterval_ * 60.0f);

	CCLOG(@"cocos2d: animation started with frame interval: %.2f", 60.0f/frameInterval);

	displayLink_ = [CADisplayLink displayLinkWithTarget:self selector:@selector(mainLoop:)];
	[displayLink_ setFrameInterval:frameInterval];

#if CC_DIRECTOR_IOS_USE_BACKGROUND_THREAD
	//
	runningThread_ = [[NSThread alloc] initWithTarget:self selector:@selector(threadMainLoop) object:nil];
	[runningThread_ start];

#else
	// setup DisplayLink in main thread
	[displayLink_ addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
#endif


}

- (void) stopAnimation
{
	CCLOG(@"cocos2d: animation stopped");

#if CC_DIRECTOR_IOS_USE_BACKGROUND_THREAD
	[runningThread_ cancel];
	[runningThread_ release];
	runningThread_ = nil;
#endif

	[displayLink_ invalidate];
	displayLink_ = nil;
}

// Overriden in order to use a more stable delta time
-(void) calculateDeltaTime
{
    // New delta time
    if( nextDeltaTimeZero_ ) {
        dt = 0;
        nextDeltaTimeZero_ = NO;
    } else {
        dt = displayLink_.timestamp - lastDisplayTime_;
        dt = MAX(0,dt);
    }
    // Store this timestamp for next time
    lastDisplayTime_ = displayLink_.timestamp;

	// needed for SPF
	if( displayStats_ )
		gettimeofday( &lastUpdate_, NULL);

#ifdef DEBUG
	// If we are debugging our code, prevent big delta time
	if( dt > 0.2f )
		dt = 1/60.0f;
#endif
}


#pragma mark Director Thread

//
// Director has its own thread
//
-(void) threadMainLoop
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	[displayLink_ addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

	// start the run loop
	[[NSRunLoop currentRunLoop] run];

	[pool release];
}

-(void) dealloc
{
	[displayLink_ release];
	[super dealloc];
}
@end

#endif // __CC_PLATFORM_IOS
