//
//  DetailViewController.h
//  BookSampleApp
//
//  Created by Aditya Ashok on 18/09/19.
//  Copyright © 2019 Aditya Ashok. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *bookList;
@property (strong, nonatomic) NSMutableArray *itemsToDisplay;

@property (nonatomic) NSInteger choice;


@end

NS_ASSUME_NONNULL_END
