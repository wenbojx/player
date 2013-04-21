//
//  SettingController.m
//  PanoPlayer
//
//  Created by yiluhao on 13-4-17.
//
//

#import "SettingController.h"
#import "ASIHTTPRequest.h"

@interface SettingController ()

@end

@implementation SettingController
@synthesize usernameField, configCache, datasCache, playerRotate, playerRotateLable;
@synthesize setSuccess;
@synthesize playeRsensorial;
@synthesize clearFinish, clearIng;


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
    configDatas = [[ConfigDataSource alloc] init];
    
    username = [configDatas getUsername];
    //mid = [userInfo objectForKey:@"mid"];
    usernameField.text = username;
    configCache.text = [NSString stringWithFormat:@"%d", [configDatas getConfigCache]];
    datasCache.text = [NSString stringWithFormat:@"%d",[configDatas getDatasCache]];
    playerRotate.value = [configDatas getPlayerRotate];
    playerRotateLable.text = [NSString stringWithFormat:@"%d",[configDatas getPlayerRotate]];;
    Boolean rsensorial= [configDatas getPlayeRsensoria];
    [playeRsensorial setOn:rsensorial];
    
    [playerRotate addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //滑块拖动后的事件
    [playerRotate addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)sliderValueChanged:(id)sender{
    int rotateValue = playerRotate.value;
    playerRotateLable.text = [NSString stringWithFormat:@"%d",rotateValue];
    //NSLog(@"adfsadfs");
}

-(NSDictionary *)getUserInfo{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"userInfo.plist"];
    
    //读文件
    NSDictionary* userInfo = [NSDictionary dictionaryWithContentsOfFile:filename];
    if(userInfo == nil){
        //1. 创建一个plist文件
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filename contents:nil attributes:nil];
    }
    
    return userInfo;
}

- (void) getWrong:(NSString*)str{
    NSString *msg = [NSString stringWithFormat:@"%@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
    [alert show];
    [alert release];
}

-(NSString *)getUserInfo:(NSString *)usernames{
    
    NSString *projectListUrl = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/user/u/%@", usernames];
    
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
    
    return responseData;
}

-(IBAction)saveDatas:(id)sender{
    
    mid = [NSString stringWithFormat:@"%d",[configDatas getMid]];
    username = [configDatas getUsername];
    
    NSString *usernameIn = usernameField.text;
    //NSLog(@"in=%@, u=%@", usernameIn, username);
    if ([usernameIn isEqualToString:username]) {
    }
    else{
        if (usernameIn == nil || [usernameIn isEqualToString:@""]) {
            [self getWrong:@"请输入用户名"];
            //return;
        }
        else{
            NSString *responseStr = [self getUserInfo:usernameIn];
            if(responseStr == nil && [responseStr isEqualToString:@""]){
                [self getWrong:@"帐号信息错误"];
            }
            else{
                NSDictionary *resultsDictionary = [responseStr objectFromJSONString];
                NSString *state = [resultsDictionary objectForKey:@"state"];
                NSString *midGet = [resultsDictionary objectForKey:@"m_id"];
                if ([state isEqualToString:@"0"] || midGet == nil || [midGet isEqualToString:@""] || [midGet isEqualToString:@"0"]) {
                    [self getWrong:@"帐号不存在"];
                }
                else{
                    mid = midGet;
                    username = usernameIn;
                }
            }
        }
    }

    //NSLog(@"in=%@, u=%@, mid=%@", usernameIn, username, mid);
    
    NSString *configCacheValue = configCache.text;
    if ([configCacheValue isEqualToString:@""]) {
        configCacheValue = @"90";
    }
    NSString *datasCacheValue = datasCache.text;
    if([datasCacheValue isEqualToString:@""]){
        datasCacheValue = @"360";
    }
    NSInteger rotateValue = playerRotate.value;
    if (rotateValue == 0) {
        rotateValue = 150;
    }
    NSString *playerRotateValue = [[NSString alloc] initWithFormat:@"%d",rotateValue];
    
    Boolean rsensorialValue = playeRsensorial.on;
    NSString *playeRsensorialValue = @"0";
    if (rsensorialValue) {
        playeRsensorialValue = @"1";
    }
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"userInfo.plist"];   //获取路径
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    //添加一项内容
    if (username!=nil && mid!=nil) {
        [data setObject:mid forKey:@"mid"];
        [data setObject:username forKey:@"userName"];
    }
    
    //NSLog(@"rsensor%@", playeRsensorialValue);
    [data setObject:configCacheValue forKey:@"configCacheValue"];
    [data setObject:datasCacheValue forKey:@"datasCacheValue"];
    [data setObject:playerRotateValue forKey:@"playerRotateValue"];
    [data setObject:playeRsensorialValue forKey:@"playeRsensorialValue"];

    [data writeToFile:filename atomically:YES];
    NSLog(@"data=%@", data);
    
    setSuccess.hidden = NO;
    [self delayJump];
    
    //[timer invalidate];
}
-(void)delayJump{
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(setSuccessJump) userInfo:nil repeats:NO];
}
-(void)setSuccessJump{
    ProjectsViewController *projectView = [[ProjectsViewController alloc] init];
    projectView.navigationItem.hidesBackButton = YES;
    
    projectView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:projectView animated:YES];
}

-(IBAction)clearCache:(id)sender{
    clearIng.hidden = NO;
    [clearIng startAnimating];
    clearCache = [[ClearCache alloc] init];
    [clearCache cleanConfigCache];
    [clearIng stopAnimating];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(delayClear) userInfo:nil repeats:NO];
}
-(void)delayClear{
    clearIng.hidden = YES;
    clearFinish.hidden = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(delayJump) userInfo:nil repeats:NO];
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
