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
@synthesize bookmarks;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	// データベースを作成する
	//[self createEditableCopyOfDatabaseIfNeeded];
	
	//[self initializeDatabase];
	
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	window = [[UIWindow alloc] initWithFrame:screenBounds];
	
	viewController = [[TopViewController alloc] init];
	navController = [[UINavigationController alloc] initWithRootViewController:viewController];
	
	viewController.managedObjectContext = self.managedObjectContext;
	
	[window addSubview:navController.view];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        } 
    }
}

//
// Core Data使用部分
//

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"HatenaKeyword.sqlite"];
	NSLog(@"%@", storePath);
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"HatenaKeyword" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	
	NSLog(@"fileManager End");
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	
	NSError *error;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }    
	NSLog(@"Persistent End");
    return persistentStoreCoordinator;
}

//
// Application's documents directory
//

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

/*
- (void)initializeDatabase {
    NSMutableArray *bookmarkArray = [[NSMutableArray alloc] init];
    self.bookmarks = bookmarkArray;
    [bookmarkArray release];
    // The database is stored in the application bundle. 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingString:@"HatenaKeyword.db"];
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        // Get the primary key for all books.
        const char *sql = "SELECT id FROM hatenakeyword ORDER BY id DESC";
        sqlite3_stmt *statement;
        // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
        // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            // We "step" through the results - once for each row.
            while (sqlite3_step(statement) == SQLITE_ROW) {
                // The second parameter indicates the column index into the result set.
                int primaryKey = sqlite3_column_int(statement, 0);
                // We avoid the alloc-init-autorelease pattern here because we are in a tight loop and
                // autorelease is slightly more expensive than release. This design choice has nothing to do with
                // actual memory management - at the end of this block of code, all the book objects allocated
                // here will be in memory regardless of whether we use autorelease or release, because they are
                // retained by the books array.
                Bookmark *bookmark = [[Bookmark alloc] initWithPrimaryKey:primaryKey database:database];
                [bookmarks addObject:bookmark];
                [bookmark release];
            }
        }else{
			NSLog(@"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
        // "Finalize" the statement - releases the resources associated with the statement.
        sqlite3_finalize(statement);
    } else {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        // Additional error handling, as appropriate...
    }
}

-(void)createEditableCopyOfDatabaseIfNeeded{
	BOOL success;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirestory = [paths objectAtIndex:0];
	
	NSString *writableDBPath = [documentsDirestory stringByAppendingString:@"HatenaKeyword.db"];
	//NSLog(writableDBPath);
	success = [fileManager fileExistsAtPath:writableDBPath];
	
	if (success) return;
	
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"HatenaKeyword.db"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	
	if(!success){
		NSLog(@"Failed to create Database'%@'.", [error localizedDescription]);
		//NSLog(defaultDBPath);
		//NSLog(writableDBPath);
	}else{
		/*
		 if (sqlite3_open([writableDBPath UTF8String], &database) == SQLITE_OK) {
		 NSLog(@"Success Open DataBase");
		 }else{
		 NSLog(@"Failed To Open DataBase");
		 }
		 */
/*		NSLog(@"Success create database");
	}
}
*/

- (void)dealloc {
	[navController release];
	[viewController release];
    [window release];
    [super dealloc];
}


@end
