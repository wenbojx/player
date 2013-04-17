//
//  ProjectsViewController.h
//  PanoPlayer
//
//  Created by yiluhao on 13-4-17.
//
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "InfoViewController.h"
#import "MapViewController.h"
#import "SettingController.h"

@interface ProjectsViewController : UIViewController{
    UINavigationController *navLoginController;
    UINavigationController *navHomeController;
    UINavigationController *navInfoController;
    UINavigationController *navMapController;
    UINavigationController *navSetController;
    UITabBarController *tabBarController;
}

-(void) settingConfig;
-(IBAction)settingConfig:(id)pressed;

@end
