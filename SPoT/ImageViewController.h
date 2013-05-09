//
//  ImageViewController.h
//  SPoT
//
//  Created by Angel on 5/2/13.
//  Copyright (c) 2013 edu.labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) NSDictionary *photo;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)setPhoto:(NSDictionary *)photo;
- (void)setImageURL:(NSURL *)imageURL;

@end
