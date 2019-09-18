//
//  MainViewController.h
//  BookSampleApp
//
//  Created by Aditya Ashok on 18/09/19.
//  Copyright © 2019 Aditya Ashok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController

@property (strong, nonatomic) BookItem *item;

@end

NS_ASSUME_NONNULL_END
