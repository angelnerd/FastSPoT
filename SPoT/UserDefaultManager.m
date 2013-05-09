//
//  UserDefaultManager.m
//  SPoT
//
//  Created by Angel on 5/3/13.
//  Copyright (c) 2013 edu.labs. All rights reserved.
//

#import "UserDefaultManager.h"
#import "CacheManager.h"

const int maxNumberOfRecentPhotos = 10;

@interface UserDefaultManager ()
@end

@implementation UserDefaultManager

+ (void)setRecentlyViewedImageWith:(NSDictionary *)photo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentArray = [NSMutableArray arrayWithArray:[[userDefaults arrayForKey:@"recentlyViewed"] mutableCopy]];
    //NSLog(@"%@", recentArray);
    
    if (!recentArray) recentArray = [NSMutableArray array];
    
    NSString *newID = [photo valueForKey:@"id"];
    __block NSDictionary *objectToDelete = [NSDictionary dictionary];
    
    [recentArray enumerateObjectsUsingBlock:^(id photo, NSUInteger idx, BOOL *stop) {
        NSString *oldID = [[recentArray objectAtIndex:idx] objectForKey:@"id"];
        if ([newID isEqualToString:oldID])
            objectToDelete = [recentArray objectAtIndex:idx];
    }];
    
    [recentArray removeObjectIdenticalTo:objectToDelete];
    [recentArray insertObject:photo atIndex:0];

    NSArray *finalArray = [NSMutableArray array];
    if ([recentArray count] > maxNumberOfRecentPhotos)
        finalArray = [recentArray subarrayWithRange:NSMakeRange(0, maxNumberOfRecentPhotos)];
    else
        finalArray = [recentArray copy];
        
    [userDefaults setValue:finalArray forKey:@"recentlyViewed"];
    [userDefaults synchronize];
}


@end
