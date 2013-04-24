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
#import "ConfigDataSource.h"
#import "ClearCache.h"

@interface SettingController : UIViewController{
    NSTimer *timer;
    ClearCache *clearCache;
    ConfigDataSource *configDatas;
    NSString *username;
    NSString *mid;
    IBOutlet UISwitch *playeRsensorial;
}

@property(assign, nonatomic) IBOutlet UITextField *usernameField;
@property(assign,nonatomic) IBOutlet UILabel *setSuccess;
@property(assign,nonatomic) IBOutlet UITextField *configCache;
@property(assign, nonatomic) IBOutlet UITextField *datasCache;
@property(assign, nonatomic) IBOutlet UISlider *playerRotate;
@property(assign, nonatomic) IBOutlet UILabel *playerRotateLable;
@property(assign, nonatomic) IBOutlet UISwitch *playeRsensorial;
@property(assign, nonatomic) IBOutlet UILabel *clearFinish;
@property(assign, nonatomic) IBOutlet UIActivityIndicatorView *clearIng;

-(IBAction)clearCache:(id)sender;
-(IBAction)saveDatas:(id)sender;
- (IBAction) ProjectIdDoneEditing:(id)sender;


@end
