//
//  TravelManager.h
//  MobileApp
//
//  Created by 澤田　暖 on 2015/11/07.
//  Copyright © 2015年 JET Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "AFHTTPRequestOperationManager.h"

#define API_BASE_URL @"http://52.8.75.87:8888"
#define MAX_PRICE 700
#define MIN_PRICE 450

@interface TravelManager : NSObject <CLLocationManagerDelegate> {
    id delegate;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    int price;
}

@property (nonatomic, strong) NSMutableDictionary *origin;
@property (nonatomic, strong) NSMutableDictionary *destination;
@property (nonatomic, strong) NSMutableDictionary *hotel;
@property (nonatomic, strong) NSMutableDictionary *uber;

+(TravelManager *)sharedInstance;

-(id)init;
-(void)setDelegate:(id)targetInstance;
-(NSDictionary *)getOrigin;
-(NSDictionary *)getDestination;
-(NSDictionary *)getHotel;
-(NSDictionary *)getUber;
-(int) getPrice;
-(CLLocation *)getCurrentLocation;

-(void)setDestination;
-(void)setHotel;
-(void)setUber;
-(void)setPrice;
    
@end

@protocol TravelManagerReceiveOriginDelegate <NSObject>
@required
- (void)didFinishSetOrigin:(NSDictionary *)origin;
@end

@protocol TravelManagerReceiveDestinationDelegate <NSObject>
@required
- (void)didFinishSetDestination:(NSDictionary *)destination;
- (void)didFinishSetHotel:(NSDictionary *)hotel;
- (void)didFinishSetUberRequest:(NSDictionary *)uber;
- (void)didFinishSetPriceRequest:(int)price;
@end
