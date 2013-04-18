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
#import "ListFrameController.h"
#import "InfoFrameController.h"
#import "MapFrameController.h"
#import "AVFoundation/AVFoundation.h"

@interface PlayerViewController : UIViewController <PLViewDelegate>{
    PLView *plView;
    PLCubicPanorama *cubicPanorama;
    NSString *curentPanoID;
    NSString *curentProjectId;
    
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
    Boolean isAnimation;
    float lookAtX;
    float lookAtY;
    int animationWaitTime;
    int animationMoveTime;

    //UIBarButtonItem *rightItemBar;
    NSTimer *aniTimer;
    NSString *level;
    IBOutlet UILabel *logo;
    IBOutlet UIButton *btList;//场景列表按钮
    IBOutlet UIButton *btInfo;//简介按钮
    IBOutlet UIButton *btMap;//地图按钮
    IBOutlet UIButton *btRround;//自动旋转
    
    IBOutlet UIButton * btMusic;//播放音乐
    IBOutlet UIButton * playPause;//播放暂停
    //定义一个声音的播放器
    AVAudioPlayer *musicPlayer;
}

//@property(retain, nonatomic)NSString *panoId;
//@property(nonatomic, retain)PLCubicPanorama *cubicPanorama;
@property(nonatomic, assign) IBOutlet UILabel *logo;
@property(nonatomic, assign) IBOutlet UIButton *btList;
@property(nonatomic, assign) IBOutlet UIButton *btInfo;
@property(nonatomic, assign) IBOutlet UIButton *btMap;
@property(nonatomic, assign) IBOutlet UIButton *btRround;
@property(nonatomic, assign) IBOutlet UIButton *btMusic;

@property(assign, nonatomic)ListFrameController *listFrame;
@property(assign, nonatomic)InfoFrameController *infoFrame;
@property(assign, nonatomic)MapFrameController *mapFrame;

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
//@property(assign,nonatomic)UIBarButtonItem *rightItemBar;



@property(assign, nonatomic)UIImageView *imageView;
@property(assign, nonatomic)UIButton *closeBt;

@property(assign, nonatomic)AboveViewController *aboveView;

//@property(retain, nonatomic)PLCubicPanorama *cubicPanorama;

//- (IBAction)rightItemClick:(id)sender;
- (IBAction)btListClick:(id)sender;
- (IBAction)btInfoClick:(id)sender;
- (IBAction)btMapClick:(id)sender;
- (IBAction)btRoundClick:(id)sender;
- (IBAction)btMusicClick:(id)sender;

-(IBAction)playSoundPressed:(id)pressed;


- (void)setAnimation;


-(NSString *)getPanoInfoFromUrl:(NSString *)url;
-(void)startDownload:(NSString *)panoId;
//-(void)downLoadImage:(NSString *)url face:(NSString *)face;
//-(void)initPlayer:(NSString *)face faceImage:(UIImage *)faceImage;
-(void)displayPano;
-(void)addHotspot:(NSString *)hotspotId linkSceneId:(NSString *)linkSceneId tilt:(NSString *)tilt pan:(NSString *)pan transform:(NSString *)transform type:(NSString *)type filePath:(NSString *)filePath;
-(void)changeLoadState:(int)state;

@end
