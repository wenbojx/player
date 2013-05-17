//
//  MainController.m
//  PhotoTools
//
//  Created by yiluhao on 13-5-16.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import "MainController.h"

@interface MainController ()

@end

@implementation MainController

@synthesize btRecord;
@synthesize btPause;
@synthesize btStop;
@synthesize btLocus;
@synthesize btmap;
@synthesize btSetting;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        appDelegate=[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//每隔一秒刷新一次数据
-(void)ReflashUiDatas{
    timer=[NSTimer scheduledTimerWithTimeInterval:1
                                           target:self
                                         selector:@selector(DoFlash)
                                         userInfo:nil
                                          repeats:YES];
}
-(void)DoFlash{
    double lat = appDelegate.m_lat;
    double lng = appDelegate.m_lon;
    //NSLog(@"lat=%f, lng=%f", lat, lng);
}
//按钮点击事件
-(IBAction)BtRecordClick:(id)sender{
    [appDelegate startLocationServices];
    appDelegate.btRecordClick = true;
    appDelegate.btPauseClick = false;
    appDelegate.btStopClick = false;
    [self ReflashUiDatas];
}
-(IBAction)BtPauseClick:(id)sender{
    [timer invalidate];
    appDelegate.btPauseClick = true;
    appDelegate.btRecordClick = false;
    [appDelegate stopLocationServices];
}
-(IBAction)BtStopClick:(id)sender{
    [timer invalidate];
    appDelegate.btRecordClick = false;
    appDelegate.btStopClick = true;
    [appDelegate stopLocationServices];
}
-(IBAction)BtLocusClick:(id)sender{
    
}

-(IBAction)BtMapClick:(id)sender{
    [self JumpToMap];
}

-(IBAction)BtSettingClick:(id)sender{
    
}


-(void)JumpToMap{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    MapController *mapView = [[MapController alloc] init];
    
    mapView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapView animated:YES];
    
    NSMutableDictionary * project = [[NSMutableDictionary alloc] init];
    [project setValue:@"a" forKey:@"projectId"];
    
    //发送消息.@"pass"匹配通知名，object:nil 通知类的范围
    [[NSNotificationCenter defaultCenter] postNotificationName:@"projectId" object:nil userInfo:project];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
