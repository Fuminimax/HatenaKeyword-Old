//
//  TopViewController.h
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "myParser.h"
#import "Bookmark.h"
#import "KeywordViewController.h"

@interface TopViewController : UIViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
	UISearchBar *searchBar;
	UITableView *topTableView;
	UINavigationController *navController;
	KeywordViewController *keyController;
	
	NSMutableArray *HotkeywordData;
	myParser *rssParser;
	
	NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;	    
    NSManagedObjectContext *addingManagedObjectContext;
	
	NSMutableArray *mutableFetchResults;
	
	//sqlite3 *topdatabase;
}

@property (nonatomic, retain) NSMutableArray *HotkeywordData;
@property (nonatomic, retain) UITableView *topTableView;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;

@property (nonatomic, retain) NSMutableArray *mutableFetchResults;

@end
