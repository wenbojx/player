//
//  InfoViewController.h
//  PanoPlayer
//
//  Created by 李文博 on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"

@interface InfoViewController : UIViewController{
    UIWebView *iWebView;
    int panoId;
    NSString *panoListUrl;
}

@end
