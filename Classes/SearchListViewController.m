//
//  SearchListViewController.m
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "KeywordViewController.h"
#import "SearchListViewController.h"

@implementation SearchListViewController

@synthesize searchWord;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	CGRect bounds = [[UIScreen mainScreen] applicationFrame];
	
	self.navigationItem.title = self.searchWord;
	
	searchListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
	
	searchListTableView.delegate = self;
	searchListTableView.dataSource = self;
	searchListTableView.rowHeight = 70.0f;
	
	[self.view addSubview:searchListTableView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//NSString *keyword = [self.selectedKeyword substringToIndex:[self.searchWord length]-1];
	NSString *path = [NSString stringWithFormat:@"http://search.hatena.ne.jp/keyword?word=%@&mode=rss&ie=utf8&page=1", searchWord];
	
	NSString *escapePath = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																			   NULL,
																			   (CFStringRef) path,
																			   NULL,
																			   NULL,
																			   kCFStringEncodingUTF8
																			   );
	
	searchListParser = [[myParser alloc] init];
	[searchListParser parseXMLFileAtURL:escapePath];	
	
	[searchListTableView reloadData];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView 
		 accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellAccessoryDisclosureIndicator;
}

//　テーブルのセクションの数を返す
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

// テーブルのレコード数を返す
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return [searchListParser.keywordData count];
}

// セクションのタイトルを返す
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [NSString stringWithFormat:@"%@での検索結果", self.searchWord];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	// セルのオブジェクトに付ける名前の文字列を生成する
	NSString *CellIdentifier = @"HotKeyword";
	
	// HotKeywordと言う名前の再利用可能なセルのオブジェクトを生成する
	//UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	
	// もし生成されていなかったら、セルのオブジェクト生成する
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	if([searchListParser.keywordData count] == 0){
		return cell;
	}
	//cell.text = [[searchListParser.keywordData objectAtIndex:storyIndex] objectForKey:@"title"];
	NSString *title = [[searchListParser.keywordData objectAtIndex:storyIndex] objectForKey:@"title"];
	NSString *summary = [[searchListParser.keywordData objectAtIndex:storyIndex] objectForKey:@"summary"];
	//NSString *date = [[bloglistParser.keywordData objectAtIndex:storyIndex] objectForKey:@"date"];
	//NSString *author = [[bloglistParser.keywordData objectAtIndex:storyIndex] objectForKey:@"author"];
	//NSLog(summary);
	[self modSearchCell:cell withTitle:title withSummary:summary];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	KeywordViewController *keywordViewController = [[KeywordViewController alloc] init];
	
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	NSString *tempWord = [[searchListParser.keywordData objectAtIndex:storyIndex] objectForKey:@"title"];
	keywordViewController.selectedKeyword = [tempWord substringToIndex:[tempWord length]-5];
	
	[self.navigationController pushViewController:keywordViewController animated:YES];
	[keywordViewController release];
}	


// セルのスタイルをカスタマイズ
-(void) modSearchCell:(UITableViewCell *)aCell withTitle:(NSString *)title withSummary:(NSString *)summary{
	// タイトル
	CGRect tRect1 = CGRectMake(10.0f, 10.0f, 280.0f, 30.0f);
	id title1 = [[UILabel alloc] initWithFrame:tRect1];
	[title1 setText:title];
	[title1 setTextAlignment:UITextAlignmentLeft];
	[title1 setTextColor:[UIColor blueColor]];
	[title1 setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
	[title1 setFont:[UIFont boldSystemFontOfSize:14.0f]];
	[title1 setBackgroundColor:[UIColor clearColor]];
	
	// 概要をトランケートして表示
	CGRect tRect2 = CGRectMake(10.0f, 40.0f, 280.0f, 30.0f);
	UILabel *title2 = [[UILabel alloc] initWithFrame:tRect2];
	[title2 setText:summary];
	//[title2 setText:@"aaa"];
	//[title2 sizeThatFits:CGSizeMake(320.0f, 20.0f)];
	title2.lineBreakMode = UILineBreakModeWordWrap;
	title2.numberOfLines = 2;
	//title2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;	
	[title2 setTextAlignment:UITextAlignmentLeft];
	[title2 setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
	[title2 setBackgroundColor:[UIColor clearColor]];
	
	//セルに追加する
	[aCell addSubview:title1];
	[aCell addSubview:title2];
	
	[title1 release];
	[title2	release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
