//
//  ImageViewController.m
//  SPoT
//
//  Created by Angel on 5/2/13.
//  Copyright (c) 2013 edu.labs. All rights reserved.
//

#import "ImageViewController.h"
#import "UserDefaultManager.h"
#import "CacheManager.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ImageViewController

- (void)setPhoto:(NSDictionary *)photo
{
    _photo = photo;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        UIApplication *myApp = [UIApplication sharedApplication];
        myApp.networkActivityIndicatorVisible = YES;
        self.activityIndicator.hidesWhenStopped = YES;
        [self.activityIndicator startAnimating];
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("Download Image", NULL);
        dispatch_async(downloadQueue, ^{
            CacheManager *cacheManager = [[CacheManager alloc] init];
            NSData *imageData = [cacheManager retrievePhoto:[self.photo objectForKey:@"id"]];
            
            if (!imageData) {
                imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
                [cacheManager cachePhoto:imageData withID:[self.photo objectForKey:@"id"]];
                NSLog(@"Set new cache!");
            }
            
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [UserDefaultManager setRecentlyViewedImageWith:self.photo];
            
            [NSThread sleepForTimeInterval:3.0];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    myApp.networkActivityIndicatorVisible = NO;
                    [self.activityIndicator stopAnimating];
                    self.scrollView.zoomScale = 1.0;
                    self.scrollView.contentSize = image.size;
                    self.imageView.image = image;
                    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                }
            });
        });
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
