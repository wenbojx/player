//
//  MapFrameController.h
//  PanoPlayer
//
//  Created by yiluhao on 13-4-15.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MTImageMapView.h"

@interface MapFrameController : UIView <MTImageMapDelegate>{

    UIButton *closeBt;
    int width;

    NSArray *coordsData;
    NSString *responseData;
    UIActivityIndicatorView *loading;
    int ProjectId;
    NSString *panoId;
    int layoutWidh;
    int layoutHeight;
}

@property(retain, nonatomic)UIButton *closeBt;

-(void) setCloseButton;



@property(nonatomic, retain) NSMutableArray *linkScene;

@property(nonatomic, assign)UIActivityIndicatorView *loading;
@property (nonatomic, assign) UIScrollView *viewScrollStub;
@property (nonatomic, assign) MTImageMapView *viewImageMap;
@property (nonatomic, retain) NSArray *stateNames;
@property(nonatomic, retain) NSArray *coordsData;
@property(nonatomic, retain) NSString *responseData;



-(NSString *)getPanoMapFromUrl:(NSString *)url;
-(void)displayMap:(UIImage *)mapImage coords:(NSArray *)coords;
-(void)downLoadImage:(NSString *)url;
-(UIImage *)addImageLogo:(UIImage *)img waterMark:(UIImage *)logo left:(float)left top:(float)top;

-(void) setPanoId:(NSString *)pid;

@end
