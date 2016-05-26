//
//  SimpleGameAppDelegate.h
//  SimpleGame
//
//  Created by Daniel Baird on 3/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SimpleGameViewController;

@interface SimpleGameAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SimpleGameViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SimpleGameViewController *viewController;

@end

