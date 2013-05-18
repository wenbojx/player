//
//  GpsDatas.m
//  PhotoTools
//
//  Created by yiluhao on 13-5-17.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import "GpsDatas.h"

@implementation GpsDatas
- (id)init
{
    self = [super init];
    if (self) {
        [self SetFileName];
        tools = [[Tools alloc]init];
        filePath = [tools getFileSavePath:fileName];
        saveTime = 1;
        content = @"";
    }
    return self;
}

-(void)SetFileName{
    //获取当前时间
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd-hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    fileName = [date stringByAppendingFormat:@".geo"];
}

-(NSString *)GetFileName{
    return fileName;
}
-(NSString *)GetFilePath:(NSString *)name{
    return @"";
}

-(void)SaveDatas:(double)lat lng:(double)lng alti:(float)alti speed:(float)speed degree:(float)degree{
    if (lat==0 || lng==0) {
        return;
    }
    NSString* timeStr;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm:ss"];
    timeStr = [formatter stringFromDate:[NSDate date]];

    content = [content stringByAppendingFormat:@"%@|%f|%f|%f|%f|%f;", timeStr,lat,lng,alti,speed,degree];

    if (saveTime >=5) {
        [tools AppendStringToFile:filePath content:content];
        NSLog(@"content=%@", content);
        content = @"";
        saveTime = 1;
    }
    saveTime ++;
}


@end




