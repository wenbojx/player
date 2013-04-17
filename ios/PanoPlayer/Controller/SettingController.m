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
}

- (void) getWrong:(NSString*)str{
    NSString *msg = [NSString stringWithFormat:@"%@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

-(NSString *)getUserInfo:(NSString *)username{
    
    NSString *projectListUrl = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/pl/id/%@", username];
    
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
    }
    else{
        NSString *userInfo = [self getUserInfo:username];
    }
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
