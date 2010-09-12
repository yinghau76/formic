//
//  FormicAppDelegate.h
//  Formic
//
//  Created by patrick on 2010/9/12.
//  Copyright Patrick Tsai 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormicViewController;

@interface FormicAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FormicViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FormicViewController *viewController;

@end

