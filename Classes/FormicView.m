//
//  FormicView.m
//  Formic
//
//  Created by patrick on 2010/9/12.
//  Copyright 2010 Patrick Tsai. All rights reserved.
//

#import "FormicView.h"
#import "FormicAppDelegate.h"

CGRect CGRectMakeWithCenter(CGPoint center, CGFloat diameter) {
    return CGRectMake(center.x - diameter / 2, center.y - diameter / 2, diameter, diameter);
}

CGPoint CGPointMakeFromRect(CGRect rect) {
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

@implementation FormicView

- (void)dealloc {
    // clean up
    CGGradientRelease(mGradient);
    [super dealloc];
}

- (void)viewDidLoad {
    CGPoint center, point;
    CGFloat degree = 0;

    // init the rectangles
    center = self.center;
    mCenterRect = CGRectMakeWithCenter(center, RADIUS - 4);
    for (int i = 0; i < GAME_CIRCLES; i++) {
        point.x = center.x - sin(degree) * RADIUS;
        point.y = center.y + cos(degree) * RADIUS;
        mPieRect[i] = CGRectMakeWithCenter(point, RADIUS - 4);
        degree += PI / 3.0;
    }

    // init the gradient
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] = {
        32.0 / 255.0, 32.0 / 265.0, 32.0 / 255.0, 1.0,
        64.0 / 255.0, 64.0 / 255.0, 64.0 / 255.0, 1.0
    };
    mGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
    CGColorSpaceRelease(rgb);
}

- (CGPoint)centerForCircle:(int)circle {
    return CGPointMakeFromRect(mPieRect[circle]);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context;
    CGPoint start, end;

    // drawing the background gradient
    context = UIGraphicsGetCurrentContext();
    start = [self frame].origin;
    end = start;
    end.y += [self frame].size.height;
    CGContextDrawLinearGradient(context, mGradient, start, end, 0);

    // drawing the middle circle
    CGContextFillEllipseInRect(context, mCenterRect);

    // drawing the outer circles
    for (int i = 0; i < GAME_CIRCLES; i++)
        CGContextFillEllipseInRect(context, mPieRect[i]);
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint touched;

    // find position of the touch
    touched = [[touches anyObject] locationInView:self];

    // find touch in center rectangle
    if ( CGRectContainsPoint(mCenterRect, touched) )
        [[AppDelegate game] startGame];

    // find touch in outter rectangles
    for (int i = 0; i < GAME_CIRCLES; i++)
        if ( CGRectContainsPoint(mPieRect[i], touched) )
            [[AppDelegate game] moveCenterToCircle:i];
}

@end