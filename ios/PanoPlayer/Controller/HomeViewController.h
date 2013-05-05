//
//  HomeViewController.h
//  PanoPlayer
//
//  Created by 李文博 on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "MosaicView.h"
#import "MosaicViewDelegateProtocol.h"
#import "PanoListMosaicDatasource.h"
#import "ConfigDataSource.h"
#import "Tools.h"
#import "DownLoad.h"


@interface HomeViewController : UIViewController <MosaicViewDelegateProtocol>{
    
    ConfigDataSource *configDatas;
    __weak IBOutlet MosaicView *mosaicView;
    //MosaicView *mosaicView;
    PanoListMosaicDatasource *datasSource;
    
    UIImageView *snapshotBeforeRotation;
    UIImageView *snapshotAfterRotation;
    NSMutableArray *panoList;
    NSArray *pagePanos;
    
    NSString *projectListUrl;
    NSString *currentProjectId;
    int pageSize;
    int curentPage;
    int totalPage;
    int totalNum;
    int nextPage;
    Boolean isDownLoading;
    //int panoId;
    //UILabel *topView;
    UIBarButtonItem *rightItemBar;

}

@property(retain, nonatomic) NSMutableArray *panoList;
@property(retain, nonatomic) NSArray *pagePanos;
@property(assign, nonatomic) int totalNum;
@property(retain, nonatomic) NSString *projectListUrl;


//- (void)addPano:(NSString *)panoId thumbImage:(NSString *)thumbImage panotitle:(NSString *)panoTitle width:(NSString *)width height:(NSString *)height size:(NSString *)size photoTime:(NSString *)photoTime;

- (NSString *)getJsonFromUrl:(NSString *)url;


@end





