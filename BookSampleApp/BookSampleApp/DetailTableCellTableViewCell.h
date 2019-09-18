//
//  DetailTableCellTableViewCell.h
//  BookSampleApp
//
//  Created by Aditya Ashok on 18/09/19.
//  Copyright © 2019 Aditya Ashok. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailTableCellTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *author;

@property (weak, nonatomic) IBOutlet UILabel *genre;
@end

NS_ASSUME_NONNULL_END
