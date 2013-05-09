//
//  DetailTVC.m
//  SPoT
//
//  Created by Angel on 5/2/13.
//  Copyright (c) 2013 edu.labs. All rights reserved.
//

#import "DetailTVC.h"
#import "FlickrFetcher.h"
#import "UserDefaultManager.h"

@interface DetailTVC ()

@end

@implementation DetailTVC

- (void)setDetailPhotos:(NSArray *)detailPhotos
{
    _detailPhotos = detailPhotos;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)dictionaryAtIndex:(NSUInteger)row
{
    return [self.detailPhotos objectAtIndex:row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.detailPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tagDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *currentDictionary = [self dictionaryAtIndex:indexPath.row];
    NSString *title = [currentDictionary objectForKey:@"title"];
    NSString *description = [[currentDictionary objectForKey:@"description"] objectForKey:@"_content"];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = description;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if ([segue.identifier isEqualToString:@"detailToImageView"]) {
        UIViewController *imageViewController = segue.destinationViewController;
        [imageViewController performSelector:@selector(setImageURL:) withObject:[FlickrFetcher urlForPhoto:[self dictionaryAtIndex:indexPath.row] format:FlickrPhotoFormatLarge]];
        [imageViewController performSelector:@selector(setPhoto:) withObject:[self dictionaryAtIndex:indexPath.row]];
        [imageViewController setTitle:[[self dictionaryAtIndex:indexPath.row] objectForKey:@"title"]];
    }
}

@end
