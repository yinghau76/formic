//
//  FormicGame.h
//  Formic
//
//  Created by patrick on 2010/9/12.
//  Copyright 2010 Patrick Tsai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GAME_CIRCLES    6
#define GAME_TIMERSTEPS 15

#define GAME_COLOR      0
#define GAME_SHAPE      1

#define GAME_MAXCOLORS  3
#define GAME_MAXSHAPES  3

#define GAME_INIT       0
#define GAME_RUNNING    1
#define GAME_OVER       2

@class FormicViewController;

@interface FormicGame : NSObject
{
    FormicViewController* mController;

    int mCenter[2];                     // the color and shape of the center piece
    int mCircle[GAME_CIRCLES][2];       // the colors and shapes of the surrounding circles
    int mTime;                          // the state of the running-out timer
    int mLives;                         // the amount of lives left
    int mPoints;                        // the amount of pieces set
    BOOL mState;                        // the state of the game (running, over, etc.)
    BOOL mBlocked;                      // if blocked for animations to finish
}

- (id)initWithViewController:(FormicViewController*)controller;

- (void)startGame;

- (BOOL)moveCenterToCircle:(int)circle;
- (void)newPieceForCircle:(NSNumber*)circle;

- (void)saveGame;
- (void)restoreGame;

@end