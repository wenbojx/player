//
//  ConfigFile.h
//  PanoPlayer
//
//  Created by yiluhao on 13-5-5.
//
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "ConfigDataSource.h"
#import "Tools.h"

@interface ConfigFile : NSObject{
    
}

-(NSMutableArray *)getProjectConfig:(NSString *)pid;
-(NSMutableArray *)getPanoConfig:(NSString *)pid;
-(NSMutableArray *)getPanoMap:(NSString *)pid;

@end
