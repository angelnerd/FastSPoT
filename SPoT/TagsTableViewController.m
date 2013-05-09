//
//  FlickrTableViewController.m
//  SPoT
//
//  Created by Angel on 5/1/13.
//  Copyright (c) 2013 edu.labs. All rights reserved.
//

#import "TagsTableViewController.h"
#import "FlickrFetcher.h"

@interface TagsTableViewController ()
@end

@implementation TagsTableViewController

@synthesize photos = _photos;
@synthesize tags = _tags;

+ (NSArray *)ignoreTags
{
    return @[@"cs193pspot", @"portrait", @"landscape"];
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

- (void)setTags:(NSDictionary *)tags
{
    _tags = tags;
    [self.tableView reloadData];
}

- (NSArray *)photos
{
    if (!_photos) _photos = [NSArray arrayWithArray:[FlickrFetcher stanfordPhotos]];
    return _photos;
}

- (NSDictionary *)tags
{
    if (!_tags) _tags = [NSDictionary dictionaryWithDictionary:[self sortedTagsWith:self.photos]];
    return _tags;
}

- (NSDictionary *)sortedTagsWith:(NSArray *)photos
{
    __block NSMutableDictionary *tagsToReturn = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *photo in photos)
    {
        NSArray *currentPhotoTags = [[photo objectForKey:@"tags"] componentsSeparatedByString:@" "];
        [currentPhotoTags enumerateObjectsUsingBlock:^(id tag, NSUInteger idx, BOOL *stop) {
            if (![[TagsTableViewController ignoreTags] containsObject:tag]) {
                if (![tagsToReturn objectForKey:tag])
                    [tagsToReturn setObject:[NSMutableArray array] forKey:tag];
                
                [[tagsToReturn objectForKey:tag] addObject:photo];
            }
        }];
    }

    return [NSDictionary dictionaryWithDictionary:tagsToReturn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)currentKeyForRow:(NSUInteger)row
{
    return [[[self.tags allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:row];
}

- (NSUInteger)photoCountWithKey:(NSString *)key
{
    return [[self.tags objectForKey:key] count];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // Abstract
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // Abstract
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Abstract
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Abstract
}

@end
