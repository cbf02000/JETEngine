//
//  WebViewController.h
//  MobileApp
//
//  Created by 澤田　暖 on 2015/11/08.
//  Copyright © 2015年 JET Engine. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TravelManager.h"

@interface WebViewController : UITabBarController <UIWebViewDelegate> {
    TravelManager *manager;
}

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end
