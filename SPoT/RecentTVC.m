//
//  RecentTVC.m
//  SPoT
//
//  Created by Angel on 5/3/13.
//  Copyright (c) 2013 edu.labs. All rights reserved.
//

#import "RecentTVC.h"
#import "UserDefaultManager.h"
#import "FlickrFetcher.h"

@interface RecentTVC ()

@end

@implementation RecentTVC

- (void)viewWillAppear:(BOOL)animated
{
    [self setDetailPhotos:[[NSUserDefaults standardUserDefaults] arrayForKey:@"recentlyViewed"]];
}

@end
