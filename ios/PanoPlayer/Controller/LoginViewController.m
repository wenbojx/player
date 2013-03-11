//
//  LoginViewController.m
//  PanoPlayer
//
//  Created by yiluhao on 13-3-11.
//
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "InfoViewController.h"
#import "MapViewController.h"
#import "SettingViewController.h"
#import "TabBarViewController.h"
#import "ASIHTTPRequest.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize username;
@synthesize password;
@synthesize loginView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) getWrong:(NSString*)str{
    NSString *msg = [NSString stringWithFormat:@"%@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    loginView = [[UIView alloc] init];
    [self writeInfo];
	// Do any additional setup after loading the view.
}
-(NSString *)getProjectInfo:(NSString *) usernameStr{
    if (usernameStr == nil || [usernameStr isEqualToString:@""]) {
        [self getWrong:@"请输入用户名"];
    }
    NSString *projectListUrl = [NSString stringWithFormat:@"http://www.yiluhao.com/ajax/m/pp/id/%@", usernameStr];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:projectListUrl]];
    
    [request startSynchronous];
    NSString *responseData = nil;
    NSError *error = [request error];
    if (!error) {
        responseData = [request responseString];
        //NSLog(@"response%@", responseData);
    }
    else {
        [self getWrong:@"获取数据失败,请检查您的网络设置"];
    }
    NSLog(@"sdfsdf%@", responseData);
    
    return responseData;
}

-(void)writeInfo{
    if(projectID == nil || [projectID isEqualToString:@"0"]){
        return;
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"project_list" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@", data);
    
    //添加一项内容
    [data setObject:projectID forKey:@"projectID"];
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"project_list.plist"];
    //输入写入
    //[data writeToFile:filename atomically:YES];

}

- (IBAction) UserNameDoneEditing:(id)sender{
    [sender resignFirstResponder];
}
- (IBAction) PasswordDoneEditing:(id)sender{
    [sender resignFirstResponder];
}
- (IBAction) backgroundTap:(id)sender{
    [username resignFirstResponder];
    [password resignFirstResponder];
}
-(IBAction)login:(id)sender{
    
    NSString *usernameStr = username.text;
    projectID = [self getProjectInfo:usernameStr];
    if (projectID) {
        //[self displayTab];
    }
    else{
        
    }

}
-(void)displayTab{
    navLoginController = [[UINavigationController alloc] init];
    navHomeController = [[UINavigationController alloc] init];
    navInfoController = [[UINavigationController alloc] init];
    navMapController = [[UINavigationController alloc] init];
    navSetController = [[UINavigationController alloc] init];
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
    
    SettingViewController *setViewController = [[SettingViewController alloc] init];
    setViewController.title = @"设置";
    setViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"地图" image:[UIImage imageNamed:@"icon_pano_map.png"] tag:0];
    
    [navHomeController pushViewController:homeViewController animated:YES];
    [navInfoController pushViewController:infoViewController animated:(YES)];
    [navMapController pushViewController:mapViewController animated:YES];
    [navSetController pushViewController:setViewController animated:YES];
    
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects: navHomeController, navInfoController, navMapController, navSetController, nil];
    [self presentViewController:tabBarController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"dsfsdfsdfsdfsdf");
    return YES;
}

@end
