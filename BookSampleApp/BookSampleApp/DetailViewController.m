//
//  DetailViewController.m
//  BookSampleApp
//
//  Created by Aditya Ashok on 18/09/19.
//  Copyright © 2019 Aditya Ashok. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTableCellTableViewCell.h"
#import "BookItem.h"
#import "MainViewController.h"

@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BookItem *selectedItem;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    DetailTableCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"detailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.frame = CGRectMake(0,0,self.view.frame.size.width,400);
    
    BookItem *item = [_itemsToDisplay objectAtIndex:indexPath.row];
    cell.author.text = item.author;
    cell.genre.text = item.genre;
    cell.title.text = item.title;
    cell.title.numberOfLines = 0;
    
    cell.contentView.layer.borderColor = [UIColor blueColor].CGColor;
    cell.contentView.layer.borderWidth = .5;
    
    cell.imageView.image = [UIImage imageNamed:@"placeholder.png"];
    cell.tag = indexPath.row;
    
    NSURL *url = [NSURL URLWithString:item.imageUrl];

       NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           if (data) {
               UIImage *image = [UIImage imageWithData:data];
               if (image) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       DetailTableCellTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                       if (updateCell)
                           updateCell.imageView.image = image;
                   });
               }
           }
       }];
       [task resume];
    
    
    [self downloadImage:item forCellIndex:indexPath andTableView:tableView];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [self.itemsToDisplay count];
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

#pragma mark- Menu table Delegates

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 200;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedItem = [self.itemsToDisplay objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segueComplete" sender:self];
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueComplete"])
    {
        MainViewController *mainView = segue.destinationViewController;
        mainView.item = _selectedItem;
    }
}

-(void)downloadImage:(BookItem *)item forCellIndex:(NSIndexPath*)index andTableView:tableView{
    
    
    DetailTableCellTableViewCell *cell = (id)[tableView cellForRowAtIndexPath:index];
    
    if(cell){
        
        NSURL *url = [NSURL URLWithString:item.imageUrl];
        NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                       downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *downloadedImage = [UIImage imageWithData:
                                            [NSData dataWithContentsOfURL:location]];
                cell.imageView.image = downloadedImage;
            });
        }];
        
        [downloadPhotoTask resume];
        
    }
}



@end
