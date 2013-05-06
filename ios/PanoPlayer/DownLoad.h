//
//  DownLoad.h
//  PanoPlayer
//
//  Created by yiluhao on 13-5-5.
//
//

#import <Foundation/Foundation.h>
#import "ConfigFile.h"

@interface DownLoad : NSObject{
    ConfigFile *configFile;
    NSString *currentProjectId;
    id updateDelegate;
    NSString *ctotalSize;
    NSString *cfinishSize;
    Boolean hasExitPage;
    Boolean stopDown;
    NSAutoreleasePool *pool;
}
@property(nonatomic, assign) Boolean stopDown;
@property(nonatomic, assign) Boolean hasExitPage;
@property(nonatomic, assign) NSString *currentProjectId;

@property(nonatomic, assign) id updateDelegate;

//-(NSMutableArray *)CountDownLoadFile:(NSString *)pid;
-(NSMutableArray *)GetProjectDownList;
-(NSDictionary *)GetPanoDownList:(NSString *)pid;
-(void)startDownLoad;
-(void)restetProjectState;//重置所有项目状态

@end
