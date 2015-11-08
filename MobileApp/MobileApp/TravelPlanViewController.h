//
//  TravelPlanViewController.h
//  MobileApp
//
//  Created by 澤田　暖 on 2015/11/07.
//  Copyright © 2015年 JET Engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "TravelManager.h"
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"
#import "SCLAlertView.h"

@interface TravelPlanViewController : UIViewController <TravelManagerReceiveDestinationDelegate, MKMapViewDelegate> {
    TravelManager *manager;
    BOOL isFlightSet;
    BOOL isHotelSet;
    BOOL isUberSet;
    NSTimeInterval duration;
    long uberEta;
    int tripPrice;
    int counterFlight;
    int counterHotel;
    int counterUber;
}

@property (nonatomic, strong) IBOutlet UILabel *flightLabel;
@property (nonatomic, strong) IBOutlet UILabel *hotelLabel;
@property (nonatomic, strong) IBOutlet UILabel *uberLabel;

@property (nonatomic, strong) IBOutlet UIImageView *flightImage;
@property (nonatomic, strong) IBOutlet UIImageView *hotelImage;
@property (nonatomic, strong) IBOutlet MKMapView *uberMap;

@property (nonatomic, strong) IBOutlet UIImageView *flightIndicator;
@property (nonatomic, strong) IBOutlet UIImageView *hotelIndicator;
@property (nonatomic, strong) IBOutlet UIImageView *uberIndicator;

@end
