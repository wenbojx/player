//
//  yiluhaoAppDelegate.h
//  PhotoTools
//
//  Created by yiluhao on 13-5-16.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface yiluhaoAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CLLocationManager *m_locationmanager;

@property (nonatomic)double m_lat;
@property (nonatomic)double m_lon;

@property (nonatomic)Boolean btRecordClick;
@property (nonatomic)Boolean btPauseClick;
@property (nonatomic)Boolean btStopClick;

@property (nonatomic)BOOL inBackground;

- (void)startLocationServices;
- (void)stopLocationServices;

@end
