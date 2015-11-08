//
//  UberViewController.h
//  MobileApp
//
//  Created by 澤田　暖 on 2015/11/08.
//  Copyright © 2015年 JET Engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "TravelManager.h"
#import "SDWebImageDownloader.h"

@interface UberViewController : UIViewController <MKMapViewDelegate> {
    TravelManager *manager;
    long etaRemaining;
    NSTimer *timer;
}

@property (nonatomic, strong) IBOutlet UILabel *etaTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *etaLabel;
@property (nonatomic, strong) IBOutlet UILabel *travelTimeTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *travelTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *distanceTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *distanceLabel;

@property (nonatomic, strong) IBOutlet MKMapView *uberMap;
@end
