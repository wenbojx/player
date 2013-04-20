//
//  MapFrameController.m
//  PanoPlayer
//
//  Created by yiluhao on 13-4-15.
//
//

#import "MapFrameController.h"
#import "PlayerViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface MapFrameController ()

@end

@implementation MapFrameController

@synthesize closeBt;

@synthesize viewScrollStub;
@synthesize viewImageMap;
@synthesize stateNames;
@synthesize linkScene;
@synthesize coordsData;
@synthesize responseData;
@synthesize loading;
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
        //self.layer.backgroundColor =
        CGSize result = frame.size;
        width = result.width-35;
 
    }
    configDatas = [[ConfigDataSource alloc] init];
    layoutWidh = frame.size.width-20;
    layoutHeight = frame.size.height-30;
    
    viewScrollStub = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, layoutWidh, layoutHeight)];

    [self showWaiting];
    
    [self addSubview:viewScrollStub];
    [self loadMap];

    [self setCloseButton];
    
    return self;
}

-(void)showWaiting {
    
    loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(layoutWidh/2, layoutHeight/2, 20, 20)];
    //loading.center=CGPointMake(self.center.x,100);
    
    [loading setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhiteLarge];
    loading.color = [UIColor blackColor];
    [self.viewScrollStub addSubview:loading];
    [loading startAnimating];
}
//消除滚动轮指示器
-(void)hideWaiting
{
    [loading stopAnimating];
}

-(void) setPanoId:(NSString *)pid{
    panoId = pid;
}

-(void) setProjectId:(int)pid{
    projectId = pid;
}

-(void) loadMap{
    //ProjectId = [[self getProjectId] intValue];
    coordsData = [[NSArray alloc] init];

    loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(100, 100, 30, 30)];
    loading.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    loading.hidesWhenStopped = YES;
    [viewScrollStub addSubview:loading];
    [loading startAnimating];

    responseData = [[NSString alloc] init];
    NSString *panoInfoUrl = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/pm/id/%d", projectId];
    NSLog(@"panoInfoUrl=%@", panoInfoUrl);
    responseData = [self getPanoMapFromUrl:panoInfoUrl];
    //}
    Boolean flag = false;
    //NSLog(@"na%@", responseData);
    if(responseData !=nil){
        NSDictionary *resultsDictionary = [responseData objectFromJSONString];
        coordsData = [resultsDictionary objectForKey:@"coords"];
        //NSLog(@"na%@", coordsData);
        NSString *mapUrl = [resultsDictionary objectForKey:@"map"];
        
        if(coordsData && mapUrl){
            [self downLoadImage:mapUrl];
        }
        
        flag = true;
    }
    if(!flag){
        [self getWrong:@"加载数据出错,请检查您的网络设置"];
        
    }

}

- (void) getWrong:(NSString*)str{
    NSString *msg = [NSString stringWithFormat:@"%@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    self.loading.hidden = YES;
}


-(NSString *)getPanoMapFromUrl:(NSString *)url{
    if(url == nil){
        [self getWrong:@"参数错误"];
        return @"";
    }
    //NSString *responseData = [[NSString alloc] init];
    
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [cache setStoragePath:[cachePath stringByAppendingPathComponent:@"Caches"]];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    [request setDownloadCache:cache];
    
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [cache setShouldRespectCacheControlHeaders:NO];
    
    int cacheDay = [configDatas getConfigCache];
    int days = 60*60*24*cacheDay;
    [request setSecondsToCache:days]; //30
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        responseData = [request responseString];
        //NSLog(@"response%@", responseData);
    }
    else {
        [self getWrong:@"获取数据失败,请检查您的网络设置"];
    }
    
    return responseData;
}


-(void)downLoadImage:(NSString *)url{
    
    if(url == nil){
        [self getWrong:@"加载地图失败,请检查您的网络设置"];
        return;
    }
    
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [cache setStoragePath:[cachePath stringByAppendingPathComponent:@"Caches"]];
    
    [cache setShouldRespectCacheControlHeaders:NO] ;
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setDownloadCache:cache];
    
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    //[request setDownloadProgressDelegate:imageProgressIndicator];
    int cacheDay = [configDatas getDatasCache];
    int days = 60*60*24*cacheDay;
    
    [request setSecondsToCache:days]; //30
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:coordsData forKey:@"coords"]];
    
    //MapFrameController *a = [MapFrameController alloc];
    
    [request setDelegate : self ];
    Boolean cached = [cache isCachedDataCurrentForRequest:request];
    if(cached){
        //[imageProgressIndicator setProgress:100];
        NSLog(@"cached");
    }
    
    [request startAsynchronous];
}
- ( void )requestFinished:( ASIHTTPRequest *)request
{
    //[imageProgressIndicator setProgress:100000 animated:YES];
    NSArray *coords = [[request userInfo] objectForKey:@"coords"];
	UIImage *img = [UIImage imageWithData:[request responseData]];
    
	if (img) {
        
		[self displayMap:img coords:coords];
	}
    else{
        [self getWrong:@"下载地图失败,请检查您的网络设置"];
    }
    [self hideProgress];
}
-(void)hideProgress{
    //self.imageProgressIndicator.hidden = YES;
    self.loading.hidden = YES;
}
- ( void )requestFailed:( ASIHTTPRequest *)request
{
    if ([[request error] domain] != NetworkRequestErrorDomain || [[request error] code] != ASIRequestCancelledErrorType) {
        [self getWrong:@"下载地图出错，请检查您的网络设置"];
    }
    [self hideProgress];
}


-(void)displayMap:(UIImage *)mapImage coords:(NSArray *)coords{

    viewImageMap = [[MTImageMapView alloc] initWithImage:[UIImage imageNamed:@"map.jpg"]];
    NSMutableArray *arrStates = [[NSMutableArray alloc] init];
    linkScene = [[NSMutableArray alloc] init];
    UIImage *logo = [UIImage imageNamed:@"marker_green.png"];
    UIImage *logoRed = [UIImage imageNamed:@"marker_red.png"];
    NSLog(@"sdf%@",panoId);
    for (int i=0; i<coordsData.count; i++) {
        NSDictionary  *tmp = [coordsData objectAtIndex:i];
        NSString *coords = [tmp objectForKey:@"coords"];
        NSString *linkId = [tmp objectForKey:@"linkScene"];
        [arrStates addObject:coords];
        [linkScene addObject:linkId];
        NSArray *aArray = [coords componentsSeparatedByString:@","];
        float marginLeft = [[aArray objectAtIndex:0] floatValue];
        float marginTop = [[aArray objectAtIndex:1] floatValue];
        //if(i==3){
        //添加水印
        if ([linkId isEqualToString:panoId]) {
            mapImage = [self addImageLogo:mapImage waterMark:logoRed left:marginLeft top:marginTop];
        }
        else{
            mapImage = [self addImageLogo:mapImage waterMark:logo left:marginLeft top:marginTop];
        }
        //}
    }

    [logo release], logo=nil;
    viewImageMap.image = mapImage;
    [viewImageMap sizeToFit];
    
    [viewScrollStub addSubview:viewImageMap];
    //[viewImageMap initWithImage:<#(UIImage *)#>]

    [viewScrollStub setContentSize:
     [viewImageMap sizeThatFits:CGSizeZero]
	 ];
    viewImageMap.delegate = self;
    //[viewImageMap ]
    [viewImageMap
     setMapping:arrStates
     doneBlock:^(MTImageMapView *imageMapView) {
         NSLog(@"Areas are all mapped");
     }];
    [self hideWaiting];
}

-(UIImage *)addImageLogo:(UIImage *)img waterMark:(UIImage *)logo left:(float)left top:(float)top{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    int logoWidth = logo.size.width;
    int logoHeight = logo.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
    CGContextDrawImage(context, CGRectMake(left+15.0f, h-top-25.0f-logoHeight, logoWidth, logoHeight), [logo CGImage]);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}


-(void)imageMapView:(MTImageMapView *)inImageMapView
   didSelectMapArea:(NSUInteger)inIndexSelected
{
    //NSDictionary *panoInfo = [panoList objectAtIndex:indexPath.row];
    NSString *panoId_select = [linkScene objectAtIndex:inIndexSelected];
    
    PlayerViewController *playerView = [[PlayerViewController alloc] init];
    playerView.hidesBottomBarWhenPushed = YES;
    
    //NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:panoId,@"panoId", nil];
    
    NSMutableDictionary * pano = [[NSMutableDictionary alloc] init];
    
    [pano setValue:panoId_select forKey:@"panoId"];
    NSString *projectId_select = [NSString stringWithFormat: @"%d", projectId];
    [pano setValue:projectId_select forKey:@"projectId"];
    //NSDictionary
    
    //发送消息.@"pass"匹配通知名，object:nil 通知类的范围
    [[NSNotificationCenter defaultCenter] postNotificationName:@"panoId" object:nil userInfo:pano];
    
    //playerView.title = @"player";
    [self removeFromSuperview];
    [ViewBoxDelegate closeBox:@"map"];
    [playerView release];
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
    [ViewBoxDelegate closeBox:@"map"];
}

@end
