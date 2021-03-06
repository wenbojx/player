//
//  InfoFrameController.h
//  PanoPlayer
//
//  Created by yiluhao on 13-4-15.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "JSONKit.h"
#import "ConfigDataSource.h"
#import "Tools.h"

@interface InfoFrameController : UIView {
    ConfigDataSource *configDatas;
    //UIImage *UIimage;
    id ViewBoxDelegate;
    
    UIButton *closeBt;
    int width;
    
    UIWebView *iWebView;
    int panoId;
    NSString *panoListUrl;
    NSString *curentProjectId;
}

@property(nonatomic, assign) id ViewBoxDelegate;
@property(assign, nonatomic) int panoId;
@property(assign, nonatomic) NSString *curentProjectId;;
@property(retain, nonatomic)UIButton *closeBt;

-(void) setCloseButton;


@end
