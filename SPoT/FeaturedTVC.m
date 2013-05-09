//
//  FeaturedTVC.m
//  SPoT
//
//  Created by Angel on 5/2/13.
//  Copyright (c) 2013 edu.labs. All rights reserved.
//

#import "FeaturedTVC.h"
#import "FlickrFetcher.h"

@interface FeaturedTVC ()

@end

@implementation FeaturedTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (IBAction)refresh
{
    UIApplication *myApp = [UIApplication sharedApplication];
    myApp.networkActivityIndicatorVisible = YES;
    [self.refreshControl beginRefreshing];
    dispatch_queue_t q = dispatch_queue_create("Table View Refresh Queue", NULL);
    dispatch_async(q, ^{
        NSArray *newPhotos = [NSArray arrayWithArray:[FlickrFetcher stanfordPhotos]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = newPhotos;
            myApp.networkActivityIndicatorVisible = NO;
            [self.refreshControl endRefreshing];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)prepareArrayForSegueWith:(NSUInteger)row
{
    return [NSArray arrayWithArray:[self.tags objectForKey:[self currentKeyForRow:row]]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tagCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *currentKey = [self currentKeyForRow:indexPath.row];
    NSUInteger photoCount = [self photoCountWithKey:currentKey];
    
    cell.textLabel.text = [currentKey capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %@", photoCount, (photoCount == 1 ? @"Photo" : @"Photos")];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if ([segue.identifier isEqualToString:@"featuredToDetail"]) {
        UIViewController *newController = segue.destinationViewController;
        [newController performSelector:@selector(setDetailPhotos:) withObject:[self prepareArrayForSegueWith:indexPath.row]];
        [newController setTitle:[[self currentKeyForRow:indexPath.row] capitalizedString]];
    }
}

@end
