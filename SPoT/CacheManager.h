//
//  CacheManager.h
//  SPoT
//
//  Created by Angel on 5/6/13.
//  Copyright (c) 2013 edu.labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

- (void)cachePhoto:(NSData *)photo withID:(NSString *)photoID;
- (NSData *)retrievePhoto:(NSString *)photoID;

@end
