//
//  DetailTVC.h
//  SPoT
//
//  Created by Angel on 5/2/13.
//  Copyright (c) 2013 edu.labs. All rights reserved.
//

#import "TagsTableViewController.h"

@interface DetailTVC : TagsTableViewController

@property (nonatomic, strong) NSArray *detailPhotos;

- (void)setDetailPhotos:(NSArray *)detailPhotos;
- (NSDictionary *)dictionaryAtIndex:(NSUInteger)row;

@end
