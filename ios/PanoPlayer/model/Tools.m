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

//数字排序
-(NSArray *)ArraySort:(NSArray *)datas{
    if (datas == nil) {
        return  nil;
    }
    NSComparator finderSort = ^(id string1,id string2){
        
        if ([string1 integerValue] > [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([string1 integerValue] < [string2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    return [datas sortedArrayUsingComparator:finderSort];
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
