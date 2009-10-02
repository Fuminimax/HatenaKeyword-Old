//
//  HatenaKeywordAppDelegate.h
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/02.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TopViewController.h"
#import <UIKit/UIKit.h>

@interface HatenaKeywordAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	TopViewController *viewController;
	UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TopViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@end

