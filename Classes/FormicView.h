//
//  FormicView.h
//  Formic
//
//  Created by patrick on 2010/9/12.
//  Copyright 2010 Patrick Tsai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormicGame.h"

#define RADIUS		117.0
#define PI			3.141592653589793

@interface FormicView : UIView
{
	CGRect			mPieRect[GAME_CIRCLES];
	CGRect			mCenterRect;
	CGGradientRef	mGradient;
}

- (void)viewDidLoad;
    
- (CGPoint)centerForCircle:(int)circle;

@end
