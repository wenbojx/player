//
//  PlayerViewController.h
//  PanoPlayer
//
//  Created by 李文博 on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLView.h"
#import "AboveViewController.h"

@interface PlayerViewController : UIViewController <PLViewDelegate>{
    PLView *plView;
    NSMutableArray *hotspots;
    //PLCubicPanorama *cubicPanorama;
    UIImage *faceSL;
    UIImage *faceSR;
    UIImage *faceSF;
    UIImage *faceSB;
    UIImage *faceSD;
    UIImage *faceSU;
    //UIProgressView *imageProgressIndicator;
    UIProgressView *imageProgressIndicator;
    UILabel *loading;
    BOOL failed;
    //PLCubicPanorama *cubicPanorama;
    Boolean finishDownLoad;
    NSString *panoTitle;
    Boolean alertOnce;
}

//@property(retain, nonatomic)NSString *panoId;
//@property(nonatomic, retain)PLCubicPanorama *cubicPanorama;
@property(nonatomic, assign) UIProgressView *imageProgressIndicator;
@property(retain, nonatomic)NSMutableArray *hotspots;
@property(retain, nonatomic)UIImage *faceSL;
@property(retain, nonatomic)UIImage *faceSR;
@property(retain, nonatomic)UIImage *faceSF;
@property(retain, nonatomic)UIImage *faceSB;
@property(retain, nonatomic)UIImage *faceSD;
@property(retain, nonatomic)UIImage *faceSU;
@property(retain, nonatomic)UILabel *loading;
@property(retain, nonatomic)NSString *panoTitle;
@property(assign, nonatomic)Boolean alertOnce;

@property(assign, nonatomic)UIImageView *imageView;
@property(assign, nonatomic)UIButton *closeBt;

@property(assign, nonatomic)AboveViewController *aboveView;

//@property(retain, nonatomic)PLCubicPanorama *cubicPanorama;


-(NSString *)getPanoInfoFromUrl:(NSString *)url;
-(void)startDownload:(NSString *)panoId;
//-(void)downLoadImage:(NSString *)url face:(NSString *)face;
//-(void)initPlayer:(NSString *)face faceImage:(UIImage *)faceImage;
-(void)displayPano;
-(void)addHotspot:(NSString *)hotspotId linkSceneId:(NSString *)linkSceneId tilt:(NSString *)tilt pan:(NSString *)pan transform:(NSString *)transform;
-(void)changeLoadState:(int)state;

@end
