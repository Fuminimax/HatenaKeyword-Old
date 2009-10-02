//
//  SearchListViewController.h
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	NSString *searchWord;
	
	UITableView *searchListTableView;
	
	myParser *searchListParser;
}

@property (nonatomic, retain) NSString *searchWord;

@end
