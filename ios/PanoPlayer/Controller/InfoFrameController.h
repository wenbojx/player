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

@interface InfoFrameController : UIView {
    //UIImage *UIimage;
    UIButton *closeBt;
    int width;
    
    UIWebView *iWebView;
    int panoId;
    NSString *panoListUrl;
}
@property(assign, nonatomic) int panoId;
@property(retain, nonatomic)UIButton *closeBt;

-(void) setCloseButton;


@end
