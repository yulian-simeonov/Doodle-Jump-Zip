//
//  SimpleGameAppDelegate.m
//  SimpleGame
//
//  Created by Daniel Baird on 3/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SimpleGameAppDelegate.h"
#import "SimpleGameViewController.h"

@implementation SimpleGameAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	sleep(5);
	
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
