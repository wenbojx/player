//
//  LoginViewController.h
//  PanoPlayer
//
//  Created by yiluhao on 13-3-11.
//
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController{
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    IBOutlet UIView *loginView;
    UINavigationController *navLoginController;
    UINavigationController *navHomeController;
    UINavigationController *navInfoController;
    UINavigationController *navMapController;
    UINavigationController *navSetController;
    UITabBarController *tabBarController;
    NSString *projectID;
}

@property(nonatomic, assign) IBOutlet UITextField *username;
@property(nonatomic, assign) IBOutlet UITextField *password;
@property(nonatomic, assign) IBOutlet UIView *loginView;
- (IBAction) UserNameDoneEditing:(id)sender;
- (IBAction) PasswordDoneEditing:(id)sender;
- (IBAction) backgroundTap:(id)sender;

-(IBAction)login:(id)sender;
//@property(nonatomic, assign) IBAction *login;
@end
