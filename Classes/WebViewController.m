//
//  WebViewController.m
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "KeywordViewController.h"
#import "WebViewController.h"

@implementation WebViewController

@synthesize webView;
@synthesize hatenaUrl;

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
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height - 48.0)];
	
	webView.scalesPageToFit=YES;
	[self.view addSubview:webView];	
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"viewDidLoad");
	//NSString *tempUrl = [self.hatenaUrl substringToIndex:[self.hatenaUrl length]-4];
	
	NSURL *url = [NSURL URLWithString:self.hatenaUrl];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSLog(self.hatenaUrl);
	[webView loadRequest:request];
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
