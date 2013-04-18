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
#import "PanoListMosaicDatasource.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize panoList;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ProjectPlayerNotificationHandler:) name:@"projectId" object:nil];
    
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
    
    mosaicView.datasource = [PanoListMosaicDatasource sharedInstance];
    mosaicView.delegate = self;
    
}



-(void)setItemTitle:(NSString *)title{
    self.title = NSLocalizedString(title, title);
    self.tabBarItem.image = [UIImage imageNamed:@"home"];
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



- (void)addPano:(NSString *)panoId thumbImage:(NSString *)thumbImage panotitle:(NSString *)panoTitle photoTime:(NSString *)photoTime{
    
    //NSMutableDictionary * pano = [[NSMutableDictionary alloc] init];
    /*
    NSString *height = @"210";
    NSString *width = @"250";
    
    DataInfo *data=[[DataInfo alloc]init];

    data.height= height.floatValue;

    data.width= width.floatValue;
    data.url = thumbImage;
    data.title= panoTitle;
    data.mess= Nil;
    data.panoId = panoId;
    [panoList addObject:data];
     */
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end