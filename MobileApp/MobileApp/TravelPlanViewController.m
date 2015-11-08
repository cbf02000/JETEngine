//
//  TravelPlanViewController.m
//  MobileApp
//
//  Created by 澤田　暖 on 2015/11/07.
//  Copyright © 2015年 JET Engine. All rights reserved.
//

#import "TravelPlanViewController.h"

@interface TravelPlanViewController ()

@end

@implementation TravelPlanViewController

@synthesize flightLabel;
@synthesize hotelLabel;
@synthesize uberLabel;
@synthesize flightImage;
@synthesize hotelImage;
@synthesize uberMap;
@synthesize flightIndicator;
@synthesize hotelIndicator;
@synthesize uberIndicator;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    duration = 0.5f;
    
    isFlightSet = NO;
    isHotelSet = NO;
    isUberSet = NO;
    
    manager = [TravelManager sharedInstance];
    [manager setDelegate:self];
    
    [manager setDestination];
    hotelLabel.alpha =0.0;
    uberLabel.alpha =0.0;
    flightIndicator.alpha = 1.0;
    hotelIndicator.alpha = 0.5;
    uberIndicator.alpha = 0.5;
}

- (void)viewDidAppear:(BOOL)animated {
    counterFlight = 0;
    [self animateFlightIndicator];
}

- (void)animateFlightIndicator {
    [UIView animateWithDuration: 1.0f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         self.flightIndicator.transform = CGAffineTransformRotate(flightIndicator.transform, M_PI);
                     }
                     completion: ^(BOOL finished) {
                         
                         if (finished) {
                             counterFlight++;
                             NSLog(@"%d", counterFlight);
                             if (counterFlight % 2 == 1 || !isFlightSet) {
                                 [self animateFlightIndicator];
                             }
                         }
                         
                     }];
}

- (void)animateHotelIndicator {
    [UIView animateWithDuration: 1.0f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         self.hotelIndicator.transform = CGAffineTransformRotate(hotelIndicator.transform, M_PI);
                     }
                     completion: ^(BOOL finished) {

                         if (finished) {
                             counterHotel++;
                             if (counterHotel % 2 == 1 || !isHotelSet) {
                                 [self animateHotelIndicator];
                             }
                         }
                         
                     }];
}

- (void)animateUberIndicator {
    [UIView animateWithDuration: 1.0f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                         self.uberIndicator.transform = CGAffineTransformRotate(uberIndicator.transform, M_PI);
                     }
                     completion: ^(BOOL finished) {
        
                         if (finished) {
                             counterUber++;
                             if (counterUber % 2 == 1 || !isHotelSet) {
                                 [self animateUberIndicator];
                             }
                         }
                         
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didFinishSetDestination:(NSDictionary *)destination {
    if (destination != nil) {
        if ([[destination valueForKey:@"destCityImgUrl"] count] > 0) {
            NSString *imageUrl = [destination valueForKey:@"destCityImgUrl"][0];
            NSLog(@"%@", imageUrl);
            [flightImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]
             
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               
                                      [UIView transitionWithView:flightImage
                                                        duration:duration
                                                         options:UIViewAnimationOptionTransitionCrossDissolve
                                                      animations:^{
                                                          flightImage.alpha = 0.5;
                                                      } completion:nil];
                               
                                      [UIView transitionWithView:flightLabel
                                                        duration:duration
                                                         options:UIViewAnimationOptionTransitionCrossDissolve
                                                      animations:^{
                                                          flightLabel.text = @"Flight Confirmed";
                                                      } completion:nil];
                                      isFlightSet = YES;
                               
                                      [UIView transitionWithView:hotelLabel
                                                        duration:duration
                                                         options:UIViewAnimationOptionTransitionCrossDissolve
                                                      animations:^{
                                                          hotelLabel.alpha = 1.0;
                                                      } completion:nil];
                               
                                      [UIView transitionWithView:hotelIndicator
                                                        duration:duration
                                                         options:UIViewAnimationOptionTransitionCrossDissolve
                                                      animations:^{
                                                          hotelIndicator.alpha = 1.0;
                                                      } completion:nil];
                               
                                      counterHotel = 0;
                                      [self animateHotelIndicator];
                               
                                      [manager setHotel];
                                  }];
        }
    }
}

- (void)didFinishSetHotel:(NSDictionary *)hotel {
    if (hotel != nil) {
        NSString *imageUrl = [hotel valueForKey:@"hotel_photo"];
        NSLog(@"%@", imageUrl);
        [hotelImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  
                                 [UIView transitionWithView:hotelImage
                                                   duration:duration
                                                    options:UIViewAnimationOptionTransitionCrossDissolve
                                                 animations:^{
                                                     hotelImage.alpha = 0.5;
                                                 } completion:nil];
                                  
                                 [UIView transitionWithView:hotelLabel
                                                   duration:duration
                                                    options:UIViewAnimationOptionTransitionCrossDissolve
                                                 animations:^{
                                                     hotelLabel.text = @"Lodging Confirmed";
                                                 } completion:nil];
                                  
                                 isHotelSet = YES;
                                 
                                 [UIView transitionWithView:uberLabel
                                                   duration:duration
                                                    options:UIViewAnimationOptionTransitionCrossDissolve
                                                 animations:^{
                                                     uberLabel.alpha = 1.0;
                                                 } completion:nil];
                                 
                                 [UIView transitionWithView:uberIndicator
                                                   duration:duration
                                                    options:UIViewAnimationOptionTransitionCrossDissolve
                                                 animations:^{
                                                     uberIndicator.alpha = 1.0;
                                                 } completion:nil];
                                 
                                 counterUber = 0;
                                 [self animateUberIndicator];
                                 
                                 [manager setUber];
                             }];
    }
}

- (void)didFinishSetUberRequest:(NSDictionary *)uber {
    if (uber != nil) {
        
        uberEta = [[uber valueForKey:@"uber_estimate_sec"] integerValue];
        
        [self drawMap];
    }
}

- (void)didFinishSetPriceRequest:(int)price {
    
    if (price > 0) {
        
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:320.0f];
        alert.backgroundViewColor = [UIColor whiteColor];
        alert.customViewColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];

        [alert addButton:@"Confirm Payment" actionBlock:^(void) {
            NSLog(@"Confirmed");
            [self performSegueWithIdentifier:@"ToPlans" sender:self];
        }];
        
        [alert addButton:@"Cancel Trip" actionBlock:^(void) {
            NSLog(@"Canceled");
            [self performSegueWithIdentifier:@"ToStart" sender:self];
        }];
        
        [alert showSuccess:self title:@"Congradulations" subTitle:[NSString stringWithFormat:@"Your 72-hour trip has been confirmed, and a Uber shall be picking you up in %d minutes to take you to the airport.\n\nThe total cost for this trip would be $%d, including all taxes and fees.\n\nWould you like to proceed?", (int)((float)uberEta/(float)60.0), price] closeButtonTitle:nil duration:0.0f ];
    }
}

- (void)drawMap {
    
    uberMap.delegate = self;
    uberMap.zoomEnabled = NO;
    uberMap.scrollEnabled = NO;
    
    [uberMap setShowsUserLocation:YES];
    
    CLLocation *startPoint = [manager getCurrentLocation];
    NSDictionary *endPoint = [manager getOrigin];
    NSString *airportName = [endPoint valueForKey:@"name"];
    
    CLLocationCoordinate2D fromCoordinate = startPoint.coordinate;
    CLLocationCoordinate2D toCoordinate = CLLocationCoordinate2DMake([[endPoint valueForKey:@"lat"] floatValue], [[endPoint valueForKey:@"lng"] floatValue]);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:toCoordinate];
    [annotation setTitle:airportName];
    [uberMap addAnnotation:annotation];
    
    float latAvg = (toCoordinate.latitude + fromCoordinate.latitude) / 2;
    float lngAvg = (toCoordinate.longitude + fromCoordinate.longitude) / 2;
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latAvg, lngAvg);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
    uberMap.region = MKCoordinateRegionMake(centerCoordinate, span);

    
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromCoordinate
                                                       addressDictionary:nil];
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:toCoordinate
                                                       addressDictionary:nil];
    
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = fromItem;
    request.destination = toItem;
    request.requestsAlternateRoutes = YES;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
     {
         if (error) return;
         
         if ([response.routes count] > 0)
         {
             MKRoute *route = [response.routes objectAtIndex:0];
             NSLog(@"distance: %.2f meter", route.distance);
             
             [uberMap addOverlay:route.polyline];
         }
     }];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.lineWidth = 5.0;
        routeRenderer.strokeColor = [UIColor redColor];
        return routeRenderer;
    }
    else {
        return nil;
    }
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView
                       fullyRendered:(BOOL)fullyRendered {
    if (fullyRendered) {
        
        [UIView transitionWithView:uberMap
                          duration:duration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            uberMap.alpha = 0.5;
                        } completion:nil];
        
        [UIView transitionWithView:uberLabel
                          duration:duration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            uberLabel.text = @"Uber Pick-up Confirmed";
                        } completion:nil];
        
        isUberSet = YES;
        
        [manager setPrice];
        
    }
}

@end
