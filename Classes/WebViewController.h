//
//  WebViewController.h
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController {
	NSString	*hatenaUrl;
	UIWebView	*webView;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString	*hatenaUrl;

@end
