//
//  AppDelegate.h
//  PanoPlayer
//
//  Created by 李文博 on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "InfoViewController.h"
#import "MapViewController.h"
#import "SettingViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController *navLoginController;
    UINavigationController *navHomeController;
    UINavigationController *navInfoController;
    UINavigationController *navMapController;
    UINavigationController *navSetController;
    UITabBarController *tabBarController;
    NSString *level;
}

@property (strong, nonatomic) UIWindow *window;
-(void)showTab;
@end
