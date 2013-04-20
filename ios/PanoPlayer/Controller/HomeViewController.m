//
//  HomeViewController.m
//  PanoPlayer
//
//  Created by 李文博 on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "PlayerViewController.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

#import "MosaicData.h"
#import "MosaicDataView.h"



@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize panoList;
@synthesize pagePanos;
@synthesize totalNum;
@synthesize projectListUrl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//解析json数据
- (void)viewDidLoad
{
    [super viewDidLoad];
    pageSize = 20;
    curentPage = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ProjectPlayerNotificationHandler:) name:@"projectId" object:nil];
    
    rightItemBar = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.rightBarButtonItem = rightItemBar;
    
}

-(void)setPageInfo{
    if (curentPage == 1) {
        rightItemBar.title = [NSString stringWithFormat:@"下一页 %d/%d", curentPage, totalPage];
        nextPage = curentPage+1;
    }
    else{
        rightItemBar.title = [NSString stringWithFormat:@"上一页 %d/%d", curentPage, totalPage];
        nextPage = curentPage-1;
    }
    
    rightItemBar.action = @selector(NextPage);
}

- (void)ProjectPlayerNotificationHandler:(NSNotification*)notification
{
    //NSLog(@"sdfsf%@", @"fsdfsdf");
    NSString *projectId = [[notification userInfo] objectForKey:@"projectId"];
    NSString *projectTitle = [[notification userInfo] objectForKey:@"projectTitle"];
    currentProjectId = projectId;
    
    projectListUrl = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/pl/id/%@", projectId];
    // Do any additional setup after loading the view.
    [self setItemTitle:projectTitle];
    [self getPanoInfo];
    panoList = [[NSMutableArray alloc] init];
    [self getPageList];
    mosaicView.delegate = self;
    [self displayMocaic];
    
}
-(void)displayMocaic{
    [self setPageInfo];
    //NSLog(@"panoList=%d", panoList.count);
    mosaicView.datasource = [PanoListMosaicDatasource sharedInstance:panoList];
    [mosaicView refresh];
    //mosaicView.
}

-(void)scrollHead{
    //return;
    //NSLog(@"head");
    curentPage = curentPage-1;
    if (curentPage<1) {
        curentPage = 1;
    }
    panoList = [[NSMutableArray alloc] init];
    [self getPageList];
    [self displayMocaic];
    //[self.view addSubview: topView];
}
-(void)scrollFoot{
    curentPage = curentPage+1;
    if(curentPage>totalPage){
        curentPage = totalPage;
        return;
    }
    panoList = [[NSMutableArray alloc] init];
    [self getPageList];
    [self displayMocaic];
    //[mosaicView setScrollHead];
}
-(void)NextPage{
    curentPage = nextPage;
    panoList = [[NSMutableArray alloc] init];
    [self getPageList];
    [self displayMocaic];
}

-(void)setItemTitle:(NSString *)title{
    self.title = NSLocalizedString(title, title);
    self.tabBarItem.image = [UIImage imageNamed:@"home"];
}
-(void) getPanoInfo{
    self.pagePanos = [[NSMutableArray alloc] init];
	NSString *responseData = [self getJsonFromUrl:projectListUrl];
    if(responseData !=nil){
        NSDictionary *resultsDictionary = [responseData objectFromJSONString];
        self.pagePanos = [resultsDictionary objectForKey:@"panos"];
        self.totalNum = pagePanos.count;
        totalPage = pagePanos.count/pageSize;
        if (pagePanos.count%pageSize>0) {
            totalPage++;
        }
    }
}

-(void) getPageList{
    
    int from = (curentPage-1)*pageSize;
    int to = from+pageSize;
    
    if (to>self.totalNum) {
        to = self.totalNum;
    }
    for(int i=from; i<to; i++){
        
        NSDictionary  *tmp = [self.pagePanos objectAtIndex:i];
        NSString *panoId = [tmp objectForKey:@"id"];
        NSString *panoTitle = [tmp objectForKey:@"title"];
        NSString *panoCreated = [tmp objectForKey:@"created"];
        NSString *panoThumb = [tmp objectForKey:@"thumb"];
        NSString *width = [tmp objectForKey:@"thumb-w"];
        NSString *height = [tmp objectForKey:@"thumb-h"];
        NSString *size = [tmp objectForKey:@"size"];
        if(size == nil){
            size = @"1";
        }
        
        [self addPano:panoId thumbImage:panoThumb panotitle:panoTitle width:width height:height size:size   photoTime:panoCreated];
    }

}


- (void)addPano:(NSString *)panoId thumbImage:(NSString *)thumbImage panotitle:(NSString *)panoTitle  width:(NSString *)width height:(NSString *)height size:(NSString *)size photoTime:(NSString *)photoTime{

    NSMutableDictionary * pano = [[NSMutableDictionary alloc] init];
    
    [pano setValue:panoId forKey:@"pid"];
    [pano setValue:panoTitle forKey:@"title"];
    [pano setValue:thumbImage forKey:@"url"];
    [pano setValue:height forKey:@"height"];
    [pano setValue:width forKey:@"width"];
    [pano setValue:size forKey:@"size"];
    //NSLog(@"AAAA%@", pano);
    [self.panoList addObject:pano];
}

- (void) getWrong:(NSString*)str{
    NSString *msg = [NSString stringWithFormat:@"%@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

//获取全景图信息列表

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
    configDatas = [[ConfigDataSource alloc] init];
    
    int cacheDay = [configDatas getConfigCache];
    int days = 60*60*24*cacheDay;
    
    [request setSecondsToCache:days]; //30
    NSLog(@"%d", days);
    
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


#pragma mark - Private

static UIImageView *captureSnapshotOfView(UIView *targetView){
    UIImageView *retVal = nil;
    
    UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, YES, 0);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [[targetView layer] renderInContext:currentContext];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    retVal = [[UIImageView alloc] initWithImage:image];
    retVal.frame = [targetView frame];
    
    return retVal;
}

#pragma mark - Public

- (void)viewDidLayoutSubviews{
}

-(void)loadPano:(NSString *) panoId{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    PlayerViewController *playerView = [[PlayerViewController alloc] init];
    
    playerView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playerView animated:YES];
    
    NSMutableDictionary * pano = [[NSMutableDictionary alloc] init];
    
    [pano setValue:panoId forKey:@"panoId"];
    [pano setValue:currentProjectId forKey:@"projectId"];

    //发送消息.@"pass"匹配通知名，object:nil 通知类的范围
    [[NSNotificationCenter defaultCenter] postNotificationName:@"panoId" object:nil userInfo:pano];

    [playerView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mosaicViewDidTap:(MosaicDataView *)aModule{
    [self loadPano:aModule.module.pid];
    //NSLog(@"#DEBUG Tapped %@", aModule.module.pid);
}

-(void)mosaicViewDidDoubleTap:(MosaicDataView *)aModule{
    [self loadPano:aModule.module.pid];
    //NSLog(@"#DEBUG Double Tapped %@", aModule.module.pid);
}


- (void)dealloc {
    [mosaicView removeFromSuperview];
    [self.view removeFromSuperview];
    [super dealloc];
}

@end