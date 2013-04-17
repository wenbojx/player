//
//  ProjectsViewController.m
//  PanoPlayer
//
//  Created by yiluhao on 13-4-17.
//
//

#import "ProjectsViewController.h"

@interface ProjectsViewController ()

@end

@implementation ProjectsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)showTab{
    
    navHomeController = [[UINavigationController alloc] init];
    navInfoController = [[UINavigationController alloc] init];
    navMapController = [[UINavigationController alloc] init];
    navSetController = [[UINavigationController alloc] init];
    tabBarController = [[UITabBarController alloc] init];
    
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    homeViewController.title = @"全景视界";
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
    
    [self presentViewController:tabBarController animated:YES completion:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UIBarButtonItem *rightItemBar = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingConfig:)];
    self.navigationItem.rightBarButtonItem = rightItemBar;
    
}

-(IBAction)settingConfig:(id)sender{
    [self.view removeFromSuperview];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;	// Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    
    SettingController *settingView = [[SettingController alloc] init];
    settingView.title = @"设置";
    [self.navigationController pushViewController:settingView animated:(YES)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
