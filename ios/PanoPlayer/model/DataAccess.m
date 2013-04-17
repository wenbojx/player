//
//  DataAccess.m
//  AOWaterView
//
//  Created by akria.king on 13-4-10.
//  Copyright (c) 2013年 akria.king. All rights reserved.
//

#import "DataAccess.h"
#import "DataInfo.h"
@implementation DataAccess
-(NSDictionary *)getDicByPlist{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"dataList" ofType:@"plist"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    return dic;
}
//获取基础联系列表
-(NSMutableArray *)getDateArray{
    NSDictionary *dic = [self getDicByPlist];
    NSMutableArray *imageList = [[NSMutableArray alloc]init];
    NSMutableArray *dicArray = [dic objectForKey:@"imageList"];
   
    for (NSDictionary *vdic in dicArray) {
        DataInfo *data=[[DataInfo alloc]init];
        NSNumber *hValue=[vdic objectForKey:@"height"];

        data.height= hValue.floatValue;
        NSNumber *wValue=[vdic objectForKey:@"width"];
        
        data.width= wValue.floatValue;
        data.url = [vdic objectForKey:@"url"];
        data.title=[vdic objectForKey:@"title"];
        data.mess=[vdic objectForKey:@"mess"];
        [imageList addObject:data];
    }
    return imageList;

}
@end
