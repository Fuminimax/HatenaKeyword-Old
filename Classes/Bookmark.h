//
//  Bookmark.h
//  HatenaKeyword
//
//  Created by Takayama Fumio on 09/10/08.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Bookmark :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * created_at;

@end



