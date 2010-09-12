//
//  FormicViewController.m
//  Formic
//
//  Created by patrick on 2010/9/12.
//  Copyright Patrick Tsai 2010. All rights reserved.
//

#import "FormicViewController.h"
#import "FormicTimerView.h"
#import "FormicView.h"
#import "FormicAppDelegate.h"

@implementation FormicViewController

- (void)viewDidLoad {
    CGRect rect;
    UILabel* tempView;

    [(FormicView*)[self view] viewDidLoad];

    // create and add the timer view
    mTimerView = [[FormicTimerView alloc] init];
    mTimerView.center = CGPointMake(160, 460);
    [[self view] addSubview:mTimerView];

    // add the lives and points views
    rect = CGRectMake(0.0, 30.0, 75.0, 24.0);
    mLivesView = [[UILabel alloc] initWithFrame:rect];
    mLivesView.text = @"0";
    mLivesView.font = [UIFont boldSystemFontOfSize:26];
    mLivesView.textAlignment = UITextAlignmentCenter;
    mLivesView.textColor = [UIColor whiteColor];
    mLivesView.backgroundColor = [UIColor clearColor];
    [[self view] addSubview:mLivesView];
    rect = CGRectMake(0.0, 30.0, 75.0, 24.0);
    mLivesZoomView = [[UILabel alloc] initWithFrame:rect];
    mLivesZoomView.text = @"0";
    mLivesZoomView.font = [UIFont boldSystemFontOfSize:26];
    mLivesZoomView.textAlignment = UITextAlignmentCenter;
    mLivesZoomView.textColor = [UIColor whiteColor];
    mLivesZoomView.backgroundColor = [UIColor clearColor];
    mLivesZoomView.transform = CGAffineTransformIdentity;
    mLivesZoomView.alpha = 0.0;
    [[self view] addSubview:mLivesZoomView];
    rect = CGRectMake(245.0, 30.0, 75.0, 24.0);
    mPointsView = [[UILabel alloc] initWithFrame:rect];
    mPointsView.text = @"0";
    mPointsView.font = [UIFont boldSystemFontOfSize:26];
    mPointsView.textAlignment = UITextAlignmentCenter;
    mPointsView.textColor = [UIColor whiteColor];
    mPointsView.backgroundColor = [UIColor clearColor];
    [[self view] addSubview:mPointsView];
    rect = CGRectMake(245.0, 30.0, 75.0, 24.0);
    mPointsZoomView = [[UILabel alloc] initWithFrame:rect];
    mPointsZoomView.text = @"0";
    mPointsZoomView.font = [UIFont boldSystemFontOfSize:26];
    mPointsZoomView.textAlignment = UITextAlignmentCenter;
    mPointsZoomView.textColor = [UIColor whiteColor];
    mPointsZoomView.backgroundColor = [UIColor clearColor];
    mPointsZoomView.transform = CGAffineTransformIdentity;
    mPointsZoomView.alpha = 0.0;
    [[self view] addSubview:mPointsZoomView];

    // add text labels
    rect = CGRectMake(0.0, 60.0, 75.0, 24.0);
    tempView = [[UILabel alloc] initWithFrame:rect];
    tempView.text = @"LIVES";
    tempView.font = [UIFont boldSystemFontOfSize:15];
    tempView.textAlignment = UITextAlignmentCenter;
    tempView.textColor = [UIColor grayColor];
    tempView.backgroundColor = [UIColor clearColor];
    [[self view] addSubview:tempView];
    rect = CGRectMake(245.0, 60.0, 75.0, 24.0);
    tempView = [[UILabel alloc] initWithFrame:rect];
    tempView.text = @"SCORE";
    tempView.font = [UIFont boldSystemFontOfSize:15];
    tempView.textAlignment = UITextAlignmentCenter;
    tempView.textColor = [UIColor grayColor];
    tempView.backgroundColor = [UIColor clearColor];
    [[self view] addSubview:tempView];

    // add the tap to start view
    mStartView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tap-to-start.png"]];
    mStartView.center = [[self view] center];
    [[self view] addSubview:mStartView];

    // Not really a solution at all!! Here because view might get released in didReceiveMemoryWarning
    // (handling this is beyond the scope of this simple demo application)
    [[self view] retain];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -

- (void)zoomInCenterwithColor:(int)color andShape:(int)shape {
    NSString* filename;

    // remove any leftovers
    [mCenterView release];
    mCenterView = nil;

    // generate and place the new piece
    filename = [NSString stringWithFormat:@"piece-%d-%d-1.png", color, shape];
    mCenterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];
    mCenterView.center = [[self view] center];
    [[self view] addSubview:mCenterView];

    // animate it in
    mCenterView.alpha = 0.0;
    mCenterView.transform = CGAffineTransformMakeScale(0.33, 0.33);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIM_NORMAL];
    mCenterView.alpha = 1.0;
    mCenterView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void)zoomOutCenter {
    // animate it out
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIM_NORMAL];
    mCenterView.alpha = 0.0;
    mCenterView.transform = CGAffineTransformMakeScale(3.0, 3.0);
    [UIView commitAnimations];
}

- (void)moveCenterToCircle:(int)circle {
    // animate it there
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIM_NORMAL];
    mCenterView.alpha = 1.0;
    mCenterView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    mCenterView.center = [(FormicView*)[self view] centerForCircle:circle];
    [UIView commitAnimations];

    // transfer and schedule finishing up
    mMovedView = mCenterView;
    mCenterView = nil;
    [self performSelector:@selector(clearCircle:)withObject:[NSNumber numberWithInt:circle] afterDelay:ANIM_NORMAL];
}

- (void)clearCircle:(NSNumber*)number {
    int circle = [number intValue];

    // animate inner and outer piece out
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIM_NORMAL];
    mMovedView.alpha = 0.0;
    mMovedView.transform = CGAffineTransformMakeScale(0.33, 0.33);
    mCircleView[circle].alpha = 0.0;
    mCircleView[circle].transform = CGAffineTransformMakeScale(3.0, 3.0);
    [UIView commitAnimations];

    // and remove them
    [mMovedView release];
    mMovedView = nil;
    [mCircleView[circle] release];
    mCircleView[circle] = nil;

    // then move new piece in
    [[AppDelegate game] newPieceForCircle:[NSNumber numberWithInt:circle]];
}

- (void)zoomInCircle:(int)circle withColor:(int)color andShape:(int)shape {
    NSString* filename;

    // remove any leftovers
    [mCircleView[circle] release];
    mCircleView[circle] = nil;

    // generate and place the new piece
    filename = [NSString stringWithFormat:@"piece-%d-%d-0.png", color, shape];
    mCircleView[circle] = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];
    mCircleView[circle].center = [(FormicView*)[self view] centerForCircle:circle];
    mCircleView[circle].alpha = 0.0;
    mCircleView[circle].transform = CGAffineTransformMakeScale(3.0, 3.0);
    [[self view] addSubview:mCircleView[circle]];

    // animate in
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIM_NORMAL];
    mMovedView.alpha = 0.0;
    mMovedView.transform = CGAffineTransformMakeScale(0.33, 0.33);
    mCircleView[circle].alpha = 1.0;
    mCircleView[circle].transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void)updateTimer:(int)timervalue {
    [mTimerView setPosition:timervalue];
}

- (void)updateLives:(int)lives {
    // updates the lifes displayed
    mLivesView.text = [NSString stringWithFormat:@"%d", lives];
    mLivesZoomView.text = [NSString stringWithFormat:@"%d", lives];

    // zoom out the new lifes
    mLivesZoomView.transform = CGAffineTransformIdentity;
    mLivesZoomView.alpha = 1.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIM_SHORT];
    mLivesZoomView.transform = CGAffineTransformMakeScale(4.5, 4.5);
    mLivesZoomView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)updateScore:(int)points {
    // updates the lifes displayed
    mPointsView.text = [NSString stringWithFormat:@"%d", points];
    mPointsZoomView.text = [NSString stringWithFormat:@"%d", points];

    // zoom out the new lifes
    mPointsZoomView.transform = CGAffineTransformIdentity;
    mPointsZoomView.alpha = 1.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIM_SHORT];
    mPointsZoomView.transform = CGAffineTransformMakeScale(4.5, 4.5);
    mPointsZoomView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)startGame {
    // animate it out
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIM_SHORT];
    mStartView.alpha = 0.0;
    mStartView.transform = CGAffineTransformMakeScale(6.0, 6.0);
    [UIView commitAnimations];
}

- (void)gameOver {
    UIImageView* imageView;

    // create game over view
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game-over.png"]];
    imageView.center = [self view].center;
    imageView.alpha = 0.0;
    imageView.transform = CGAffineTransformMakeScale(6.0, 6.0);
    [[self view] addSubview:imageView];

    // animate it in
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIM_LONG];
    imageView.alpha = 1.0;
    imageView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

@end