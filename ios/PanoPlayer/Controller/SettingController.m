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
@synthesize usernameField;

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
    
    NSString *userName;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"userInfo.plist"];
    
    //读文件
    NSDictionary* userInfo = [NSDictionary dictionaryWithContentsOfFile:filename];
    //NSLog(@"dic is:%@",userInfo);
    if(userInfo == nil)
    {
        //1. 创建一个plist文件
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filename contents:nil attributes:nil];
    }
    else
    {
        userName = [userInfo objectForKey:@"userName"];
        usernameField.text = userName;
    }
}

- (void) getWrong:(NSString*)str{
    NSString *msg = [NSString stringWithFormat:@"%@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(NSString *)getUserInfo:(NSString *)username{
    
    NSString *projectListUrl = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/user/u/%@", username];
    
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

-(IBAction)saveDatas:(id)sender{
    username = usernameField.text;
    if (username == nil || [username isEqualToString:@""]) {
        [self getWrong:@"请输入用户名"];
        return;
    }
    NSString *responseStr = [self getUserInfo:username];
    NSLog(responseStr);
    if(responseStr == nil && [responseStr isEqualToString:@""]){
        [self getWrong:@"请输入用户名"];
        return;
    }
    NSDictionary *resultsDictionary = [responseStr objectFromJSONString];
    NSString *state = [resultsDictionary objectForKey:@"state"];
    if ([state isEqualToString:@"0"]) {
        [self getWrong:@"帐号不存在"];
        return;
    }
    NSString *mid = [resultsDictionary objectForKey:@"m_id"];
    if(mid == nil || [mid isEqualToString:@""] || [mid isEqualToString:@"0"]){
        [self getWrong:@"帐号信息错误"];
        return;
    }
    NSString *userName = [resultsDictionary objectForKey:@"userName"];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"userInfo.plist"];   //获取路径
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    //添加一项内容
    [data setObject:mid forKey:@"mid"];
    [data setObject:userName forKey:@"userName"];

    [data writeToFile:filename atomically:YES];
    //NSLog(@"data=%@", data);
    [self getWrong:@"数据保存成功"];
    
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
