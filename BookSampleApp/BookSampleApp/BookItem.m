//
//  BookItem.m
//  BookSampleApp
//
//  Created by Aditya Ashok on 17/09/19.
//  Copyright © 2019 Aditya Ashok. All rights reserved.
//

#import "BookItem.h"

@implementation BookItem

-(BookItem *)initFileItemFromAttributesDictionary:(NSDictionary *)attributeDict
{
    self = [super init];
    if(self != nil)
    {
        self.id = [attributeDict objectForKey:@"id"];
        self.title = [attributeDict objectForKey:@"book_title"];
        self.author = [attributeDict objectForKey:@"author_name"];
        self.genre = [attributeDict objectForKey:@"genre"];
        self.publisher = [attributeDict objectForKey:@"publisher"];
        self.authorCountry = [attributeDict objectForKey:@"author_country"];
        self.soldCount = [attributeDict objectForKey:@"sold_count"];
        self.imageUrl = [attributeDict objectForKey:@"image_url"];
        
    }
    return self;
}


@end
