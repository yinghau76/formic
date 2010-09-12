//
//  FormicAppDelegate.h
//  Formic
//
//  Created by patrick on 2010/9/12.
//  Copyright Patrick Tsai 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormicViewController;
@class FormicGame;

#define AppDelegate	(FormicAppDelegate *)[[UIApplication sharedApplication] delegate]

@interface FormicAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow *window;
    FormicViewController *viewController;
	FormicGame				*game;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FormicViewController *viewController;
@property (readonly) FormicGame *game;

@end

