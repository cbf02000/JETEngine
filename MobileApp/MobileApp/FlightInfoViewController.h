//
//  FlightInfoViewController.h
//  MobileApp
//
//  Created by 澤田　暖 on 2015/11/08.
//  Copyright © 2015年 JET Engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "TravelManager.h"
#import "JBKenBurnsView.h"
#import "SDWebImageDownloader.h"

@interface FlightInfoViewController : UIViewController <MKMapViewDelegate> {
    TravelManager *manager;
}

@property (nonatomic, strong) NSMutableArray *backgroundImages;

@property (nonatomic, strong) IBOutlet UILabel *flightNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *originLabel;
@property (nonatomic, strong) IBOutlet UILabel *destinationLabel;
@property (nonatomic, strong) IBOutlet UILabel *departureTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *arrivalTimeLabel;

@property (nonatomic, strong) IBOutlet JBKenBurnsView *background;
@property (nonatomic, strong) IBOutlet MKMapView *cityMap;

@end
