//
//  FormicAppDelegate.m
//  Formic
//
//  Created by patrick on 2010/9/12.
//  Copyright Patrick Tsai 2010. All rights reserved.
//

#import "FormicAppDelegate.h"
#import "FormicViewController.h"

@implementation FormicAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize game;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{        
	// Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	game = [[FormicGame alloc] initWithViewController:viewController];

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"saved"])
		[[[[UIAlertView alloc] initWithTitle:@"Resume Game" message:@"Do you want to resume the last unfinished game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Resume", nil] autorelease] show];

}

- (void)dealloc
{
	[viewController release];
	[window release];
	[super dealloc];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// stop the timers, animations and sound!
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// restart the timers, animations and sound!
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[game saveGame];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		[game restoreGame];
		[viewController startGame];
    }
}


@end
