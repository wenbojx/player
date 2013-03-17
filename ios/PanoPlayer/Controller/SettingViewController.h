//
//  SettingViewController.h
//  PanoPlayer
//
//  Created by yiluhao on 13-3-11.
//
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "InfoViewController.h"
#import "MapViewController.h"
#import "SettingViewController.h"

@interface SettingViewController : UIViewController{
    IBOutlet UITextField *projectIdText;
    UINavigationController *navLoginController;
    UINavigationController *navHomeController;
    UINavigationController *navInfoController;
    UINavigationController *navMapController;
    UINavigationController *navSetController;
    UITabBarController *tabBarController;
    NSString *level;
    NSString *project_id;

}

@property(assign, nonatomic) IBOutlet UITextField *projectIdText;

-(IBAction)resetProjectID:(id)sender;
- (IBAction) ProjectIdDoneEditing:(id)sender;


@end
