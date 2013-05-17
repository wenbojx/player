//
//  yiluhaoAppDelegate.m
//  PhotoTools
//
//  Created by yiluhao on 13-5-16.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import "yiluhaoAppDelegate.h"
#import "MainController.h"

@implementation yiluhaoAppDelegate

@synthesize m_locationmanager;
@synthesize m_lat;
@synthesize m_lon;
@synthesize btRecordClick;
@synthesize btPauseClick;
@synthesize btStopClick;
@synthesize inBackground;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UINavigationController *navMainController = [[UINavigationController alloc] init];
    
    MainController *mainController = [[MainController alloc] init];
    mainController.title = @"相机助手";
    [navMainController pushViewController:mainController animated:YES];
    
    self.window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = navMainController;
    
    UIDevice* device = [UIDevice currentDevice];
	BOOL backgroundSupported = NO;
	if ([device respondsToSelector:@selector(isMultitaskingSupported)])
		backgroundSupported = device.multitaskingSupported;
    
    //NSLog(@"backgroundSupported[%@]",backgroundSupported ? @"YES" : @"NO");
    
    m_locationmanager = [[CLLocationManager alloc] init];
    m_locationmanager.delegate = self;

    self.btRecordClick = false;
    self.btPauseClick = false;
    self.btStopClick = false;
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)StartBgTask{
    if (!self.btRecordClick) {
        return;
    }
    //[self stopLocationServices];
    
    UIBackgroundTaskIdentifier __block bgTask;
    
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you.
        // stopped or ending the task outright.
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self startLocationServices];
         
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });

}

- (void)startLocationServices{
    if (self.btRecordClick) {
        return;
    }
    if (!self.btPauseClick) {
        gpsDatas = [[GpsDatas alloc]init];
    }
    
    speedTime = 0;//速度计数
    currentSpeed = 0; 
    [self.m_locationmanager startUpdatingLocation];
    
    NSLog(@"startLocationServices");
}

- (void)stopLocationServices{
    [self.m_locationmanager stopUpdatingLocation];
    NSLog(@"timer stop location service here");
    //NSLog(@"stop=%f",[UIApplication sharedApplication].backgroundTimeRemaining);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	double lat = newLocation.coordinate.latitude;
	double lon = newLocation.coordinate.longitude;
    float alti = newLocation.altitude;
    //float speed = newLocation.speed;
    //NSDate *time = newLocation.timestamp;
    float degree = newLocation.course;
    
    [self countSpeed:lat lng:lon];
    
    [gpsDatas SaveDatas:lat lng:lon alti:alti speed:currentSpeed degree:degree];
    
    m_lat = lat;
    m_lon = lon;
    /*
    if (self.isReacording) {
        NSLog(@"lat = %f,lon = %f",lat,lon);
    }
    else{
        NSLog(@"lats = %f,lons = %f",lat,lon);
    }
	*/
}
//计算近n秒钟内的速度
-(void)countSpeed:(double)lat lng:(double)lng{
    //lat = lat+speedTime/10; //测试用代码
    //NSLog(@"lat=%f", (float)speedTime/10);

    int secend = 5; //统计5秒内速度

    if ( speedTime==secend && lat !=0) {
        speedTime = 1;
        
        CLLocation *orig = [[CLLocation alloc] initWithLatitude:lastLat  longitude:lastLng];
        //NSLog(@"lat=%f lng=%f", lat, lng);
        //NSLog(@"lastlat=%f lastlng=%f", lastLat, lastLng);
        
        lastLat = lat;
        lastLng = lng;
        
        CLLocation* dist=[[CLLocation alloc] initWithLatitude:lat longitude:lng];
        
        CLLocationDistance meters=[orig distanceFromLocation:dist];

        //NSLog(@"距离:%f",meters);
        currentSpeed = meters/secend;
        //NSLog(@"速度:%f",currentSpeed);
    }
    if (speedTime == 0 ) {
        currentSpeed = 0.f;
    }
    speedTime++;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)err
{
    NSLog(@"location error : %@",err);
}

-(CLLocationDistance)getLocationDistence{
    CLLocationDistance distance;
    CLLocation *locstart = [[CLLocation alloc]initWithLatitude:m_lat longitude:m_lon];
    //    CLLocation *locend = [[CLLocation alloc]init];
    CLLocation *locend = [[CLLocation alloc]initWithLatitude:29.610000 longitude:106.500000];
    distance = [locstart distanceFromLocation:locend];
    return distance;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //NSLog(@"applicationWillResignActive");
}

//进入后台继续记录
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self StartBgTask];
    //NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
//NSLog(@"applicationDidBecomeActive");
    //if (isReacording) {
        //[self saveDatas];
    //}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //NSLog(@"applicationWillTerminate");
}

@end
