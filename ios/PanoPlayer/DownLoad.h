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
}

-(void)downLoadProjectFile:(NSString *)pid;
-(NSMutableArray *)CountDownLoadFile:(NSString *)pid;
-(NSMutableArray *)GetProjectDownList;

@end
