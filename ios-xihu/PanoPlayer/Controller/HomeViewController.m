//
//  HomeViewController.m
//  PanoPlayer
//
//  Created by 李文博 on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableCell.h"
#import "PlayerViewController.h"
#import "JSONKit.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize panoList;
@synthesize panoListUrl;
@synthesize reflashButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    panoId = 1001;
    panoListUrl = [NSString stringWithFormat:@"http://beta1.yiluhao.com/ajax/m/pl/id/%d", panoId];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"首页", @"首页");
        self.tabBarItem.image = [UIImage imageNamed:@"home"];
    }
    return self;
}


//返回UITableView共几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [panoList count];
}

//UITableView行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//和ChatViewCell.xib中的设置一致，这样才会完全重合
	return 85.0;
}

//该方法在UITableView显示一行时自动被调用
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.reflashButton.hidden = YES;
	//必须和在ChatViewCell.xib中的设置一致（也可以不一致，但UITableViewCell的重用机制将无效）
	static NSString * cellIdentifier = @"CellIdentifier";
	
	//该方法第一次调用时返回nil(因为程序刚开始运行时并没有可以重用的UITableViewCell)
	HomeTableCell * cell = (HomeTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		//加载ChatViewCell.xib
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"HomeTableCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
		//选中时呈蓝色高亮
		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
		//[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	}
	
	NSUInteger row = [indexPath row];
	NSMutableDictionary * pano = [panoList objectAtIndex:row];
    NSString *path = [pano objectForKey:@"thumbImage"];
    //NSLog(@"path=%@", path);
    //[cell.thumbImage setImage:[UIImage imageNamed:[pano objectForKey:@"thumbImage"]]];
    [cell.thumbImage setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading.gif"]];
    //NSLog(@"bbbb=%@", [pano objectForKey:@"thumbImage"]);
    cell.panoTitle.text = [pano objectForKey:@"panoTitle"];
	cell.photoTime.text = [pano objectForKey:@"photoTime"];
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"aaaaaaaaaaa");
    NSDictionary *panoInfo = [panoList objectAtIndex:indexPath.row];
    NSString *panoId = [panoInfo objectForKey:@"panoId"];
    //NSString *panoTitle = [panoInfo objectForKey:@"panoTitle"];
    //NSLog(@"idddd=%@", panoId);
    
    PlayerViewController *playerView = [[PlayerViewController alloc] init];
    
    playerView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playerView animated:YES];
    
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:panoId,@"panoId", nil];
    //NSDictionary
    
    //发送消息.@"pass"匹配通知名，object:nil 通知类的范围
    [[NSNotificationCenter defaultCenter] postNotificationName:@"panoId" object:nil userInfo:dic];
    
    //playerView.title = panoTitle;
    //playerView.title = @"sdfsdfsfd";
    
    [playerView release];
}

- (void)addPano:(NSString *)panoId thumbImage:(NSString *)thumbImage panotitle:(NSString *)panoTitle photoTime:(NSString *)photoTime{
    
    NSMutableDictionary * pano = [[NSMutableDictionary alloc] init];
    [pano setValue:panoId forKey:@"panoId"];
    [pano setValue:panoTitle forKey:@"panoTitle"];
    [pano setValue:photoTime forKey:@"photoTime"];
    [pano setValue:thumbImage forKey:@"thumbImage"];
    
    [panoList addObject:pano];
}
- (void) getWrong:(NSString*)str{
    NSString *msg = [NSString stringWithFormat:@"%@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


/**
 获取全景图信息列表
 */

- (NSString *)getJsonFromUrl:(NSString *)url{
    if(url == nil){
        [self getWrong:@"参数错误"];
        return @"";
    }
    NSString *responseData = [[NSString alloc] init];
    
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];

    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *path = [cachePath stringByAppendingPathComponent:@"Caches"];

    [cache setStoragePath:[cachePath stringByAppendingPathComponent:@"Caches"]];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    [request setDownloadCache:cache];
    
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [cache setShouldRespectCacheControlHeaders:NO];
    //[]
    [request setSecondsToCache:60*60*24*30*10]; //30
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        responseData = [request responseString];
        //NSLog(@"response%@", responseData);
    }
    else {
        [self getWrong:@"获取数据失败"];
    }
    
    
    return responseData;
}


//解析json数据
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;	// Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    
    [self getPanoInfo];
    
}
-(void) getPanoInfo{
    panoList = [[NSMutableArray alloc] init];
	
	NSString *responseData = [self getJsonFromUrl:panoListUrl];
    if(responseData !=nil){
        NSDictionary *resultsDictionary = [responseData objectFromJSONString];
        NSArray *panos = [resultsDictionary objectForKey:@"panos"];
        for(int i=0; i<panos.count; i++){
            NSDictionary  *tmp = [panos objectAtIndex:i];
            NSString *panoId = [tmp objectForKey:@"id"];
            NSString *panoTitle = [tmp objectForKey:@"title"];
            NSString *panoCreated = [tmp objectForKey:@"created"];
            NSString *panoThumb = [tmp objectForKey:@"thumb"];
            //NSLog(@"panoTilet=%@", panoThumb);
            [self addPano:panoId thumbImage:panoThumb panotitle:panoTitle photoTime:panoCreated];
        }
    }
}

//刷新页面
-(IBAction)onClickButton:(id)sender{

    [self.view removeFromSuperview];
    HomeViewController *homeView = [[HomeViewController alloc] init];
    homeView.title = @"西湖秋景";
    [self.navigationController pushViewController:homeView animated:(YES)];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    panoList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}
/*
 -(NSUInteger)supportedInterfaceOrientations{
 return UIInterfaceOrientationMaskLandscape;
 }
 - (BOOL)shouldAutorotate {
 return YES;
 }*/



@end