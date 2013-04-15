//
//  ListFrameController.h
//  PanoPlayer
//
//  Created by yiluhao on 13-4-15.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HomeTableCell.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"


@interface ListFrameController : UIView <UITableViewDataSource,UITableViewDelegate>{
    //UIImage *UIimage;
    UIButton *closeBt;
    int width;
    //UIActivityIndicatorView *progressInd;
    UIProgressView *imageProgressIndicator;
    
    NSMutableArray *panoList;
    NSString *panoListUrl;
    int panoId;
    UITableView *tableView;
    
}

@property(retain, nonatomic) NSMutableArray *panoList;
@property(retain, nonatomic) NSString *panoListUrl;
@property(retain, nonatomic)UIButton *closeBt;

@property(nonatomic, assign) UIProgressView *imageProgressIndicator;


- (void)addPano:(NSString *)panoId thumbImage:(NSString *)thumbImage panotitle:(NSString *)panoTitle photoTime:(NSString *)photoTime;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)getJsonFromUrl:(NSString *)url;

-(void) setCloseButton;

@end
