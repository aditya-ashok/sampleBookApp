//
//  ViewController.m
//  BookSampleApp
//
//  Created by Aditya Ashok on 17/09/19.
//  Copyright © 2019 Aditya Ashok. All rights reserved.
//

#import "ViewController.h"
#import "BookItem.h"
#import "DetailViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *bookList;
@property (strong, nonatomic) NSMutableArray *favList;
@property (strong, nonatomic) NSMutableDictionary *author;
@property (strong, nonatomic) NSMutableDictionary *country;
@property (strong, nonatomic) NSMutableDictionary *genre;

@property (strong, nonatomic) NSMutableArray *authorList;
@property (strong, nonatomic) NSMutableArray *genreList;
@property (strong, nonatomic) NSMutableArray *countryList;

@property (strong, nonatomic) NSString *selectedList;

@property (nonatomic) NSInteger choice;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_bookList = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = false;
    //self.tableView.backgroundColor = UIColor.orangeColor; // For visualisation
    
    self.choice = -1;
    [self initializeDicts];
}

-(void)initializeDicts{
 
    _author = [[NSMutableDictionary alloc] init];
    _genre = [[NSMutableDictionary alloc] init];
    _country = [[NSMutableDictionary alloc] init];
    
    _countryList = [[NSMutableArray alloc] init];
    _authorList = [[NSMutableArray alloc] init];
    _genreList = [[NSMutableArray alloc] init];

    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator
{
    [self.tableView reloadData];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

-(void)getData{
    
    self.choice = 0;
    [self fetchData];
}

-(void)fetchData{
    
    _bookList = nil;
    _favList = nil;
    if(_bookList==nil){
        _bookList = [[NSMutableArray alloc] init];
        _favList = [[NSMutableArray alloc] init];
        
        [self initializeDicts];
    }
    
    NSString *dataUrl = @"http://android.jiny.mockable.io/getAll";
    NSURL *url = [NSURL URLWithString:dataUrl];
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              if(error==nil){
                                                  NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                  [self convertStringIntoObj:json];
                                                  [self reloadTable];
                                              }
                                          }];
    [downloadTask resume];
    
    
}

-(void)reloadTable{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    
}

- (IBAction)filterPressed:(UIBarButtonItem *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Message" preferredStyle:UIAlertControllerStyleAlert];
    alert.preferredContentSize = CGSizeMake(200.0, 150.0);
    alert.modalPresentationStyle =  UIModalPresentationPopover;
    
    UIAlertAction *books = [UIAlertAction actionWithTitle:@"Books" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.choice = 0;
    }];
    
    
    UIAlertAction *choiceAuthor = [UIAlertAction actionWithTitle:@"Author" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.choice = 1;
    }];
    
    UIAlertAction *choiceCountry = [UIAlertAction actionWithTitle:@"Country" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.choice = 2;
    }];
    
    UIAlertAction *choiceGenre = [UIAlertAction actionWithTitle:@"Genre" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.choice = 3;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  
    [alert addAction:books];
    [alert addAction:choiceAuthor];
    [alert addAction:choiceCountry];
    [alert addAction:choiceGenre];
    [alert addAction:cancel];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:alert.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.view.frame.size.height*0.8f];
    [alert.view addConstraint:constraint];
    [self presentViewController:alert animated:YES completion:nil];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
    }
    
    BookItem *item = [_bookList objectAtIndex:indexPath.row];
    
    if([[_favList objectAtIndex:indexPath.row]  isEqual: @"1"]){
        cell.contentView.backgroundColor = UIColor.orangeColor;
    }else{
         cell.contentView.backgroundColor = UIColor.clearColor;
    }
    
    if(self.choice==0){
        cell.textLabel.text = item.title;
    }
    else if(self.choice==1){
        cell.textLabel.text = [_authorList objectAtIndex:indexPath.row];
    }
    else if(self.choice==2){
        cell.textLabel.text = [_countryList objectAtIndex:indexPath.row];
    }
    else if(self.choice==3){
          cell.textLabel.text = [_genreList objectAtIndex:indexPath.row];
    }
    
    cell.contentView.layer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor cyanColor]);
    cell.contentView.layer.borderColor = [UIColor blueColor].CGColor;
    cell.contentView.layer.borderWidth = .5;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Book List";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.choice==1){
        return [_authorList count];
    }
    
    else if(self.choice==2){
        return [_countryList count];
    }
    
    else if(self.choice==3){
        return [_genreList count];
    }
    return [_bookList count];;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(self.choice>=0){
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 5, tableView.frame.size.width, 20);
    
    [button addTarget:self
               action:@selector(getData)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Create Book Library" forState:UIControlStateNormal];
    [view addSubview:button];
    
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    
    return view;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.choice==0){
        return;
    }
    _selectedList = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self performSegueWithIdentifier:@"segueDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"segueDetail"])
    {
        DetailViewController *detailView = segue.destinationViewController;
        detailView.choice = self.choice;
        detailView.bookList = self.bookList;
        
        if(self.choice==0){
           // detailView.itemDict = self.bookList;
        }else if(self.choice==1){
            NSMutableArray *arr = [self.author objectForKey:_selectedList];
            detailView.itemsToDisplay = arr;
        }else if(self.choice==2){
            NSMutableArray *arr = [self.country objectForKey:_selectedList];
                       detailView.itemsToDisplay = arr;
        }else if(self.choice==3){
             NSMutableArray *arr = [self.genre objectForKey:_selectedList];
                       detailView.itemsToDisplay = arr;
        }
    }
}

-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.choice>0){
        return nil;
    }
    
    UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        [self->_bookList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[delete]];
    
    return config;
}
- (IBAction)refreshPressed:(id)sender {
    [self fetchData];
}

-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.choice>0){
        return nil;
    }
    
    if([[_favList objectAtIndex:indexPath.row]  isEqual: @"0"]){
        
        UIContextualAction *fav = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Fav" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            
            [self->_favList setObject:@"1" atIndexedSubscript:indexPath.row];
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.contentView.backgroundColor = UIColor.orangeColor;
            
        }];
        
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[fav]];
        return config;
        
    }else{
        
        UIContextualAction *fav = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"UnFav" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [self->_favList setObject:@"0" atIndexedSubscript:indexPath.row];
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.contentView.backgroundColor = UIColor.clearColor;
        }];
        
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[fav]];
        return config;
    }
}

-(void)convertStringIntoObj:(NSString*)jsonString{
    
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"Result = %@", dict);
    
    NSArray *array = [dict objectForKey:@"list"];

    for (NSDictionary *innerDict in array) {
        
        BookItem *item = [[BookItem alloc] initFileItemFromAttributesDictionary:innerDict];
        NSString *genre = [item.genre capitalizedString];
        NSString *author = [item.author capitalizedString];
        NSString *country = [item.authorCountry capitalizedString];
        
        NSMutableArray *genres = [[NSMutableArray alloc] init];
        if(![_genre objectForKey:genre]){

            [genres addObject:item];
            [_genre setObject:genres forKey:genre];
            [_genreList addObject:genre];
        }else{

            genres = [_genre objectForKey:genre];
            [genres addObject:item];
            [_genre setObject:genres forKey:genre];
        }

        NSMutableArray *countries = [[NSMutableArray alloc] init];
        if(![_country objectForKey:country]){
            [countries addObject:item];
            [_country setObject:countries forKey:country];
            [_countryList addObject:country];
        }else{
            countries = [_country objectForKey:country];
            [countries addObject:item];
            [_country setObject:countries forKey:country];
        }
        
        
        NSMutableArray *authors = [[NSMutableArray alloc] init];
        if(![_author objectForKey:author]){
               
            [authors addObject:item];
            [_author setObject:authors forKey:author];
            [_authorList addObject:author];
            
        }else{
            
            authors = [_author objectForKey:author];
            [authors addObject:item];
            [_author setObject:authors forKey:author];
        }
        
        [_bookList addObject:item];
        [_favList addObject:@"0"];
    }
}

@end
