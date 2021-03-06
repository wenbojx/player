//
//  MapViewController.h
//  PanoPlayer
//
//  Created by 李文博 on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTImageMapView.h"

@interface MapViewController : UIViewController <MTImageMapDelegate>{
    NSArray *coordsData;
    NSString *responseData;
    UIProgressView *imageProgressIndicator;
    UILabel *loading;
    int panoId;
    IBOutlet UIButton *reflashButton;
}

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
-(IBAction)onClickButton:(id)sender;

@end




