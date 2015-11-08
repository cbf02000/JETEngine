//
//  ViewController.m
//  MobileApp
//
//  Created by 澤田　暖 on 2015/11/07.
//  Copyright © 2015年 JET Engine. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize background;
@synthesize backgroundImages;
@synthesize originTitle;
@synthesize originLabel;
@synthesize startSearchButton;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    duration = 0.5f;
    
    [startSearchButton setAlpha:0.0];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    manager = [TravelManager sharedInstance];
    [manager setDelegate:self];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    if ([manager getOrigin] != nil) {
        [self didFinishSetOrigin:[manager getOrigin]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didFinishSetOrigin:(NSDictionary *)origin {
    
    if (origin != nil) {
        [manager setDelegate:nil];
        
        [UIView transitionWithView:originTitle
                          duration:duration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            originTitle.text = @"Departure City";
                        } completion:nil];
        
        
        [UIView transitionWithView:originLabel
                          duration:duration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            originLabel.text = [origin valueForKey:@"city"];
                        } completion:nil];
        
        [UIView transitionWithView:startSearchButton
                          duration:duration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            startSearchButton.alpha = 1.0;
                        } completion:nil];

        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        backgroundImages = [[NSMutableArray alloc] init];
        
        for (NSString* imageUrl in [origin valueForKey:@"cityImageURL"]) {
            
            SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
            [downloader downloadImageWithURL:[NSURL URLWithString:imageUrl]
                                     options:0
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                        return;
                                    }
                                   completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                       if (image && finished) {
                                           NSLog(@"FINISH");
                                           [backgroundImages addObject:image];
                                           if ([backgroundImages count] == [[origin valueForKey:@"cityImageURL"] count]) {
                                               NSLog(@"ALL DONE!");
                                               [background animateWithImages:backgroundImages
                                                          transitionDuration:20
                                                                initialDelay:0
                                                                        loop:YES
                                                                 isLandscape:YES];
                                               background.alpha = 0.3;
                                           }
                                       }
                                   }];
            
        }
    }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    [UIView transitionWithView:background
                      duration:duration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        background.alpha = 0.0;
                    } completion:nil];
    
    return YES;
}

@end
