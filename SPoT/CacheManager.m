//
//  CacheManager.m
//  SPoT
//
//  Created by Angel on 5/6/13.
//  Copyright (c) 2013 edu.labs. All rights reserved.
//

#import "CacheManager.h"

#define MAX_CACHE_SIZE 3 * 1048576

@interface CacheManager ()
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic) NSUInteger cacheSize;
@property (nonatomic, strong) NSString *cachePath;
@end

@implementation CacheManager

- (NSFileManager *)fileManager
{
    return [NSFileManager defaultManager];
}

- (NSString *)cachePath
{
    NSError *error;
    NSURL *url = [self.fileManager URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:&error];
    NSURL *imageDirectory = [url URLByAppendingPathComponent:@"Photos"];
    _cachePath = [imageDirectory path];
    
    if (![self.fileManager fileExistsAtPath:[imageDirectory path]])
        [self.fileManager createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSLog(@"create dir error: %@", error);
    return _cachePath;
}

- (void)cachePhoto:(NSData *)photo withID:(NSString *)photoID
{
    NSURL *directoryPath = [[NSURL alloc] initFileURLWithPath:self.cachePath isDirectory:YES];
    NSURL *photoPath = [directoryPath URLByAppendingPathComponent:photoID];
    NSLog(@"Cache Photo URL: %@", photoPath);
    
    if (![self.fileManager fileExistsAtPath:[photoPath path]]) {
        [photo writeToFile:[photoPath path] atomically:YES];
        [self purgeCheck];
    }
}

- (NSData *)retrievePhoto:(NSString *)photoID
{
    NSData *data = nil;
    NSString *filePath = [self.cachePath stringByAppendingPathComponent:photoID];
    
    if ([self.fileManager fileExistsAtPath:filePath]) {
        data = [[NSData alloc] initWithContentsOfFile:filePath];
    }
    
    return data;
}

- (void)purgeCheck
{
    NSURL *contentsURL = [[NSURL alloc] initFileURLWithPath:self.cachePath isDirectory:YES];
    NSArray *photoDirectoryContents = [self.fileManager contentsOfDirectoryAtURL:contentsURL includingPropertiesForKeys:@[NSURLContentAccessDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    if (self.cacheSize >= MAX_CACHE_SIZE && [photoDirectoryContents count] > 0) {
        NSMutableArray *orderedListByAccessDate = [[photoDirectoryContents sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDate *date1 = [obj1 resourceValuesForKeys:@[NSURLContentAccessDateKey] error:nil][NSURLContentAccessDateKey];
            NSDate *date2 = [obj2 resourceValuesForKeys:@[NSURLContentAccessDateKey] error:nil][NSURLContentAccessDateKey];
            
            return [date2 compare:date1];
        }] mutableCopy];
        
        [self.fileManager removeItemAtURL:[orderedListByAccessDate lastObject] error:nil];
        
        NSLog(@"Last Photo Eliminated.");
        NSLog(@"New Cache Size: %d", self.cacheSize);
    }
}

- (NSUInteger)cacheSize
{
    NSURL *directory = [[NSURL alloc] initFileURLWithPath:self.cachePath isDirectory:YES];
    NSArray *files = [self.fileManager contentsOfDirectoryAtPath:self.cachePath error:nil];
    _cacheSize = 0;
    NSLog(@"Dir Array: %@", files);
    
    if (files) {
        for (NSString *file in files) {
            NSUInteger bytes = [[NSData dataWithContentsOfFile:[[directory URLByAppendingPathComponent:file] path]] length];
            _cacheSize += bytes;
        }
    }
    
    NSLog(@"Cache Size: %d", _cacheSize);
    
    return _cacheSize;
}

@end
