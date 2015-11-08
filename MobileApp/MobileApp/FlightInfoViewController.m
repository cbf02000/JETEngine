//
//  FlightInfoViewController.m
//  MobileApp
//
//  Created by 澤田　暖 on 2015/11/08.
//  Copyright © 2015年 JET Engine. All rights reserved.
//

#import "FlightInfoViewController.h"

@interface FlightInfoViewController ()

@end

@implementation FlightInfoViewController

@synthesize flightNumberLabel;
@synthesize arrivalTimeLabel;
@synthesize departureTimeLabel;
@synthesize originLabel;
@synthesize destinationLabel;
@synthesize background;
@synthesize cityMap;
@synthesize backgroundImages;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    manager = [TravelManager sharedInstance];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    NSDictionary *flightInfo = [manager getDestination];
    
    NSDate *departureDate = [NSDate dateWithTimeIntervalSince1970:[[flightInfo valueForKey:@"filed_departuretime"] integerValue]];
    NSDate *arrivalDate = [NSDate dateWithTimeIntervalSince1970:[[flightInfo valueForKey:@"estimatedarrivaltime"] integerValue]];
    
    flightNumberLabel.text = [flightInfo valueForKey:@"ident"];
    originLabel.text = [flightInfo valueForKey:@"originCity"];
    destinationLabel.text = [flightInfo valueForKey:@"destinationCity"];
    departureTimeLabel.text = [dateFormatter stringFromDate:departureDate];
    arrivalTimeLabel.text = [dateFormatter stringFromDate:arrivalDate];
    
    cityMap.delegate = self;
    [cityMap setShowsUserLocation:NO];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:[flightInfo valueForKey:@"destinationCity"]
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateSpan span = MKCoordinateSpanMake(0.8, 0.8);
                         [cityMap setRegion:MKCoordinateRegionMake(topResult.location.coordinate, span) animated:YES];
                         [cityMap addAnnotation:placemark];
                     }
                 }
     ];
    
    backgroundImages = [[NSMutableArray alloc] init];
    
    for (NSString* imageUrl in [flightInfo valueForKey:@"destCityImgUrl"]) {
        
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
                                       if ([backgroundImages count] == [[flightInfo valueForKey:@"destCityImgUrl"] count]) {
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
