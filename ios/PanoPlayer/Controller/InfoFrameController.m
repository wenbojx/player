//
//  InfoFrameController.m
//  PanoPlayer
//
//  Created by yiluhao on 13-4-15.
//
//

#import "InfoFrameController.h"

@interface InfoFrameController ()

@end

@implementation InfoFrameController
@synthesize closeBt;
@synthesize panoId;
@synthesize curentProjectId;
@synthesize ViewBoxDelegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.cornerRadius = 10;    //设置弹出框为圆角视图
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 3;   //设置弹出框视图边框宽度
        self.layer.borderColor = [[UIColor colorWithRed:0.10 green:0.10 blue:0.10 alpha:0.5] CGColor];   //设置弹出框边框颜色
        self.autoresizesSubviews = YES;
        CGSize result = frame.size;
        width = result.width-35;
    }
    
    
    //panoId = [[self getProjectId] intValue];
    //panoId = 10130;
    
    panoListUrl = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/pv/id/%d", panoId];
    
    NSString *responseData = [self getJsonFromUrl:panoListUrl];
    NSString *style = @"<style>body{margin:5px;background-color:transparent;}</style>";
    NSString *content = @"暂无描述";
    if(responseData !=nil){
        
        NSDictionary *resultsDictionary = [responseData objectFromJSONString];
        NSDictionary *pano = [resultsDictionary objectForKey:@"pano"];
        NSString *contentTmp = [pano objectForKey:@"info"];
        if (contentTmp != nil && ![contentTmp isEqualToString:@""]) {
            //NSLog(@"tmp=%@", contentTmp);
            content = contentTmp;
        }
    }
    
    content = [style stringByAppendingFormat:@"%@", content];
    
    int widths = frame.size.width-10;
    int heights = frame.size.height-30;
    
    iWebView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 20, widths, heights)];
    iWebView.opaque = NO;
    iWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    [iWebView setBackgroundColor:[UIColor clearColor]];

    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(5, 20, width, heights)];
    [header setBackgroundColor:[UIColor clearColor]];
    
    //NSString *htmlString = [content stringByAppendingFormat:@"%@", textview.text];
    //NSLog(@"content=%@", content);
    [iWebView loadHTMLString:content baseURL:nil];
    
    [self addSubview:iWebView];
    
    [self setCloseButton];
    return self;
}

-(void) setPanoId:(int)pid{
    panoId = pid;
}


-(void) setCloseButton{
    closeBt = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [closeBt setFrame:CGRectMake(width, -5, 40, 40)];
    
    //设置button标题
    [closeBt setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBt setImage:[UIImage imageNamed:@"winclose.png"] forState:UIControlStateNormal];
    [closeBt addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    closeBt.tag = 1;
    [self addSubview:closeBt];
    
}
-(IBAction)onClickButton:(id)sender{
    [self removeFromSuperview];
    [ViewBoxDelegate closeBox:@"info"];
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
    
    
    Tools *tools = [[Tools alloc] init];
    NSString *fileCachePath = [tools getPanoFileCachePath:curentProjectId];
    
    [cache setStoragePath:fileCachePath];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    [request setDownloadCache:cache];
    
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [cache setShouldRespectCacheControlHeaders:NO];
    //[]
    configDatas = [[ConfigDataSource alloc] init];
    
    int cacheDay = [configDatas getConfigCache];
    int days = 60*60*24*cacheDay;
    [request setSecondsToCache:days]; //30
    
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




@end
