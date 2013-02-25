//
//  AboveViewController.m
//  PanoPlayer
//
//  Created by yiluhao on 13-2-22.
//
//

#import "AboveViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@interface AboveViewController ()

@end

@implementation AboveViewController
@synthesize imageView;
//@synthesize UIimage;
@synthesize closeBt;
//@synthesize progressInd;
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

        
        int progressW = 100;
        int progressH = 40;
        int x = frame.size.width;
        int y = frame.size.height;
        
        frame = CGRectMake((x - 70) / 2, (y - progressH-60) / 2, progressW, progressH);
        loading = [[[UILabel alloc] initWithFrame:frame] autorelease];
        loading.text = @"图片加载中...";
        loading.backgroundColor = [UIColor clearColor];
        loading.font = [UIFont fontWithName:@"Arial" size:12];
        //loading.font
        [self addSubview:loading];
        
        frame = CGRectMake((x - progressW) / 2, (y - progressH) / 2, progressW, progressH);
        //[self showWaiting];
        imageProgressIndicator = [[[UIProgressView alloc] initWithFrame:frame] autorelease];
        [self addSubview:imageProgressIndicator];

        
    }
    return self;
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
-(void) setImage:(UIImage *) image{
    imageView = [[ImageCropper alloc] initWithImage:image];
    [self addSubview:imageView.view];

    [self setCloseButton];
}

-(void)downloadHotImage:(NSString *)imagePath{
    
    
    if ([imagePath isEqualToString:@""]) {
        return ;
    }
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [cache setStoragePath:[cachePath stringByAppendingPathComponent:@"resource"]];
    [cache setShouldRespectCacheControlHeaders:NO] ;
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:imagePath]];
    
    [request setDownloadCache:cache];
    
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [request setSecondsToCache:60*60*24*30*10]; //300
    [request setDownloadProgressDelegate:imageProgressIndicator];
    [request setDelegate : self ];
    
    [request startAsynchronous];
    Boolean cached = [cache isCachedDataCurrentForRequest:request];
    if(cached){
        NSLog(@"hotImageCached");
    }
}
- (void) getWrong:(NSString*)str{

        NSString *msg = [NSString stringWithFormat:@"%@", str];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];

}
-(void)hideProgress{
    self.imageProgressIndicator.hidden = YES;
    self.loading.hidden = YES;
}

- ( void )requestFinished:( ASIHTTPRequest *)request
{
	UIImage *hotImage = [UIImage imageWithData:[request responseData]];
	if (hotImage) {
		[self setImage:hotImage];
        
	}
    else{
        [self getWrong:@"下载图片失败,请检查您的网络设置"];
    }
    [self hideProgress];
}

- ( void )requestFailed:( ASIHTTPRequest *)request
{
    if ([[request error] domain] != NetworkRequestErrorDomain || [[request error] code] != ASIRequestCancelledErrorType) {
        [self setCloseButton];
        [self getWrong:@"下载图片出错，请检查您的网络设置"];
    }
    [self hideProgress];
}

-(IBAction)onClickButton:(id)sender{
    //self.removeFromSuperview;
    [self removeFromSuperview];
}
- (void)dealloc {
    [super dealloc];
}

@end
