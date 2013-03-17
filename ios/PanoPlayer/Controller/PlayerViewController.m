//
//  PlayerViewController.m
//  PanoPlayer
//
//  Created by 李文博 on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#define kIdMin 1
#define kIdMax 1000
#import "PlayerViewController.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
//#import "SDWebImageDownloader.h"
//#import "SDImageCache.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
//#import "ImageViewController.h"
//#import "ASINetworkQueue.h"

@interface PlayerViewController ()
//- (void)imageFetchComplete:(ASIHTTPRequest *)request;
//- (void)imageFetchFailed:(ASIHTTPRequest *)request;
@end

@implementation PlayerViewController

//@synthesize panoId;

@synthesize hotspots;
@synthesize faceSL;
@synthesize faceSR;
@synthesize faceSF;
@synthesize faceSB;
@synthesize faceSD;
@synthesize faceSU;
@synthesize loading;
@synthesize panoTitle;
@synthesize alertOnce;
@synthesize imageView;
@synthesize closeBt;
@synthesize aboveView;
@synthesize rightItemBar;

@synthesize imageProgressIndicator;
@synthesize logo;

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    isAnimation = false;
    lookAtX = 0.03f;
    lookAtY = 0.05f;
    animationWaitTime = 4000;
    animationMoveTime = 10;

    rightItemBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"repeat.png"] style:NO target:self action:@selector(rightItemClick:)];

    self.navigationItem.rightBarButtonItem = rightItemBar;
    
    //self.navigationItem.title = @"sdfsdfsdf";
    //[self.navigationItem setTitle:@"asdfs"];
    plView = (PLView *)self.view;
    plView.delegate = self;
    finishDownLoad = false;
    faceSB = [[UIImage alloc] init];
    faceSD = [[UIImage alloc] init];
    faceSF = [[UIImage alloc] init];
    faceSL = [[UIImage alloc] init];
    faceSL = [[UIImage alloc] init];
    faceSL = [[UIImage alloc] init];
    
    //self.view.autoresizesSubviews;
    self.alertOnce = false;
    
    level = [self getProjectLevel];
    if ([level isEqualToString:@"0"]) {
        [logo setText:@"www.yiluhao.com"];
    }
    else if ([level isEqualToString:@"1"]) {
        [logo setText:@"标准版测试，升级后此信息不显示"];
    }
    
    loading = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    imageProgressIndicator = [[[UIProgressView alloc] initWithFrame:CGRectZero] autorelease];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(panoPlayerNotificationHandler:) name:@"panoId" object:nil];
}

-(NSString *)getProjectLevel{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"project_list.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    NSString *level = [data objectForKey:@"level"];
    NSLog(@"level%@", level);
    if (level == nil) {
        //[self showLogin];
        level = @"0";
    }
    return level;
}

- (void)panoPlayerNotificationHandler:(NSNotification*)notification
{
    NSString *panoId = [[notification userInfo] objectForKey:@"panoId"];
    /*[NSThread detachNewThreadSelect:@selector(startPlayer)
     toTarget:self
     withObject:nil];
     */
    
    [self startThread:panoId];
    
    //[self.navigationItem setTitle:@"asdfs"];
    
}
-(void)startThread:(NSString *)panoId{
    finishDownLoad = false;
    [self drawWaiting];
    [plView showProgressBar];
    [NSThread detachNewThreadSelector:@selector(startDownload:) toTarget:self withObject:panoId];
    [self checkThread];
}

-(void)checkThread{
    if(finishDownLoad){
        [self displayPano];
        return;
    }
    else{
        [NSTimer scheduledTimerWithTimeInterval:0.2
                                         target:self
                                       selector:@selector(checkThread)
                                       userInfo:nil repeats:NO];
    }
}

-(void)drawWaiting{
    loading.hidden = NO;
    imageProgressIndicator.hidden = NO;
    loading.backgroundColor = [UIColor clearColor];
    loading.font = [UIFont fontWithName:@"Arial" size:12];
    loading.textAlignment = UITextAlignmentCenter;
    //loading.font
    [self.view addSubview:loading];
    [self changeLoadState:1];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    int height = result.height;
    int width = result.width;
    int progressWdith = width/2;
    int x = (width - 150)/2;
    int y = (height/2)-100;
    //NSLog(@"X-Y=%d-%d", x, y);
    [loading setFrame:CGRectMake(x,y,150,20)];
    [self.view addSubview:imageProgressIndicator];
    y = y+20;
    x = (width - progressWdith)/2;
    [imageProgressIndicator setFrame:CGRectMake(x,y,progressWdith,30)];
    
    
    
    
}

//修改载入图片进程
-(void)changeLoadState:(int) state{
    NSString *msg = nil;
    //CGRect frame = loading.frame;
    //NSLog(@"STATE=%@", loading);
    switch (state) {
        case 1:
            msg = @"素材加载中...";
            break;
        case 2:
            msg = @"素材加载中...";
            break;
        case 3:
            msg = @"素材加载中...";
            break;
        case 4:
            msg = @"素材加载中...";
            break;
        case 5:
            msg = @"素材加载中...";
            break;
        case 6:
            msg = @"素材加载中...";
            break;
        case 7:
            msg = @"渲染图片...";
            break;
        default:
            break;
    }
    loading.text = msg;
}

-(void)startDownload:(NSString *)panoId{
    
    hotspots = [[NSMutableArray alloc] init];
    if(panoId != nil){
        NSString *panoInfoUrl = [NSString stringWithFormat:@"http://beta1.yiluhao.com/ajax/m/pv/id/%@", panoId];
        
        NSString *responseData = [self getPanoInfoFromUrl:panoInfoUrl];
        if(responseData ==nil){
            [self getWrong:@"加载数据出错,请检查您的网络设置"];
            
            return;
        }
        else{
            NSDictionary *resultsDictionary = [responseData objectFromJSONString];
            NSArray *hotspotDct = [resultsDictionary objectForKey:@"hotspots"];
            //NSLog(@"res=%@", [ret objectForKey:@"panos"]);
            for(int i=0; i<hotspotDct.count; i++){
                NSDictionary  *tmp = [hotspotDct objectAtIndex:i];
                
                NSString *hotspotId = [tmp objectForKey:@"id"];
                NSString *link_scene_id = [tmp objectForKey:@"link_scene_id"];
                NSString *tilt = [tmp objectForKey:@"tilt"];
                NSString *pan = [tmp objectForKey:@"pan"];
                NSString *transform = [tmp objectForKey:@"transform"];
                NSString *type = [tmp objectForKey:@"type"];
                NSString *filePath = @"";
                if([type isEqualToString:@"4"]){
                    
                    filePath = [tmp objectForKey:@"file_path"];
                    //NSLog(@"filePath%@", filePath);
                }
                
                [self addHotspot:hotspotId linkSceneId:link_scene_id tilt:tilt pan:pan transform:transform type:type filePath:filePath];
                //NSLog(@"id=%@", hotspotId);
                //NSLog(@"link_scene_id=%@", link_scene_id);
            }
            
            
            ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
            
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            [cache setStoragePath:[cachePath stringByAppendingPathComponent:@"Caches"]];
            
            //UIImage *img;
            ASIHTTPRequest *request;
            
            NSDictionary *pano = [resultsDictionary objectForKey:@"pano"];
            self.panoTitle = [pano objectForKey:@"title"];
            
            //NSLog(@"aaaa%@", panoTitle);
            
            NSString *s_f = [pano objectForKey:@"s_f"];
            request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s_f]];
            [request setDownloadCache:cache];
            [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
            [request setSecondsToCache:60*60*24*30*10]; //30
            [imageProgressIndicator setProgress:0];
            [request setDownloadProgressDelegate:imageProgressIndicator];
            [request setUserInfo:[NSDictionary dictionaryWithObject:@"s_f" forKey:@"face"]];
            Boolean cached = [cache isCachedDataCurrentForRequest:request];
            if(cached){
                NSLog(@"cached2");
            }
            [request startSynchronous];
            NSError *error = [request error];
            if (!error) {
                self.faceSF = [UIImage imageWithData:[request responseData]];
                //NSLog(@"response%@", responseData);
            }
            else {
                [self getWrong:@"获取素材失败,请检查您的网络设置"];
                return;
            }
            
            [self changeLoadState:2];
            //[self.view addSubview:loading];
            NSString *s_r = [pano objectForKey:@"s_r"];
            request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s_r]];
            [request setDownloadCache:cache];
            [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
            [request setSecondsToCache:60*60*24*30*10]; //30
            [imageProgressIndicator setProgress:0];
            [request setDownloadProgressDelegate:imageProgressIndicator];
            [request setUserInfo:[NSDictionary dictionaryWithObject:@"s_r" forKey:@"face"]];
            
            [request startSynchronous];
            error = [request error];
            if (!error) {
                self.faceSR = [UIImage imageWithData:[request responseData]];
            }
            else {
                [self getWrong:@"获取素材失败,请检查您的网络设置"];
                return;
            }
            
            cached = [cache isCachedDataCurrentForRequest:request];
            if(cached){
                NSLog(@"cached3");
            }
            
            [self changeLoadState:3];
            NSString *s_b = [pano objectForKey:@"s_b"];
            request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s_b]];
            [request setDownloadCache:cache];
            [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
            [request setSecondsToCache:60*60*24*30*10]; //30
            [imageProgressIndicator setProgress:0];
            [request setDownloadProgressDelegate:imageProgressIndicator];
            [request setUserInfo:[NSDictionary dictionaryWithObject:@"s_b" forKey:@"face"]];
            
            [request startSynchronous];
            error = [request error];
            if (!error) {
                self.faceSB = [UIImage imageWithData:[request responseData]];
            }
            else {
                [self getWrong:@"获取素材失败,请检查您的网络设置"];
                return;
            }
            
            cached = [cache isCachedDataCurrentForRequest:request];
            if(cached){
                NSLog(@"cached4");
            }
            
            [self changeLoadState:4];
            NSString *s_l = [pano objectForKey:@"s_l"];
            request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s_l]];
            [request setDownloadCache:cache];
            [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
            [request setSecondsToCache:60*60*24*30*10]; //30
            [imageProgressIndicator setProgress:0];
            [request setDownloadProgressDelegate:imageProgressIndicator];
            [request setUserInfo:[NSDictionary dictionaryWithObject:@"s_l" forKey:@"face"]];
            
            [request startSynchronous];
            error = [request error];
            if (!error) {
                self.faceSL = [UIImage imageWithData:[request responseData]];
            }
            else {
                [self getWrong:@"获取素材失败,请检查您的网络设置"];
                return;
            }
            
            cached = [cache isCachedDataCurrentForRequest:request];
            if(cached){
                NSLog(@"cached5");
            }
            
            [self changeLoadState:5];
            NSString *s_u = [pano objectForKey:@"s_u"];
            request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s_u]];
            [request setDownloadCache:cache];
            [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
            [request setSecondsToCache:60*60*24*30*10]; //30
            [imageProgressIndicator setProgress:0];
            [request setDownloadProgressDelegate:imageProgressIndicator];
            [request setUserInfo:[NSDictionary dictionaryWithObject:@"s_u" forKey:@"face"]];
            
            [request startSynchronous];
            error = [request error];
            if (!error) {
                self.faceSU = [UIImage imageWithData:[request responseData]];
            }
            else {
                [self getWrong:@"获取素材失败,请检查您的网络设置"];
                return;
            }
            cached = [cache isCachedDataCurrentForRequest:request];
            if(cached){
                NSLog(@"cached6");
            }
            
            [self changeLoadState:6];
            NSString *s_d = [pano objectForKey:@"s_d"];
            request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:s_d]];
            [request setDownloadCache:cache];
            [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
            [request setSecondsToCache:60*60*24*30*10]; //30
            [imageProgressIndicator setProgress:0];
            [request setDownloadProgressDelegate:imageProgressIndicator];
            [request setUserInfo:[NSDictionary dictionaryWithObject:@"s_d" forKey:@"face"]];
            
            [request startSynchronous];
            error = [request error];
            if (!error) {
                self.faceSD = [UIImage imageWithData:[request responseData]];
            }
            else {
                [self getWrong:@"获取素材失败,请检查您的网络设置"];
                return;
            }
            
            cached = [cache isCachedDataCurrentForRequest:request];
            if(cached){
                NSLog(@"cached7");
            }
            [self changeLoadState:7];
            //[self displayPano];
            finishDownLoad = true;
        }
    }
    
}

-(void)addHotspot:(NSString *)hotspotId linkSceneId:(NSString *)linkSceneId tilt:(NSString *)tilt pan:(NSString *)pan transform:(NSString *)transform type:(NSString *)type filePath:(NSString *)filePath{
    
    NSMutableDictionary *hotspotBox = [[NSMutableDictionary alloc] init];
    [hotspotBox setValue:hotspotId forKey:@"hotspotId"];
    [hotspotBox setValue:linkSceneId forKey:@"linkSceneId"];
    [hotspotBox setValue:tilt forKey:@"tilt"];
    [hotspotBox setValue:pan forKey:@"pan"];
    [hotspotBox setValue:transform forKey:@"transform"];
    [hotspotBox setValue:type forKey:@"type"];
    [hotspotBox setValue:filePath forKey:@"filePath"];
    //NSLog(@"FILEpath%@", filePath);
    [hotspots addObject:hotspotBox];
    //NSLog(@"hotspots%@", hotspots);
}


-(void)displayPano{
    
    //NSObject<PLIPanorama> *panorama = nil;
    cubicPanorama = [PLCubicPanorama panorama];
    
    CGImageRef cgFaceSF = CGImageRetain(faceSF.CGImage);
    //[faceSF release], faceSF = nil;
    
    CGImageRef cgFaceSB = CGImageRetain(faceSB.CGImage);
    
    CGImageRef cgFaceSD = CGImageRetain(faceSD.CGImage);
    
    CGImageRef cgFaceSL = CGImageRetain(faceSL.CGImage);
    
	CGImageRef cgFaceSR = CGImageRetain(faceSR.CGImage);
    
    CGImageRef cgFaceSU = CGImageRetain(faceSU.CGImage);
    
    NSLog(@"wait time----");
    
    [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithCGImage:cgFaceSF]] face:PLCubeFaceOrientationFront];
    [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithCGImage:cgFaceSL]] face:PLCubeFaceOrientationLeft];
    [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithCGImage:cgFaceSR]] face:PLCubeFaceOrientationRight];
    [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithCGImage:cgFaceSB]] face:PLCubeFaceOrientationBack];
    [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithCGImage:cgFaceSU]] face:PLCubeFaceOrientationUp];
    [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithCGImage:cgFaceSD]] face:PLCubeFaceOrientationDown];
    //panorama = cubicPanorama;
    NSString *transform = @"";
    NSString *hotspotName = @"";
    NSString *type = @"";
    for (int i=0; i<hotspots.count; i++) {
        
        NSMutableDictionary *hotspotDct = [hotspots objectAtIndex:i];
        
        transform = [hotspotDct objectForKey:@"transform"];
        type = [hotspotDct objectForKey:@"type"];
        if([type isEqualToString:@"2"]){
            hotspotName = [NSString stringWithFormat:@"hotspots%@", transform];
        }
        else{
            hotspotName = @"imghotspot";
        }
        
        //NSLog(@"aaa%@", hotspotName);
        PLTexture *hotspotTexture = [PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:hotspotName ofType:@"png"]]];
        
        
        NSString *hotspotId = [hotspotDct objectForKey:@"hotspotId"];
        NSString *tilt = [hotspotDct objectForKey:@"tilt"];
        NSString *pan = [hotspotDct objectForKey:@"pan"];
        
        PLHotspot *hotspot = [PLHotspot hotspotWithId:[hotspotId intValue] texture:hotspotTexture atv:[tilt floatValue] ath:[pan floatValue] width:0.06f height:0.06f];
        
        [cubicPanorama addHotspot:hotspot];
        
    }
    //[self.view reloadInputViews];
    
    [plView setPanorama:cubicPanorama];
    [plView hideProgressBar];
    //[imageProgressIndicator removeFromSuperview];
    //[loading removeFromSuperview];
    
    imageProgressIndicator.hidden = YES;
    loading.hidden = YES;
    [self.navigationItem setTitle:panoTitle];
}

-(void) stopAnimation{
    [aniTimer invalidate];
    aniTimer = nil;
    isAnimation = false;
    [plView stopAnimation];
}
-(void) startAnimation{
    isAnimation = true;
    [plView startAnimation];
    aniTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(setAnimation) userInfo:nil repeats:YES];
}
- (IBAction)rightItemClick:(id)sender {
    if (isAnimation) {
        [rightItemBar setImage:[UIImage imageNamed:@"repeat.png"]];
        [self stopAnimation];
    }
    else{
        
        [rightItemBar setImage:[UIImage imageNamed:@"pause.png"]];
        [self startAnimation];
    }
}

- (void)setAnimation
{
    float cameraAtX = [[plView getCamera] getPitch];
    float cameraAtY = [[plView getCamera] getYaw];
    //[[plView getCamera] setInitialLookAtWithPitch:cameraAtX yaw:cameraAtY];
    if (cameraAtX != 0) {
        if (cameraAtX > 0) {
            cameraAtX = (cameraAtX-lookAtX) > 0 ? (cameraAtX-lookAtX) : 0;
        }
        else{
            cameraAtX = (cameraAtX+lookAtX) < 0 ? (cameraAtX+lookAtX) : 0;
        }
        //cameraAtX = cameraAtX >0 ? (cameraAtX-lookAtX) : (cameraAtX+lookAtX);
    }

    cameraAtY += lookAtY;

    [[plView getCamera] lookAtWithPitch:cameraAtX yaw:cameraAtY];
    [[plView getCamera] setPitch:cameraAtX];
    [[plView getCamera] setYaw:cameraAtY];

}


- (void) getWrong:(NSString*)str{
    if (!alertOnce) {
        NSString *msg = [NSString stringWithFormat:@"%@", str];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        self.imageProgressIndicator.hidden = YES;
        self.loading.hidden = YES;
    }
    self.alertOnce = true;
}

-(NSString *)getPanoInfoFromUrl:(NSString *)url{
    if(url == nil){
        [self getWrong:@"参数错误"];
        return @"";
    }
    NSString *responseData = [[NSString alloc] init];
    
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
        //[self getWrong:@"获取数据失败"];
        return nil;
    }
    
    
    return responseData;
}

-(void)drawImageView:(NSString *)panoId imagePath:(NSString *)imagePath{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    int height = result.height-85;
    int width = result.width-20;
    //NSLog(@"adfsdf%d", height);
    int x = 10;
    int y = 10;

    aboveView = [AboveViewController alloc];
    //[aboveView setImage:[UIImage imageNamed:@"default960.jpg"]];
    //[self downloadHotImage:imagePath];
    [aboveView initWithFrame:CGRectMake(x, y, width, height)];
    [self.aboveView downloadHotImage:imagePath];
    [self.view addSubview:aboveView];
}


//Hotspot event
-(void)view:(UIView<PLIView> *)pView didClickHotspot:(PLHotspot *)hotspot screenPoint:(CGPoint)point scene3DPoint:(PLPosition)position
{
    NSString *clickHotspotId = [NSString stringWithFormat:@"%lld", hotspot.identifier];
    NSString *panoId = nil;
    NSString *type = @"2";
    NSString *hotType = @"";
    NSString *filePath = @"";
    for (int i=0; i<hotspots.count; i++) {
        NSMutableDictionary *hotspotDct = [hotspots objectAtIndex:i];
        NSString *linkScence = [hotspotDct objectForKey:@"linkSceneId"];
        NSString *hotspotId = [hotspotDct objectForKey:@"hotspotId"];
        hotType = [hotspotDct objectForKey:@"type"];
        if([hotspotId isEqualToString:clickHotspotId]){
            panoId = linkScence;
            type = hotType;
            if([type isEqualToString:@"4"]){
                filePath = [hotspotDct objectForKey:@"filePath"];
            }
        }
    }
    //NSLog(@"adsfsdf%@---%@", hotType, filePath);
    if([type isEqualToString:@"2"]){
        [plView showProgressBar];
        [self startThread:panoId];
    }
    else if([type isEqualToString:@"4"]){
        /*
        UIActivityIndicatorView *progressInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [progressInd setCenter:CGPointMake(50, 50)]; // I do this because I'm in landscape mode
        // spinner is not visible until started
        [self.view addSubview:progressInd];
        //[self addSubview:progressInd];
        [progressInd startAnimating];
        */
        [self drawImageView:panoId imagePath:filePath];
    }
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //[cubicPanorama release], cubicPanorama=nil;
    [plView release], plView = nil;
}

-(void)dealloc
{
    [super dealloc];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end