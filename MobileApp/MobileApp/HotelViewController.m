//
//  HotelViewController.m
//  MobileApp
//
//  Created by 澤田　暖 on 2015/11/08.
//  Copyright © 2015年 JET Engine. All rights reserved.
//

#import "HotelViewController.h"

@interface HotelViewController ()

@end

@implementation HotelViewController

@synthesize hotelNameLabel;
@synthesize checkInLabel;
@synthesize checkOutLabel;
@synthesize addressLabel;
@synthesize hotelMap;
@synthesize backgroundImages;
@synthesize background;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    manager = [TravelManager sharedInstance];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    NSDictionary *flightInfo = [manager getDestination];
    NSDictionary *hotelInfo = [manager getHotel];
    
    NSDate *checkInDate = [NSDate dateWithTimeIntervalSince1970:[[flightInfo valueForKey:@"estimatedarrivaltime"] integerValue]];
    NSDate *checkOutDate = [checkInDate dateByAddingTimeInterval:60*60*24*2];
    
    hotelNameLabel.text = [hotelInfo valueForKey:@"hotel_name"];
    addressLabel.text = [hotelInfo valueForKey:@"hotel_addr"];
    checkInLabel.text = [dateFormatter stringFromDate:checkInDate];
    checkOutLabel.text = [dateFormatter stringFromDate:checkOutDate];
    
    hotelMap.delegate = self;
    [hotelMap setShowsUserLocation:NO];
    
    CLLocationCoordinate2D hotelCoordinates = CLLocationCoordinate2DMake([[hotelInfo valueForKey:@"hotel_latLng"][0] floatValue], [[hotelInfo valueForKey:@"hotel_latLng"][1] floatValue]);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:hotelCoordinates];
    [annotation setTitle:[hotelInfo valueForKey:@"hotel_name"]];
    [hotelMap addAnnotation:annotation];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    hotelMap.region = MKCoordinateRegionMake(hotelCoordinates, span);
    
    backgroundImages = [[NSMutableArray alloc] init];
    
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:[NSURL URLWithString:[hotelInfo valueForKey:@"hotel_photo"]]
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                return;
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if (image && finished) {
                                   NSLog(@"FINISH");
                                   [backgroundImages addObject:image];
                                   
                                   [background animateWithImages:backgroundImages
                                              transitionDuration:20
                                                    initialDelay:0
                                                            loop:YES
                                                     isLandscape:YES];
                                    background.alpha = 0.3;
                               }
                           }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
