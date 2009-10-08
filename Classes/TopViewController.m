//
//  TopViewController.m
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HatenaKeywordAppDelegate.h"
#import "TopViewController.h"
#import "SearchListViewController.h"

@implementation TopViewController

@synthesize HotkeywordData;
@synthesize topTableView;
@synthesize fetchedResultsController, managedObjectContext, addingManagedObjectContext;
@synthesize mutableFetchResults;

-(id) init{
	self = [super init];
	if(self != nil){
		HotkeywordData = [[NSMutableArray alloc] init];
		rssParser = [[myParser alloc] init];
		
		if([HotkeywordData count] == 0){
			NSString *path = @"http://d.hatena.ne.jp/hotkeyword?mode=rss";
			[rssParser parseXMLFileAtURL:path];
		}
		
	}
	NSLog(@"TopViewController init End");
	
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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	CGRect bounds = [[UIScreen mainScreen] applicationFrame];
	
	self.navigationItem.title = @"はてなキーワード";
	
	searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.width, 48.0)];
	searchBar.delegate = self;
	searchBar.placeholder = @"キーワードを入れてください";
	
	[self.view addSubview:searchBar];
	
	topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
	
	topTableView.delegate = self;
	topTableView.dataSource = self;
	
	self.navigationItem.titleView = searchBar;
	self.navigationItem.titleView.frame = CGRectMake(0, 0, 320, 44);
	
	[self.view addSubview:topTableView];
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		//NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		NSLog(@"Unresolved error %@", error);
		exit(-1);  // Fail
	}
	
	NSLog(@"TopViewController loadView End");
	
	//[topTableView reloadData];
}


- (void)viewWillAppear {
	[topTableView reloadData];
}


//　テーブルのセクションの数を返す
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}

/*
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView 
		 accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 0) {
        return UITableViewCellAccessoryDisclosureIndicator;
	}
}
*/

// セクションのタイトルを設定する
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(section == 0){
		return @"注目キーワード TOP5";
	}else if(section == 1){
		return @"最近ブックマークしたキーワード";
	}
	
	return nil;
}

// テーブルのレコード数を返す
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == 0){
		return 5;
	}else{
		return 10;
	}
}

// このメソッドはテーブルのレコード数だけループして呼ばれる。
// indexPathにはループのセル番号（0スタート）が入る
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	// セルのオブジェクトに付ける名前の文字列を生成する
	NSString *CellIdentifier = @"HotKeyword";
	
	// HotKeywordと言う名前の再利用可能なセルのオブジェクトを生成する
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	// もし生成されていなかったら、セルのオブジェクト生成する
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	
	if(indexPath.section == 0){
		cell.textLabel.text = [[rssParser.keywordData objectAtIndex:storyIndex] objectForKey:@"title"];
		
	}else{
		
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bookmark" inManagedObjectContext:managedObjectContext];
		
		[request setEntity:entity];
		
		NSSortDescriptor *sortDescripter = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
		NSArray *sortDescripters = [[NSArray alloc] initWithObjects:sortDescripter, nil];
		
		[request setSortDescriptors:sortDescripters];
		
		[sortDescripter release];
		[sortDescripters release];
		
		NSError *error;
		mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
		if(mutableFetchResults == nil){
			NSLog(@"FetchResults Error %@", error);
		}
		
		int cnt = [mutableFetchResults count];
		int row = indexPath.row;
		if(cnt != 0){
			if(row < cnt){
				Bookmark *bookmark = [mutableFetchResults objectAtIndex:row];
				cell.textLabel.text = bookmark.name;
			}
		}
		//NSLog(cnt);
		
		/*
		if(indexPath.row == 5){
			cell.textLabel.text = @"もっと見る";
		}else{
			HatenaKeywordAppDelegate *appDelegate = (HatenaKeywordAppDelegate *)[[UIApplication sharedApplication] delegate];
			int cnt = [appDelegate.bookmarks count];
			int row = indexPath.row;
			if(cnt != 0){
				if(row < cnt){
					Bookmark *bookmark = (Bookmark *)[appDelegate.bookmarks objectAtIndex:indexPath.row];
					cell.textLabel.text = bookmark.word;
				}
			}
			
		}
		*/
		 
	}
	
	return cell;
}

// セルがタップされた
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	KeywordViewController *keywordViewController = [[KeywordViewController alloc] init];
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	
	if(indexPath.section == 0){
		NSString *tempWord = [[rssParser.keywordData objectAtIndex:storyIndex] objectForKey:@"title"];
		keywordViewController.selectedKeyword = [tempWord substringToIndex:[tempWord length]-2];
		NSLog(@"tempWord:%@", tempWord);
		NSLog(@"selectedKeyword:%@", keywordViewController.selectedKeyword);
	}else{
		
		Bookmark *bookmark = [mutableFetchResults objectAtIndex:indexPath.row];
		keywordViewController.selectedKeyword = bookmark.name;
		
		/*
		HatenaKeywordAppDelegate *appDelegate = (HatenaKeywordAppDelegate *)[[UIApplication sharedApplication] delegate];
		Bookmark *bookmark = (Bookmark *)[appDelegate.bookmarks objectAtIndex:indexPath.row];
		
		keywordViewController.selectedKeyword = bookmark.word;
		NSLog(bookmark.word);
		*/
	}
	[self.navigationController pushViewController:keywordViewController animated:YES];
	[keywordViewController release];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBarArg{
	searchBarArg.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBarArg{
	searchBarArg.showsCancelButton = NO;
}

// SearchBarでキャンセルボタンを押されたとき
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBarArg{
	// キーボードを隠す
	[searchBarArg resignFirstResponder];
}

// SearchBarで検索が実行された時
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarArg{
	
	SearchListViewController *searchListViewController = [[SearchListViewController alloc] init];
	
	searchListViewController.searchWord = searchBarArg.text;
	
	[searchBarArg resignFirstResponder];
	
	[self.navigationController pushViewController:searchListViewController animated:YES];
	[searchListViewController release];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return NO;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[topTableView reloadData];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bookmark" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSSortDescriptor *urlDescriptor = [[NSSortDescriptor alloc] initWithKey:@"url" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, urlDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"name" cacheName:@"Root"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	[urlDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}

/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[topTableView beginUpdates];
}

// オブジェクトが変更された時コールバックされる
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	UITableView *tableView = topTableView;
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			//[topTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[topTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			// Reloading the section inserts a new row and ensures that titles are updated appropriately.
			[tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


// セクションが変更されるとき？
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			//[topTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[topTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[topTableView endUpdates];
}

// Delegate End

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.fetchedResultsController = nil;
}


- (void)dealloc {
	[topTableView release];
    [super dealloc];
}


@end
