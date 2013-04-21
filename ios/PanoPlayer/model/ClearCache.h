//
//  ClearCache.h
//  PanoPlayer
//
//  Created by yiluhao on 13-4-21.
//
//

#import <Foundation/Foundation.h>

@interface ClearCache : NSObject{
    NSFileManager *fileManager;
}

-(void)cleanConfigCache;
-(void)cleanDataCache;

@end
