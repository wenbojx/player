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
@synthesize projectListUrl;
@synthesize reflashButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


//解析json数据
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ProjectPlayerNotificationHandler:) name:@"projectId" object:nil];
    
}

- (void)ProjectPlayerNotificationHandler:(NSNotification*)notification
{
    //NSLog(@"sdfsf%@", @"fsdfsdf");
    NSString *projectId = [[notification userInfo] objectForKey:@"projectId"];
    NSString *projectTitle = [[notification userInfo] objectForKey:@"projectTitle"];
    //NSLog(@"projectTitle%@", projectTitle);
    
    projectListUrl = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/pl/id/%@", projectId];
    
    	// Do any additional setup after loading the view.
    [self setItemTitle:projectTitle];
    [self getPanoInfo];

    
}
-(void)setItemTitle:(NSString *)title{
    self.title = NSLocalizedString(title, title);
    self.tabBarItem.image = [UIImage imageNamed:@"home"];
}

/*
-(NSString *)getProjectId{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"project_list.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    NSString *project_id = [data objectForKey:@"project_id"];
    if (project_id == nil) {
        //[self showLogin];
        project_id = @"1001";
    }
    return project_id;
}
 */

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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
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




-(void) getPanoInfo{
    panoList = [[NSMutableArray alloc] init];
	
	NSString *responseData = [self getJsonFromUrl:projectListUrl];
    //NSLog(@"sdfdsf=%@", responseData);
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
    //homeView.title = @"西湖秋景";
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




/*
 
 
 
 - (void)didReceiveMemoryWarning
 {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }
 //＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
 //初始化刷新视图
 //＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
 #pragma mark
 #pragma methods for creating and removing the header view
 
 -(void)createHeaderView{
 if (_refreshHeaderView && [_refreshHeaderView superview]) {
 [_refreshHeaderView removeFromSuperview];
 }
 _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
 CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
 self.view.frame.size.width, self.view.bounds.size.height)];
 _refreshHeaderView.delegate = self;
 
 [self.aoView addSubview:_refreshHeaderView];
 
 [_refreshHeaderView refreshLastUpdatedDate];
 }
 
 -(void)removeHeaderView{
 if (_refreshHeaderView && [_refreshHeaderView superview]) {
 [_refreshHeaderView removeFromSuperview];
 }
 _refreshHeaderView = nil;
 }
 
 -(void)setFooterView{
 UIEdgeInsets test = self.aoView.contentInset;
 // if the footerView is nil, then create it, reset the position of the footer
 CGFloat height = MAX(self.aoView.contentSize.height, self.aoView.frame.size.height);
 if (_refreshFooterView && [_refreshFooterView superview]) {
 // reset position
 _refreshFooterView.frame = CGRectMake(0.0f,
 height,
 self.aoView.frame.size.width,
 self.view.bounds.size.height);
 }else {
 // create the footerView
 _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
 CGRectMake(0.0f, height,
 self.aoView.frame.size.width, self.view.bounds.size.height)];
 _refreshFooterView.delegate = self;
 [self.aoView addSubview:_refreshFooterView];
 }
 
 if (_refreshFooterView) {
 [_refreshFooterView refreshLastUpdatedDate];
 }
 }
 
 -(void)removeFooterView{
 if (_refreshFooterView && [_refreshFooterView superview]) {
 [_refreshFooterView removeFromSuperview];
 }
 _refreshFooterView = nil;
 }
 
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 return NO;
 }
 
 #pragma mark-
 #pragma mark force to show the refresh headerView
 -(void)showRefreshHeader:(BOOL)animated{
 if (animated)
 {
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:0.2];
 self.aoView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
 // scroll the table view to the top region
 [self.aoView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
 [UIView commitAnimations];
 }
 else
 {
 self.aoView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
 [self.aoView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
 }
 
 [_refreshHeaderView setState:EGOOPullRefreshLoading];
 }
 //===============
 //刷新delegate
 #pragma mark -
 #pragma mark data reloading methods that must be overide by the subclass
 
 -(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
 
 //  should be calling your tableviews data source model to reload
 _reloading = YES;
 
 if (aRefreshPos == EGORefreshHeader) {
 // pull down to refresh data
 [self performSelector:@selector(refreshView) withObject:nil afterDelay:2.0];
 }else if(aRefreshPos == EGORefreshFooter){
 // pull up to load more data
 [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:2.0];
 }
 
 // overide, the actual loading data operation is done in the subclass
 }
 
 #pragma mark -
 #pragma mark method that should be called when the refreshing is finished
 - (void)finishReloadingData{
 
 //  model should call this when its done loading
 _reloading = NO;
 
 if (_refreshHeaderView) {
 [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
 }
 
 if (_refreshFooterView) {
 [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.aoView];
 [self setFooterView];
 }
 
 // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
 }
 
 #pragma mark -
 #pragma mark UIScrollViewDelegate Methods
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 if (_refreshHeaderView) {
 [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
 }
 
 if (_refreshFooterView) {
 [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
 }
 }
 
 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 if (_refreshHeaderView) {
 [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
 }
 
 if (_refreshFooterView) {
 [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
 }
 }
 
 
 #pragma mark -
 #pragma mark EGORefreshTableDelegate Methods
 
 - (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
 
 [self beginToReloadData:aRefreshPos];
 
 }
 
 - (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
 
 return _reloading; // should return if data source model is reloading
 
 }
 
 
 // if we don't realize this method, it won't display the refresh timestamp
 - (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
 
 return [NSDate date]; // should return date data source was last changed
 
 }
 
 //刷新调用的方法
 -(void)refreshView{
 DataAccess *dataAccess= [[DataAccess alloc]init];
 NSMutableArray *dataArray = [dataAccess getDateArray];
 [self.aoView refreshView:dataArray];
 [self testFinishedLoadData];
 
 }
 //加载调用的方法
 -(void)getNextPageView{
 [self removeFooterView];
 DataAccess *dataAccess= [[DataAccess alloc]init];
 NSMutableArray *dataArray = [dataAccess getDateArray];
 //    NSMutableArray *testData = [[NSMutableArray alloc]init];
 //    for (int i=0; i<9; i++) {
 //        [testData addObject:[dataArray objectAtIndex:i]];
 //    }
 [self.aoView getNextPage:dataArray];
 [self testFinishedLoadData];
 
 }-(void)testFinishedLoadData{
 
 [self finishReloadingData];
 [self setFooterView];
 }
 
 */





@end