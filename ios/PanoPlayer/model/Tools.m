//
//  Tools.m
//  PanoPlayer
//
//  Created by yiluhao on 13-5-5.
//
//

#import "Tools.h"

@implementation Tools

-(id)init{
    self = [super init];
    if (self){
        
    }
    return self;
}

-(NSString *)getPanoFileCachePath:(NSString *)pid{
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    cachePath = [cachePath stringByAppendingPathComponent:@"Caches"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:cachePath];
	
	if (!fileExists) {//如果不存在则创建
		[fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
	}
    if (pid !=nil ) {
        cachePath = [cachePath stringByAppendingPathComponent:pid];
        
        if (!fileExists) {//如果不存在则创建
            [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return cachePath;
}

@end
