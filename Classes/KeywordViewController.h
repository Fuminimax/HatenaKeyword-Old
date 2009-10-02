//
//  KeywordViewController.h
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myParser.h"

@interface KeywordViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	NSString *selectedKeyword;
	
	UITableView *keywordTableView;
	UIToolbar *toolBar;
	
	myParser *bloglistParser;
}

@property (nonatomic, retain) NSString *selectedKeyword;

-(void) showKeywordDetail;

@end
