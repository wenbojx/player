//
//  SettingController.h
//  PhotoTools
//
//  Created by yiluhao on 13-5-18.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingController: UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITableView *tableView;
}
@property (retain, nonatomic) UITextField *nameField;
@property (retain, nonatomic) UITextField *pwdField;

@end
