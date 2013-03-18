//
//  SettingViewController.m
//  PanoPlayer
//
//  Created by yiluhao on 13-3-11.
//
//

#import "SettingViewController.h"
#import "ASIHTTPRequest.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize projectIdText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //projectIdText = [[UITextField alloc] init];
    level = @"0";
    project_id = @"1003";
    projectIdText.text = project_id;
}


-(IBAction)resetProjectID:(id)sender{
    project_id = projectIdText.text;
    
    if (project_id == nil || [project_id isEqualToString:@""]) {
        [self getWrong:@"请输入项目ID"];
    }
    else{
        NSString *content = [self getProjectInfo];
        if(content == nil || [content isEqualToString:@""]){
            
        }
        else{
            NSDictionary *resultsDictionary = [content objectFromJSONString];
            level = [resultsDictionary objectForKey:@"level"];
            //NSString *project_id = [resultsDictionary objectForKey:@"project_id"];
            [self writeInfo];
            [self showTab];
        }
    }
}

-(NSString *)getProjectInfo{

    NSString *projectListUrl = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/pl/id/%@", project_id];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:projectListUrl]];
    
    [request startSynchronous];
    NSString *responseData = nil;
    NSError *error = [request error];
    if (!error) {
        responseData = [request responseString];
    }
    else {
        [self getWrong:@"获取数据失败,请检查您的网络设置"];
    }
    //NSLog(@"response%@", responseData);
    
    return responseData;
}

-(void)writeInfo{
    if(project_id == nil || [project_id isEqualToString:@"0"] || [project_id isEqualToString:@""]){
        return;
    }
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"project_list" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    //level = @"2";
    //添加一项内容
    [data setObject:project_id forKey:@"project_id"];
    [data setObject:level forKey:@"level"];
    NSLog(@"levle=%@ project_id=%@", level, project_id);
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"project_list.plist"];
    //输入写入
    [data writeToFile:filename atomically:YES];
    
}
- (void) getWrong:(NSString*)str{
    NSString *msg = [NSString stringWithFormat:@"%@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(void)showTab{
    
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
    setViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"icon_pano_set.png"] tag:0];
    
    [navHomeController pushViewController:homeViewController animated:NO];
    [navInfoController pushViewController:infoViewController animated:(NO)];
    [navMapController pushViewController:mapViewController animated:NO];
    if ([level isEqualToString:@"0"]) {
        [navSetController pushViewController:setViewController animated:NO];
        tabBarController.viewControllers = [[NSArray alloc] initWithObjects:navHomeController, navInfoController, navMapController, navSetController, nil];
    }
    else{
        tabBarController.viewControllers = [[NSArray alloc] initWithObjects:navHomeController, navInfoController, navMapController, nil];
    }
    

    [self presentViewController:tabBarController animated:YES completion:nil];
    
}
- (IBAction) ProjectIdDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
