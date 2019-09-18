//
//  MainViewController.m
//  BookSampleApp
//
//  Created by Aditya Ashok on 18/09/19.
//  Copyright © 2019 Aditya Ashok. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *genre;
@property (weak, nonatomic) IBOutlet UILabel *about;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.frame;
    
}


-(void)setupView{

    //self.scrollView.frame = self.view.frame;
    
    if(self.item){
        
        self.navigationItem.title = self.item.title;
        self.author.text = self.item.author;
        self.genre.text = self.item.genre;
        self.about.numberOfLines = 0;
        self.about.text = [NSString stringWithFormat:@"|Publisher:%@ | Sold: %@ | Id: %@ |", self.item.publisher,self.item.soldCount,self.item.id];
        [self.about sizeToFit];
        
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.borderColor = [UIColor colorWithRed:0.99 green:0.52 blue:0.72 alpha:1.0].CGColor;
        self.imageView.layer.borderWidth = 7;
        self.imageView.image = [UIImage imageNamed:@"placeholder.png"];
        [self downloadImage:self.item];
    }    
}




-(void)downloadImage:(BookItem *)item{
    
    NSURL *url = [NSURL URLWithString:item.imageUrl];
    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                   downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        UIImage *downloadedImage = [UIImage imageWithData:
        [NSData dataWithContentsOfURL:location]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image = downloadedImage;
        });
    }];
    
    [downloadPhotoTask resume];
    
}


@end
