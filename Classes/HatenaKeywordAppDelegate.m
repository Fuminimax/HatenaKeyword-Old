//
//  HatenaKeywordAppDelegate.m
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/02.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "HatenaKeywordAppDelegate.h"

@implementation HatenaKeywordAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize navController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	window = [[UIWindow alloc] initWithFrame:screenBounds];
	
	viewController = [[TopViewController alloc] init];
	navController = [[UINavigationController alloc] initWithRootViewController:viewController];
	
	[window addSubview:navController.view];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[navController release];
	[viewController release];
    [window release];
    [super dealloc];
}


@end
