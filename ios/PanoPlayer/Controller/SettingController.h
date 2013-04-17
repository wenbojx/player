//
//  SettingController.h
//  PanoPlayer
//
//  Created by yiluhao on 13-4-17.
//
//

#import <UIKit/UIKit.h>

@interface SettingController : UIViewController{
    NSString *username;
}

@property(assign, nonatomic) IBOutlet UITextField *usernameField;

-(IBAction)saveDatas:(id)sender;
- (IBAction) ProjectIdDoneEditing:(id)sender;


@end
