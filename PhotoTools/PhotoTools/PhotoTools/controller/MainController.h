//
//  MainController.h
//  PhotoTools
//
//  Created by yiluhao on 13-5-16.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "yiluhaoAppDelegate.h"
#import "MapController.h"
#import "SettingController.h"

@interface MainController : UIViewController{
    IBOutlet UIButton *btRecord;
    IBOutlet UIButton *btPause;
    IBOutlet UIButton *btStop;
    IBOutlet UIButton *btLocus;
    IBOutlet UIButton *btmap;
    IBOutlet UIButton *btSetting;
    yiluhaoAppDelegate *appDelegate;
    NSTimer *timer;
    
}

@property(retain, nonatomic) IBOutlet UIButton *btRecord;
@property(retain, nonatomic) IBOutlet UIButton *btPause;
@property(retain, nonatomic) IBOutlet UIButton *btStop;
@property(retain, nonatomic) IBOutlet UIButton *btLocus;
@property(retain, nonatomic) IBOutlet UIButton *btmap;
@property(retain, nonatomic) IBOutlet UIButton *btSetting;

-(IBAction)BtRecordClick:(id)sender;
-(IBAction)BtPauseClick:(id)sender;
-(IBAction)BtStopClick:(id)sender;
-(IBAction)BtLocusClick:(id)sender;
-(IBAction)BtMapClick:(id)sender;
-(IBAction)BtSettingClick:(id)sender;

@end
