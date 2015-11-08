//
//  UberViewController.m
//  MobileApp
//
//  Created by 澤田　暖 on 2015/11/08.
//  Copyright © 2015年 JET Engine. All rights reserved.
//

#import "UberViewController.h"

@interface UberViewController ()

@end

@implementation UberViewController

@synthesize etaLabel;
@synthesize travelTimeLabel;
@synthesize travelTimeTitleLabel;
@synthesize distanceLabel;
@synthesize distanceTitleLabel;
@synthesize uberMap;

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    
    manager = [TravelManager sharedInstance];
    
    NSDictionary *airportInfo = [manager getOrigin];
    NSDictionary *uberInfo = [manager getUber];
    
    long eta = [[uberInfo valueForKey:@"uber_estimate_sec"] integerValue];
    long travelTime = [[uberInfo valueForKey:@"travel_estimate_sec"] integerValue];
    NSLog(@"%ld %ld", eta, travelTime);
    NSString *airport = [airportInfo valueForKey:@"code"];
    
    etaRemaining = eta;
    
    etaLabel.text = [NSString stringWithFormat:@"%ld:%.2ld", etaRemaining/60, etaRemaining%60];
    travelTimeTitleLabel.text = [NSString stringWithFormat:@"Travel Time to %@", airport];
    distanceTitleLabel.text = [NSString stringWithFormat:@"Distance to %@", airport];
    travelTimeLabel.text = [NSString stringWithFormat:@"%ld Minutes", travelTime/60];

    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
    
    [self drawMap];
}

-(void)timerCallback {
    if (etaRemaining < 0) {
        [timer invalidate];
        etaLabel.text = [NSString stringWithFormat:@"0:00"];
    } else {
        etaLabel.text = [NSString stringWithFormat:@"%ld:%.2ld", etaRemaining/60, etaRemaining%60];
        etaRemaining--;
    }

}

- (void)drawMap {
    
    uberMap.delegate = self;
    
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
             distanceLabel.text = [NSString stringWithFormat:@"%.1f km", (float)route.distance/1000.0];
             
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
