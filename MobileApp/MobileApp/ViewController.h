//
//  ViewController.h
//  MobileApp
//
//  Created by 澤田　暖 on 2015/11/07.
//  Copyright © 2015年 JET Engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "TravelManager.h"
#import "JBKenBurnsView.h"
#import "MBProgressHUD.h"
#import "SDWebImageDownloader.h"

@interface ViewController : UIViewController <TravelManagerReceiveOriginDelegate> {
    TravelManager *manager;
    NSTimeInterval duration;
}

@property (nonatomic, strong) NSMutableArray *backgroundImages;

@property (nonatomic, strong) IBOutlet JBKenBurnsView *background;

@property (nonatomic, strong) IBOutlet UILabel *originTitle;
@property (nonatomic, strong) IBOutlet UILabel *originLabel;

@property (nonatomic, strong) IBOutlet UIButton *startSearchButton;

@end

