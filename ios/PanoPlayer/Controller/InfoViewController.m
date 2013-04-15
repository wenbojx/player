//
//  InfoViewController.m
//  PanoPlayer
//
//  Created by 李文博 on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

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
    
    panoId = [[self getProjectId] intValue];
    
    panoListUrl = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/pl/id/%d", panoId];
    
    NSString *responseData = [self getJsonFromUrl:panoListUrl];
    NSString *style = @"<style>body{margin:5px;background-color:transparent;}</style>";
    NSString *content = @"暂无简介";
    if(responseData !=nil){
        NSDictionary *resultsDictionary = [responseData objectFromJSONString];
        content = [resultsDictionary objectForKey:@"info"];
        
    }
    content = [style stringByAppendingFormat:@"%@", content];
    
    iWebView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    iWebView.opaque = NO;
    iWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    [iWebView setBackgroundColor:[UIColor clearColor]];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [header setBackgroundColor:[UIColor clearColor]];
    
    //NSString *htmlString = [content stringByAppendingFormat:@"%@", textview.text];
    
    [iWebView loadHTMLString:content baseURL:nil];
    
    [self.view addSubview:iWebView];
    //[self loadDocument:@"info.html"];
    
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
    }
    else {
        [self getWrong:@"获取数据失败"];
    }
    return responseData;
}



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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
