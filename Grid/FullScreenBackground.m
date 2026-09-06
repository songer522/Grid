//
//  FullScreenBackground.m
//  Grid
//

#import "FullScreenBackground.h"
#import "DeviceSettings.h"

static const CGFloat kSliverInset = 1.0f;
static const CGFloat kSliverSpan = 2.0f;

@implementation FullScreenBackground

+ (id)backgroundWithSpriteFrameName:(NSString *)frameName
{
	return [[[self alloc] initWithSpriteFrameName:frameName] autorelease];
}

+ (void)stretchSpriteToFillScene:(CCSprite *)sprite
{
	if( !sprite )
		return;

	CGSize scene = GridSceneSize();
	CGSize size = [sprite contentSize];
	if( size.width > 0.0f )
		[sprite setScaleX:scene.width / size.width];
	if( size.height > 0.0f )
		[sprite setScaleY:scene.height / size.height];
	[sprite setPosition:ccp(scene.width * 0.5f, scene.height * 0.5f)];
}

- (id)initWithSpriteFrameName:(NSString *)frameName
{
	if( (self = [super init]) )
	{
		_main = [CCSprite spriteWithSpriteFrameName:frameName];
		if( !_main )
		{
			[self release];
			return nil;
		}

		ccTexParams params = { GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE };
		[[_main texture] setTexParameters:&params];

		CGRect rect = [_main textureRect];
		CCTexture2D *texture = [_main texture];

		if( rect.size.height > (kSliverInset + kSliverSpan) )
		{
			CGRect topRect = CGRectMake(rect.origin.x, rect.origin.y + kSliverInset, rect.size.width, kSliverSpan);
			_topSliver = [CCSprite spriteWithTexture:texture rect:topRect];

			CGRect bottomRect = CGRectMake(rect.origin.x,
										   rect.origin.y + rect.size.height - kSliverInset - kSliverSpan,
										   rect.size.width,
										   kSliverSpan);
			_bottomSliver = [CCSprite spriteWithTexture:texture rect:bottomRect];
		}

		if( rect.size.width > (kSliverInset + kSliverSpan) )
		{
			CGRect leftRect = CGRectMake(rect.origin.x + kSliverInset, rect.origin.y, kSliverSpan, rect.size.height);
			_leftSliver = [CCSprite spriteWithTexture:texture rect:leftRect];

			CGRect rightRect = CGRectMake(rect.origin.x + rect.size.width - kSliverInset - kSliverSpan,
										  rect.origin.y,
										  kSliverSpan,
										  rect.size.height);
			_rightSliver = [CCSprite spriteWithTexture:texture rect:rightRect];
		}

		if( _topSliver ) [self addChild:_topSliver];
		if( _bottomSliver ) [self addChild:_bottomSliver];
		if( _leftSliver ) [self addChild:_leftSliver];
		if( _rightSliver ) [self addChild:_rightSliver];
		[self addChild:_main];

		[self layoutSlivers];
	}
	return self;
}

- (void)onEnter
{
	[super onEnter];
	[self layoutSlivers];
}

- (void)visit
{
	CGSize scene = GridSceneSize();
	if( !CGSizeEqualToSize(scene, _laidOutSize) )
		[self layoutSlivers];
	[super visit];
}

- (void)layoutSlivers
{
	CGSize scene = GridSceneSize();
	_laidOutSize = scene;
	CGPoint mainPos = ADJUST_CCP(ccp(kScreenWidth / 2.0f, kScreenHeight / 2.0f));
	[_main setPosition:mainPos];

	CGSize mainSize = [_main contentSize];
	CGFloat mainTop = mainPos.y + mainSize.height * 0.5f;
	CGFloat mainBottom = mainPos.y - mainSize.height * 0.5f;
	CGFloat mainLeft = mainPos.x - mainSize.width * 0.5f;
	CGFloat mainRight = mainPos.x + mainSize.width * 0.5f;

	if( _topSliver )
	{
		CGFloat span = scene.height - mainTop;
		if( span > 0.0f && [_topSliver contentSize].height > 0.0f )
		{
			[_topSliver setVisible:YES];
			[_topSliver setAnchorPoint:ccp(0.5f, 0.0f)];
			[_topSliver setPosition:ccp(scene.width * 0.5f, mainTop)];
			[_topSliver setScaleX:scene.width / [_topSliver contentSize].width];
			[_topSliver setScaleY:span / [_topSliver contentSize].height];
		}
		else
		{
			[_topSliver setVisible:NO];
		}
	}

	if( _bottomSliver )
	{
		CGFloat span = mainBottom;
		if( span > 0.0f && [_bottomSliver contentSize].height > 0.0f )
		{
			[_bottomSliver setVisible:YES];
			[_bottomSliver setAnchorPoint:ccp(0.5f, 1.0f)];
			[_bottomSliver setPosition:ccp(scene.width * 0.5f, mainBottom)];
			[_bottomSliver setScaleX:scene.width / [_bottomSliver contentSize].width];
			[_bottomSliver setScaleY:span / [_bottomSliver contentSize].height];
		}
		else
		{
			[_bottomSliver setVisible:NO];
		}
	}

	if( _leftSliver )
	{
		CGFloat span = mainLeft;
		if( span > 0.0f && [_leftSliver contentSize].width > 0.0f )
		{
			[_leftSliver setVisible:YES];
			[_leftSliver setAnchorPoint:ccp(1.0f, 0.5f)];
			[_leftSliver setPosition:ccp(mainLeft, mainPos.y)];
			[_leftSliver setScaleX:span / [_leftSliver contentSize].width];
			[_leftSliver setScaleY:mainSize.height / [_leftSliver contentSize].height];
		}
		else
		{
			[_leftSliver setVisible:NO];
		}
	}

	if( _rightSliver )
	{
		CGFloat span = scene.width - mainRight;
		if( span > 0.0f && [_rightSliver contentSize].width > 0.0f )
		{
			[_rightSliver setVisible:YES];
			[_rightSliver setAnchorPoint:ccp(0.0f, 0.5f)];
			[_rightSliver setPosition:ccp(mainRight, mainPos.y)];
			[_rightSliver setScaleX:span / [_rightSliver contentSize].width];
			[_rightSliver setScaleY:mainSize.height / [_rightSliver contentSize].height];
		}
		else
		{
			[_rightSliver setVisible:NO];
		}
	}
}

@end
