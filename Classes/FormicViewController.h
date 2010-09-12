//
//  FormicViewController.h
//  Formic
//
//  Created by patrick on 2010/9/12.
//  Copyright Patrick Tsai 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormicGame.h"

#define ANIM_SHORT              0.3
#define ANIM_NORMAL             0.4
#define ANIM_LONG               1.2

@class FormicTimerView;

@interface FormicViewController : UIViewController
{
    UIImageView* mStartView;
    UIImageView* mCenterView;
    UIImageView* mMovedView;
    UIImageView* mCircleView[GAME_CIRCLES];
    FormicTimerView* mTimerView;
    UILabel* mLivesView;
    UILabel* mLivesZoomView;
    UILabel* mPointsView;
    UILabel* mPointsZoomView;
}

- (void)zoomInCenterwithColor:(int)color andShape:(int)shape;
- (void)zoomOutCenter;

- (void)moveCenterToCircle:(int)circle;
- (void)zoomInCircle:(int)circle withColor:(int)color andShape:(int)shape;

- (void)updateTimer:(int)timervalue;
- (void)updateLives:(int)lives;
- (void)updateScore:(int)points;

- (void)startGame;
- (void)gameOver;

@end