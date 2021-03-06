//
//  AppDelegate.m
//  PanoPlayer
//
//  Created by 李文博 on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "InfoViewController.h"
#import "MapViewController.h"


@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]autorelease];
    //[[NSBundle mainBundle] loadNibNamed:@"TabBarController" owner:self options:nil];
    //window.rootViewController = viewController;
    
    //create nagtive and tabbar
    navHomeController = [[UINavigationController alloc] init];
    navInfoController = [[UINavigationController alloc] init];
    navMapController = [[UINavigationController alloc] init];
    tabBarController = [[UITabBarController alloc] init];
    
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    homeViewController.title = @"西湖秋景";
    homeViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"icon_pano_home.png"] tag:0];
    
    InfoViewController *infoViewController = [[InfoViewController alloc] init];
    infoViewController.title = @"简介";
    infoViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"简介" image:[UIImage imageNamed:@"icon_pano_about.png"] tag:0];
    
    MapViewController *mapViewController = [[MapViewController alloc] init];
    
    mapViewController.title = @"地图";
    mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"地图" image:[UIImage imageNamed:@"icon_pano_map.png"] tag:0];
    
    [navHomeController pushViewController:homeViewController animated:NO];
    [navInfoController pushViewController:infoViewController animated:(NO)];
    [navMapController pushViewController:mapViewController animated:NO];
    
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:navHomeController, navInfoController, navMapController, nil];
    //self.window.rootViewController = ;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    //[self.window addSubview:tabBarController.view];
    _window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
