//
//  HotelViewController.h
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

@interface HotelViewController : UIViewController <MKMapViewDelegate> {
    TravelManager *manager;
}

@property (nonatomic, strong) NSMutableArray *backgroundImages;

@property (nonatomic, strong) IBOutlet UILabel *hotelNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *checkInLabel;
@property (nonatomic, strong) IBOutlet UILabel *checkOutLabel;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;

@property (nonatomic, strong) IBOutlet JBKenBurnsView *background;
@property (nonatomic, strong) IBOutlet MKMapView *hotelMap;

@end
