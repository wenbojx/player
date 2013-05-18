//
//  SettingController.m
//  PhotoTools
//
//  Created by yiluhao on 13-5-18.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import "SettingController.h"

@interface SettingController ()

@end

@implementation SettingController
@synthesize nameField, pwdField;

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
    
    UITableView *loginView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [loginView setAutoresizesSubviews:YES];
    [loginView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
    loginView.delegate = self;
    loginView.dataSource = self;
    loginView.scrollEnabled = NO;
    loginView.backgroundView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:loginView];
    
    nameField.delegate = self;
    pwdField.delegate = self;
    
	// Do any additional setup after loading the view.
}


// 登陆
- (void)doLogin
{
    NSString *name = self.nameField.text;
    NSString *pwd = self.pwdField.text;
    NSString *message = [[NSString alloc] init];
    if (name == nil) {
        message = @"账号不能为空";
    } else if (pwd == nil) {
        message = @"密码不能为空";
    } else {
        // 请求登陆
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

// 到注册页面
- (void)doRegister
{
    /*
    RegisterViewController *rv = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:rv animated:YES];
     */
}

#pragma mark -
#pragma mark Table Data Source Methods
// 返回两栏table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

// 第一栏返回2个cell，第二栏返回1个cell
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)  // 等于0，返回第一组，2行
        return 2;
    else
        return 1;  // 等于1，返回第二组，1行
}

// 设置tableview第二栏头文字内容
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //if (section == 1)
        //return @"忘记密码？请点击这里>";
    return nil;
}

// 设置tableview第二栏头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return 20;
    return 0;
}

// 设置登陆框
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"loginCell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    if (indexPath.section == 0) {  // 设置第一组的登陆框内容
        switch ([indexPath row]) {
            case 0:
                cell.textLabel.text = @"账号"; // 设置label的文字
                cell.selectionStyle = UITableViewCellSelectionStyleNone; // 设置不能点击
                self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(60, 12, 230, 30)];
                [self.nameField setBorderStyle:UITextBorderStyleNone]; //外框类型
                self.nameField.placeholder = @"请输入账号";
                self.nameField.clearButtonMode = YES; // 设置清楚按钮
                self.nameField.returnKeyType = UIReturnKeyNext;
                [cell.contentView addSubview:self.nameField];
                break;
            default:
                cell.textLabel.text = @"密码";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                self.pwdField = [[UITextField alloc] initWithFrame:CGRectMake(60, 12, 230, 30)];
                [self.pwdField setBorderStyle:UITextBorderStyleNone]; //外框类型
                self.pwdField.placeholder = @"请输入密码";
                self.pwdField.clearButtonMode = YES;
                self.pwdField.returnKeyType = UIReturnKeyDone;
                [cell.contentView addSubview:self.pwdField];
                break;
        }
    } else {  // 设置第二组注册框内容
        cell.textLabel.text = @"赶快去注册吧！";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // 设置向>箭头
    }
    return cell;
}

// 用户点击注册
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 用户点击tableview第二栏，第一行的时候
    if (indexPath.section == 1 && [indexPath row] == 0)
    {
        [self doRegister];
    }
}

// 设置cell背景为透明
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{ //当点触textField内部，开始编辑都会调用这个方法。textField将成为first responder
    NSLog(@"aaa");
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -=216;
    frame.size.height +=216;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{//当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    NSLog(@"bbb");

    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y +=216;
    frame.size. height -=216;
    self.view.frame = frame;
	//self.view移回原位置
	[UIView beginAnimations:@"ResizeView" context:nil];
 	[UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
