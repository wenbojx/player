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
    UIProgressView *imageProgressIndicator;
    UILabel *loading;
    int panoId;
    
}

@property(retain, nonatomic)UIButton *closeBt;

-(void) setCloseButton;



@property(nonatomic, retain) NSMutableArray *linkScene;

@property(nonatomic, assign) UIProgressView *imageProgressIndicator;
@property(nonatomic, assign)UILabel *loading;
@property (nonatomic, assign) IBOutlet UIScrollView         *viewScrollStub;
@property (nonatomic, assign) IBOutlet MTImageMapView       *viewImageMap;
@property (nonatomic, retain)          NSArray              *stateNames;
@property(nonatomic, retain) NSArray *coordsData;
@property(nonatomic, retain) NSString *responseData;
@property(retain, nonatomic) IBOutlet UIButton *reflashButton;



-(NSString *)getPanoMapFromUrl:(NSString *)url;
-(void)displayMap:(UIImage *)mapImage coords:(NSArray *)coords;
-(void)downLoadImage:(NSString *)url;
-(UIImage *)addImageLogo:(UIImage *)img waterMark:(UIImage *)logo left:(float)left top:(float)top;

@end
