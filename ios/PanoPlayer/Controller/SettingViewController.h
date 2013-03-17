//
//  SettingViewController.h
//  PanoPlayer
//
//  Created by yiluhao on 13-3-11.
//
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController{
    IBOutlet NSString *project_id;

}

@property(assign, nonatomic) IBOutlet NSString *project_id;

-(IBAction)resetProjectID:(id)sender;

@end
