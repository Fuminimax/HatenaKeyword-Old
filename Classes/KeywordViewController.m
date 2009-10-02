//
//  KeywordViewController.m
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "KeywordViewController.h"
#import "WebViewController.h"
#import "HatenaKeywordAppDelegate.h"

@implementation KeywordViewController

@synthesize selectedKeyword;

-(id)init{
	
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

-(void) showKeywordDetail{
	WebViewController *webViewController = [[WebViewController alloc] init];
	
	NSString *keyword = [self.selectedKeyword substringToIndex:[self.selectedKeyword length]-1];
	NSString *path = [NSString stringWithFormat:@"http://d.hatena.ne.jp/keyword/%@", keyword];
	
	NSString *escapePath = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																			   NULL,
																			   (CFStringRef) path,
																			   NULL,
																			   NULL,
																			   kCFStringEncodingUTF8
																			   );
	
	webViewController.hatenaUrl = escapePath;
	
	[self.navigationController pushViewController:webViewController animated:YES];
	[webViewController release];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	[super loadView];
	
	CGRect bounds = [[UIScreen mainScreen] applicationFrame];
	
	bloglistParser = [[myParser alloc] init];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithTitle:@"詳細"
											   style:UIBarButtonItemStylePlain
											   target:self 
											   action:@selector(showKeywordDetail)] autorelease];
	
	
	self.navigationItem.title = self.selectedKeyword;
	
	keywordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
	
	keywordTableView.delegate = self;
	keywordTableView.dataSource = self;
	keywordTableView.rowHeight = 90.0f;
	
	[self.view addSubview:keywordTableView];
	
	toolBar = [[UIToolbar alloc] init];
	toolBar.barStyle = UIBarStyleDefault;
	
	[toolBar sizeToFit];
	CGFloat toolbarHeight = [toolBar frame].size.height;
	CGRect mainViewBounds = [[UIScreen mainScreen] applicationFrame];
	[toolBar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds), CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - 108.0, CGRectGetWidth(mainViewBounds), toolbarHeight)];
	//Create a button
	UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"ブックマーク" style:UIBarButtonItemStyleBordered target:self action:@selector(info_clicked:)];
	
	[toolBar setItems:[NSArray arrayWithObjects:infoButton,nil]];	
	[self.view addSubview:toolBar];

}

// セルのスタイルをカスタマイズ
-(void) modCell:(UITableViewCell *)aCell withTitle:(NSString *)title withSummary:(NSString *)summary withDate:(NSString *)date withAuthor:(NSString *)author{
	// タイトル
	CGRect tRect1 = CGRectMake(10.0f, 15.0f, 280.0f, 40.0f);
	id title1 = [[UILabel alloc] initWithFrame:tRect1];
	[title1 setText:title];
	[title1 setTextAlignment:UITextAlignmentLeft];
	[title1 setTextColor:[UIColor blueColor]];
	[title1 setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
	[title1 setFont:[UIFont boldSystemFontOfSize:14.0f]];
	[title1 setBackgroundColor:[UIColor clearColor]];
	
	// 概要をトランケートして表示
	CGRect tRect2 = CGRectMake(10.0f, 55.0f, 280.0f, 30.0f);
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
	
	// 日付
	CGRect tRect3 = CGRectMake(10.0f, 5.0f, 140.0f, 10.0f);
	id title3 = [[UILabel alloc] initWithFrame:tRect3];
	//NSString tempDate = [date substringToIndex:[self.selectedKeyword length]-1];
	NSString *year = [[NSString alloc] init];
	NSString *month = [[NSString alloc] init];
	NSString *day = [[NSString alloc] init];
	NSString *hour = [[NSString alloc] init];
	NSString *minutes = [[NSString alloc] init];
	
	year = [date substringWithRange:NSMakeRange(0, 4)];
	month = [date substringWithRange:NSMakeRange(5, 2)];
	day = [date substringWithRange:NSMakeRange(8, 2)];
	hour = [date substringWithRange:NSMakeRange(11, 2)];
	minutes = [date substringWithRange:NSMakeRange(14, 2)];
	
	NSString *formatDate = [NSString stringWithFormat:@"%@年%@月%@日 %@:%@", year, month, day, hour, minutes];
	
	[title3 setText:formatDate];
	[title3 setTextAlignment:UITextAlignmentLeft];
	[title3 setTextColor:[UIColor redColor]];
	[title3 setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
	[title3 setFont:[UIFont boldSystemFontOfSize:10.0f]];
	[title3 setBackgroundColor:[UIColor clearColor]];
	
	// 書いた人
	CGRect tRect4 = CGRectMake(150.0f, 5.0f, 150.0f, 10.0f);
	id title4 = [[UILabel alloc] initWithFrame:tRect4];
	NSString *formatAuthor = [NSString stringWithFormat:@"id:%@", author];
	[title4 setText:formatAuthor];
	[title4 setTextAlignment:UITextAlignmentLeft];
	[title4 setTextColor:[UIColor blackColor]];
	[title4 setFont:[UIFont fontWithName:@"Helvetica" size:10.0f]];
	[title4 setFont:[UIFont boldSystemFontOfSize:10.0f]];
	[title4 setBackgroundColor:[UIColor clearColor]];
	
	//セルに追加する
	[aCell addSubview:title1];
	[aCell addSubview:title2];
	[aCell addSubview:title3];
	[aCell addSubview:title4];
	
	[title1 release];
	[title2	release];
	[title3	release];
	[title4	release];
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView 
		 accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDetailDisclosureButton;			
}


//　テーブルのセクションの数を返す
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

// テーブルのレコード数を返す
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return 25;
}

// セクションのタイトルを返す
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [NSString stringWithFormat:@"%@についての最新ブログ", self.selectedKeyword];
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
	if([bloglistParser.keywordData count] == 0){
		return cell;
	}
	//cell.text = [[bloglistParser.keywordData objectAtIndex:storyIndex] objectForKey:@"title"];
	NSString *title = [[bloglistParser.keywordData objectAtIndex:storyIndex] objectForKey:@"title"];
	NSString *summary = [[bloglistParser.keywordData objectAtIndex:storyIndex] objectForKey:@"summary"];
	NSString *date = [[bloglistParser.keywordData objectAtIndex:storyIndex] objectForKey:@"date"];
	NSString *author = [[bloglistParser.keywordData objectAtIndex:storyIndex] objectForKey:@"author"];
	NSLog(summary);
	[self modCell:cell withTitle:title withSummary:summary withDate:date withAuthor:author];
	
	return cell;
}

// セルがタップされた
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	WebViewController *webViewController = [[WebViewController alloc] init];
	
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	//webViewController.hatenaUrl = [[bloglistParser.keywordData objectAtIndex:storyIndex] objectForKey:@"link"];
	NSString *tempUrl = [[bloglistParser.keywordData objectAtIndex:storyIndex] objectForKey:@"link"];
	webViewController.hatenaUrl = [tempUrl substringToIndex:[tempUrl length]-4];
	[self.navigationController pushViewController:webViewController animated:YES];
	[webViewController release];
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	//NSString *keyword = [self.selectedKeyword substringToIndex:[self.selectedKeyword length]-1];
	//NSString *path = [NSString stringWithFormat:@"http://k.hatena.ne.jp/keywordblog/%@?mode=rss", keyword];
	NSString *path = [NSString stringWithFormat:@"http://k.hatena.ne.jp/keywordblog/%@?mode=rss", self.selectedKeyword];
	NSLog(path);
	NSString *escapePath = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																			   NULL,
																			   (CFStringRef) path,
																			   NULL,
																			   NULL,
																			   kCFStringEncodingUTF8
																			   );
	
	[bloglistParser parseXMLFileAtURL:escapePath];	
	
	[keywordTableView reloadData];
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
