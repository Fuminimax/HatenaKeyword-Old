//
//  myParser.m
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/02.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "myParser.h"


@implementation myParser

@synthesize item;
@synthesize currentElement;
@synthesize currentTitle;
@synthesize currentSummary;
@synthesize currentLink;
@synthesize currentDate;
@synthesize currentAuthor;
@synthesize keywordData;
@synthesize keywordDetail;

-(void)parseXMLFileAtURL:(NSString *)URL{
	NSURL *xmlURL = [NSURL URLWithString:URL];
	
	keywordData = [[NSMutableArray alloc] init];
	
	rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
	[rssParser setDelegate:self];
	[rssParser setShouldProcessNamespaces:NO];
	[rssParser setShouldReportNamespacePrefixes:NO];
	[rssParser setShouldResolveExternalEntities:NO];
	
	[rssParser parse];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = [elementName copy];
	
	if([elementName isEqualToString:@"item"]){
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentAuthor = [[NSMutableString alloc] init];
		keywordDetail = [[NSMutableString alloc] init];
	}
}	

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if([elementName isEqualToString:@"item"]){
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:currentSummary forKey:@"summary"];
		[item setObject:currentLink forKey:@"link"];
		[item setObject:currentDate forKey:@"date"];
		[item setObject:currentAuthor forKey:@"author"];
		[item setObject:keywordDetail forKey:@"detail"];
		
		[keywordData addObject:[item copy]];
		//NSLog([keywordData valueForKey:@"link"]);
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if([currentElement isEqualToString:@"title"]){
		[currentTitle appendString:string];
		//NSLog(@"title:%@", string);
	} else if ([currentElement isEqualToString:@"link"]) {
		[currentLink appendString:string];
	} else if ([currentElement isEqualToString:@"description"]) {
		[currentSummary appendString:string];
	} else if ([currentElement isEqualToString:@"dc:date"]) {
		[currentDate appendString:string];
	} else if ([currentElement isEqualToString:@"dc:creator"]) {
		[currentAuthor appendString:string];
	} else if ([currentElement isEqualToString:@"content:encoded"]) {
		[keywordDetail appendString:string];
	}
	//NSLog(@"currentTitle:%@", currentTitle);
	//NSLog(@"currentLiink:%@", string);
}

@end
