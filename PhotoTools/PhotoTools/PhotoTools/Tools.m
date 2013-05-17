//
//  Tools.m
//  PhotoTools
//
//  Created by yiluhao on 13-5-17.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import "Tools.h"

@implementation Tools

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSString *)getFileSavePath:(NSString *)fileName{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filePath=[path stringByAppendingPathComponent:fileName];   //获取路径
 
    return filePath;
}
//保存文本文件
-(void)SaveStringToFile:(NSString *)filePath content:(NSString *)content{
    if (content == NULL || content == nil || [content isEqualToString:@""]) {
        return;
    }
    NSError *error; 
    
    //NSFileManager *fileManager = [NSFileManager defaultManager];
	
    [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

//追加的方式保存文本
-(void)AppendStringToFile:(NSString *)filePath content:(NSString *)content{
    if (content == NULL || content == nil || [content isEqualToString:@""]) {
        return;
    }
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    
	if (fileExists) {//如果不存在
		NSString *exitContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        content = [content stringByAppendingString:exitContent];
	}
    
    [self SaveStringToFile:filePath content:content];
}

@end
