//
//  BookItem.h
//  BookSampleApp
//
//  Created by Aditya Ashok on 17/09/19.
//  Copyright © 2019 Aditya Ashok. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookItem : NSObject

@property (strong,nonatomic) NSString *authorCountry;
@property (strong,nonatomic) NSString *author;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *genre;
@property (strong,nonatomic) NSString *id;
//@property (strong,nonatomic) UIImage  *image;
@property (strong,nonatomic) NSString *imageUrl;
@property (strong,nonatomic) NSString *publisher;
@property (strong,nonatomic) NSString *soldCount;

-(BookItem *)initFileItemFromAttributesDictionary:(NSDictionary *)attributeDict;

@end

