//
//  TopViewController.h
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "myParser.h"
#import "KeywordViewController.h"

@interface TopViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
	UISearchBar *searchBar;
	UITableView *topTableView;
	UINavigationController *navController;
	KeywordViewController *keyController;
	
	NSMutableArray *HotkeywordData;
	myParser *rssParser;
}

@property (nonatomic, retain) NSMutableArray *HotkeywordData;

@end
