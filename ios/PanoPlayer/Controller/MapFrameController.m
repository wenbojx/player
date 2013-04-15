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

@implementation MapFrameController{
    UIScrollView         *_viewScrollStub;
    MTImageMapView       *_viewImageMap;
    NSArray              *_stateNames;
}

@synthesize closeBt;

@synthesize viewScrollStub  = _viewScrollStub;
@synthesize viewImageMap    = _viewImageMap;
@synthesize stateNames      = _stateNames;
@synthesize linkScene;
@synthesize coordsData;
@synthesize responseData;
@synthesize imageProgressIndicator;
@synthesize loading;


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
    [self setCloseButton];
    [self loadMap];
    return self;
}

-(void) loadMap{
    panoId = [[self getProjectId] intValue];
    coordsData = [[NSArray alloc] init];
    
    [_viewScrollStub addSubview:_viewImageMap];
    [_viewScrollStub setContentSize:[_viewImageMap sizeThatFits:CGSizeZero]];

    loading = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    loading.text = @"地图加载中...";
    loading.backgroundColor = [UIColor clearColor];
    loading.font = [UIFont fontWithName:@"Arial" size:12];
    //loading.textAlignment = UITextAlignmentCenter;
    //loading.font
    [_viewScrollStub addSubview:loading];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    int height = result.height;
    int width = result.width;
    int progressWdith = width/2;
    int x = (width - 90)/2;
    int y = (height/2)-100;
    [loading setFrame:CGRectMake(x,y,90,20)];
    
    
    imageProgressIndicator = [[[UIProgressView alloc] initWithFrame:CGRectZero] autorelease];
    [_viewScrollStub addSubview:imageProgressIndicator];
    y = y+20;
    x = (width - progressWdith)/2;
    [imageProgressIndicator setFrame:CGRectMake(x,y,progressWdith,30)];

    responseData = [[NSString alloc] init];
    NSString *panoInfoUrl = [NSString stringWithFormat:@"http://beta1.yiluhao.com/ajax/m/pm/id/%d", panoId];
    //NSLog(@"panoInfoUrl=%@", panoInfoUrl);
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

- (void) getWrong:(NSString*)str{
    NSString *msg = [NSString stringWithFormat:@"%@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    self.loading.hidden = YES;
    self.imageProgressIndicator.hidden = YES;
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
    //[]
    [request setSecondsToCache:60*60*24*30*10]; //30
    
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
    //return;
    //url = @"http://beta1.yiluhao.com/html/pano-6000.jpg";
    
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
    [request setDownloadProgressDelegate:imageProgressIndicator];
    [request setSecondsToCache:60*60*24*30*10]; //30
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:coordsData forKey:@"coords"]];
    
    MapFrameController *a = [MapFrameController alloc];
    
    [request setDelegate : a ];
    Boolean cached = [cache isCachedDataCurrentForRequest:request];
    if(cached){
        //[imageProgressIndicator setProgress:100];
        NSLog(@"cached");
    }
    
    [request startAsynchronous];
}
- ( void )requestFinished:( ASIHTTPRequest *)request
{
    NSLog(@"sdfsf=%@", @"dddddd");
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
    self.imageProgressIndicator.hidden = YES;
    self.loading.hidden = YES;
}
- ( void )requestFailed:( ASIHTTPRequest *)request
{
    NSLog(@"sdfsf=%@", @"eeeeee");
    if ([[request error] domain] != NetworkRequestErrorDomain || [[request error] code] != ASIRequestCancelledErrorType) {
        [self getWrong:@"下载地图出错，请检查您的网络设置"];
    }
    [self hideProgress];
}


-(void)displayMap:(UIImage *)mapImage coords:(NSArray *)coords{
    NSLog(@"cccccc");
    NSLog(@"coordsData=%@", coordsData);
    return;
    NSMutableArray *arrStates = [[NSMutableArray alloc] init];
    linkScene = [[NSMutableArray alloc] init];
    UIImage *logo = [UIImage imageNamed:@"marker_green.png"];
    
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
        mapImage = [self addImageLogo:mapImage waterMark:logo left:marginLeft top:marginTop];
        //}
    }
    [logo release], logo=nil;
    
    _viewImageMap.image = mapImage;
    [_viewImageMap sizeToFit];
    
    [_viewScrollStub addSubview:_viewImageMap];
    
    
    [_viewScrollStub setContentSize:
     [_viewImageMap sizeThatFits:CGSizeZero]
	 ];
    
    [_viewImageMap
     setMapping:arrStates
     doneBlock:^(MTImageMapView *imageMapView) {
         NSLog(@"Areas are all mapped");
     }];
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
    NSString *panoId = [linkScene objectAtIndex:inIndexSelected];
    //NSLog(@"idddd=%@", panoId);
    
    PlayerViewController *playerView = [[PlayerViewController alloc] init];
    playerView.hidesBottomBarWhenPushed = YES;
    
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:panoId,@"panoId", nil];
    //NSDictionary
    
    //发送消息.@"pass"匹配通知名，object:nil 通知类的范围
    [[NSNotificationCenter defaultCenter] postNotificationName:@"panoId" object:nil userInfo:dic];
    
    //playerView.title = @"player";
    
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
    //self.removeFromSuperview;
    [self removeFromSuperview];
}

@end
