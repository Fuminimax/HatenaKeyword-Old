//
//  HatenaKeywordAppDelegate.h
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/02.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TopViewController.h"
#import "KeywordViewController.h"
#import "Bookmark.h"
#import <UIKit/UIKit.h>
//#import <sqlite3.h>

@interface HatenaKeywordAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	TopViewController *viewController;
	UINavigationController *navController;
	NSMutableArray *bookmarks;
	
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	//sqlite3	*database;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TopViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) NSMutableArray *bookmarks;

@end

