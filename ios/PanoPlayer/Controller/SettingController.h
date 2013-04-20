//
//  SettingController.h
//  PanoPlayer
//
//  Created by yiluhao on 13-4-17.
//
//

#import <UIKit/UIKit.h>
#import "ProjectsViewController.h"
#import "JSONKit.h"

@interface SettingController : UIViewController{
    NSString *username;
    NSString *mid;
}

@property(assign, nonatomic) IBOutlet UITextField *usernameField;
@property(assign,nonatomic) IBOutlet UILabel *setSuccess;
@property(assign,nonatomic) IBOutlet UITextField *configCache;
@property(assign, nonatomic) IBOutlet UITextField *datasCache;
@property(assign, nonatomic) IBOutlet UISlider *playerRotate;
@property(assign, nonatomic) IBOutlet UILabel *playerRotateLable;

-(IBAction)saveDatas:(id)sender;
- (IBAction) ProjectIdDoneEditing:(id)sender;


@end
