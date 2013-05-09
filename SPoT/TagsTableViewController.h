//
//  FlickrTableViewController.h
//  SPoT
//
//  Created by Angel on 5/1/13.
//  Copyright (c) 2013 edu.labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSDictionary *tags;

- (NSString *)currentKeyForRow:(NSUInteger)row;
- (NSUInteger)photoCountWithKey:(NSString *)key;

@end
