//
//  TravelManager.m
//  MobileApp
//
//  Created by 澤田　暖 on 2015/11/07.
//  Copyright © 2015年 JET Engine. All rights reserved.
//

#import "TravelManager.h"

@implementation TravelManager 

@synthesize origin;
@synthesize destination;
@synthesize uber;
@synthesize hotel;

+ (instancetype)sharedInstance {
    static TravelManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TravelManager alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    
    if (self = [super init]) {
        
        locationManager = [[CLLocationManager alloc] init];
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager requestAlwaysAuthorization];
        currentLocation = NULL;
        
        [locationManager startUpdatingLocation];
    }
    
    return self;
}

-(void)setDelegate:(id)targetInstance {
    delegate = targetInstance;
}

-(CLLocation *)getCurrentLocation {
    return currentLocation;
}

-(NSDictionary *)getOrigin {
    return origin;
}

-(NSDictionary *)getDestination {
    return destination;
}

-(NSDictionary *)getHotel {
    return hotel;
}

-(NSDictionary *)getUber {
    return uber;
}

-(int)getPrice{
    return price;
}

-(void)setOrigin {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/nearest_airport.cgi?lat=%f&lon=%f",
                           API_BASE_URL,
                           currentLocation.coordinate.latitude,
                           currentLocation.coordinate.longitude
                           ];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            origin = responseObject;
        } else {
            origin = NULL;
        }
        
        [delegate didFinishSetOrigin:origin];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)setDestination {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/flight.cgi?airport=%@",
                           API_BASE_URL,
                           [origin valueForKey:@"code"]
                           ];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            destination = responseObject;
        } else {
            destination = NULL;
        }
        
        [delegate didFinishSetDestination:destination];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)setHotel {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/hotel.cgi?airport=%@&arrival_time=%ld",
                           API_BASE_URL,
                           [destination valueForKey:@"destination"],
                           [[destination valueForKey:@"estimatedarrivaltime"] integerValue]
                           ];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            hotel = responseObject;
        } else {
            hotel = NULL;
        }
        
        [delegate didFinishSetHotel:hotel];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)setUber {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/uber.cgi?start_lat=%f&start_long=%f&dest_lat=%f&dest_long=%f",
                           API_BASE_URL,
                           currentLocation.coordinate.latitude,
                           currentLocation.coordinate.longitude,
                           [[origin valueForKey:@"lat"] floatValue],
                           [[origin valueForKey:@"lng"] floatValue]
                           ];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            uber = responseObject;
        } else {
            uber = NULL;
        }
        
        [delegate didFinishSetUberRequest:uber];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)setPrice {
    
    price = MIN_PRICE + arc4random() % (MAX_PRICE - MIN_PRICE);
    
    [self performSelector:@selector(callbackPrice)
               withObject:nil
               afterDelay:2];
    
}

-(void)callbackPrice {
    [delegate didFinishSetPriceRequest:price];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError: %@", error);
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    if (newLocation != nil) {
        [locationManager stopUpdatingLocation];
        locationManager = nil;
        currentLocation = newLocation;
        [self setOrigin];
    }
}


@end
