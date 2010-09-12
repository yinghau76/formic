//
//  FormicTimerView.m
//  Formic
//
//  Created by Wolfgang Ante on 02.06.08.
//  Copyright 2008 ARTIS Software. All rights reserved.
//

#import "FormicTimerView.h"

@implementation FormicTimerView

- (id)init
{
	int	i;
	
	// cache the images
	for (i = 0; i < GAME_TIMERSTEPS; i++)
		mProgressImage[i] = [[UIImage imageNamed:[NSString stringWithFormat:@"progress-%d.png", (i + 1)]] retain];
	
	// super initialization
	self = [super initWithImage:mProgressImage[0]];
	if (!self)
		return nil;
	
	// other initialization
	mPosition = 0;
	
	return self;
}

- (void)dealloc
{
	int i;
	
	// release the cached images
	for (i = 0; i < GAME_TIMERSTEPS; i++)
		[mProgressImage[i] release];
	
	// finish it
	[super dealloc];
}

#pragma mark -

- (void)setPosition:(int)position
{
	// update the timer circle
	[self setImage:mProgressImage[position]];
	mPosition = position;
}

@end
