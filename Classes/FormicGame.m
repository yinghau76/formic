//
//  FormicGame.m
//  Formic
//
//  Created by patrick on 2010/9/12.
//  Copyright 2010 Patrick Tsai. All rights reserved.
//

#import "FormicGame.h"
#import "FormicViewController.h"

@interface FormicGame (Private)

- (void)startTimer;
- (float)timerInterval;
- (void)timerAdvanced:(NSTimer*)timer;
- (void)newCenterPiece;
- (void)zoomInCircle:(NSNumber*)number;

@end

@implementation FormicGame (Private)

- (void)startTimer {
    [NSTimer scheduledTimerWithTimeInterval:[self timerInterval]
                                     target:self
                                   selector:@selector(timerAdvanced:)
                                   userInfo:nil
                                    repeats:YES];
}

- (float)timerInterval {
    // gets faster the more pieces have been moved
    return ( 20.0 / ( (float)mPoints + 150.0 ) );
}

- (void)timerAdvanced:(NSTimer*)timer {
    // don't advance when blocked
    if (mBlocked)
        return;

    // new piece, new timing
    if (mTime == 0) {
        [timer invalidate];
        [self startTimer];
    }

    // advance timer
    [mController updateTimer:mTime];
    mTime++;
    if (mTime >= GAME_TIMERSTEPS) {
        // lost a life
        mLives--;
        [mController updateLives:mLives];
        if (mLives <= 0) {
            // game over
            mState = GAME_OVER;
            [timer invalidate];
            [mController gameOver];
        }
        else {
            // next piece
            [self newCenterPiece];
            mTime = 0;
        }
    }
}

- (void)newCenterPiece {
    // fade existing one out
    [mController zoomOutCenter];

    // find a new one
    mCenter[GAME_COLOR] = rand() % GAME_MAXCOLORS;
    mCenter[GAME_SHAPE] = mCircle[rand() % GAME_CIRCLES][GAME_SHAPE];

    // display it
    [mController zoomInCenterwithColor:mCenter[GAME_COLOR] andShape:mCenter[GAME_SHAPE]];

    // reset the timer
    mTime = 0;
    [mController updateTimer:mTime];
}

- (void)zoomInCircle:(NSNumber*)number {
    int circle = [number intValue];

    [mController zoomInCircle:circle withColor:mCircle[circle][GAME_COLOR] andShape:mCircle[circle][GAME_SHAPE]];
}

@end

@implementation FormicGame

- (id)initWithViewController:(FormicViewController*)controller {
    // initialize super
    self = [super init];
    if (!self)
        return nil;

    // general initializations
    mController = [controller retain];
    mLives = 5;
    mTime = 0;
    mPoints = 0;
    mState = GAME_INIT;
    mBlocked = NO;
    mCenter[GAME_COLOR] = mCenter[GAME_SHAPE] = 0;
    for (int i = 0; i < GAME_CIRCLES; i++)
        mCircle[i][GAME_COLOR] = mCircle[i][GAME_SHAPE] = 0;

    return self;
}

- (void) dealloc {
    // clean up
    [mController release];
    [super dealloc];
}

- (void)startGame {
    // don't start over
    if (mState == GAME_RUNNING)
        return;
    mState = GAME_RUNNING;

    // tell the controller about it
    [mController startGame];

    // fill the outer circles
    for (int i = 0; i < GAME_CIRCLES; i++)
        [self performSelector:@selector(newPieceForCircle:) withObject:[NSNumber numberWithInteger:i] afterDelay:( (float)i * 0.2 )];

    // fill the inner circle
    [self performSelector:@selector(newCenterPiece) withObject:nil afterDelay:1.4];

    // let the game begin
    [self performSelector:@selector(startTimer) withObject:nil afterDelay:1.6];
    [mController updateLives:mLives];
}

- (BOOL)moveCenterToCircle:(int)circle {
    // no placement when blocked or game over
    if ( mBlocked || (mState == GAME_OVER) )
        return NO;

    if (mCenter[GAME_SHAPE] == mCircle[circle][GAME_SHAPE]) {
        // see if they have the same color
        if (mCenter[GAME_COLOR] == mCircle[circle][GAME_COLOR]) {
            mPoints++;
            [mController updateScore:mPoints];
        }

        // start moving and create new center
        [mController moveCenterToCircle:circle];
        mCenter[GAME_COLOR] = mCenter[GAME_SHAPE] = 0;
        [self newCenterPiece];

        mBlocked = YES;

        // yes we can!
        return YES;
    }
    else
        // cannot be placed
        return NO;
}

- (void)newPieceForCircle:(NSNumber*)circle {
    int num = [circle intValue];
    BOOL centerFound = NO;
    // find new piece, and assure center piece can be set
    for (int i = 0; i < GAME_CIRCLES; i++)
        if ( (mCenter[GAME_SHAPE] == mCircle[i][GAME_SHAPE]) && (i != num) )
            centerFound = YES;
    mCircle[num][GAME_COLOR] = rand() % GAME_MAXCOLORS;
    if (centerFound)
        mCircle[num][GAME_SHAPE] = rand() % GAME_MAXSHAPES;
    else
        mCircle[num][GAME_SHAPE] = mCenter[GAME_SHAPE];

    // display it
    [mController zoomInCircle:num withColor:mCircle[num][GAME_COLOR] andShape:mCircle[num][GAME_SHAPE]];
    mBlocked = NO;
}

- (void)saveGame {
    NSUserDefaults* prefs = nil;

    prefs = [NSUserDefaults standardUserDefaults];
    if (mState == GAME_RUNNING) {
        // save the data representing the game to the preferences
        [prefs setObject:[NSNumber numberWithBool:YES] forKey:@"saved"];
        [prefs setObject:[NSData dataWithBytes:mCircle length:sizeof(mCircle)] forKey:@"circle"];
        [prefs setObject:[NSNumber numberWithInt:mLives] forKey:@"lives"];
        [prefs setObject:[NSNumber numberWithInt:mPoints] forKey:@"points"];
    }
    else
        // save the 'no game data' indication to the preferences
        [prefs setObject:[NSNumber numberWithBool:NO] forKey:@"saved"];
}

- (void)restoreGame {
    NSUserDefaults* prefs = nil;

    prefs = [NSUserDefaults standardUserDefaults];

    // get the data from the preferences
    [[prefs dataForKey:@"center"] getBytes:mCenter length:sizeof(mCenter)];
    [[prefs dataForKey:@"circle"] getBytes:mCircle length:sizeof(mCircle)];
    mTime = 0;
    mLives = [prefs integerForKey:@"lives"];
    mPoints = [prefs integerForKey:@"points"];
    mState = GAME_RUNNING;

    // fill the outer circles
    for (int i = 0; i < GAME_CIRCLES; i++)
        [self performSelector:@selector(zoomInCircle:)
                   withObject:[NSNumber numberWithInteger:i]
                   afterDelay:( (float)i * 0.2 )];

    // new inner circle
    [self performSelector:@selector(newCenterPiece) 
               withObject:nil 
               afterDelay:1.4];

    // let the game begin
    [self performSelector:@selector(startTimer) 
               withObject:nil 
               afterDelay:1.6];
    [mController updateLives:mLives];
    [mController updateScore:mPoints];
}

@end