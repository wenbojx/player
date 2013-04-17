//
//  SettingViewController.h
//  PanoPlayer
//
//  Created by yiluhao on 13-3-11.
//
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController{
    IBOutlet UITextField *projectIdText;

    //NSString *project_id;

}

@property(assign, nonatomic) IBOutlet UITextField *projectIdText;

//-(IBAction)resetProjectID:(id)sender;
//-(IBAction) ProjectIdDoneEditing:(id)sender;

@end
