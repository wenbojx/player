//
//  DownLoad.m
//  PanoPlayer
//
//  Created by yiluhao on 13-5-5.
//
//

#import "DownLoad.h"


@implementation DownLoad

-(id)init{
    self = [super init];
    if (self){
        configFile = [[ConfigFile alloc] init];
    }
    return self;
}
-(NSString *)fileProjectPath{
    NSString *fileName = @"projectDownload.plist";
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filePath=[path stringByAppendingPathComponent:fileName];
    return filePath;
}
-(NSMutableArray *)GetProjectDownList{
    NSString *filePath = [self fileProjectPath];
    //读文件
    NSMutableArray* downloadInfo = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    return downloadInfo;
}

-(void)AddProjectDownList:(NSString *)pid{
    if (pid == nil) {
        return;
    }
    NSString *filePath = [self fileProjectPath];
    NSMutableArray *projectInfo = [[NSMutableArray alloc] init];
    NSMutableArray *downloadInfo = [self GetProjectDownList];
    if(downloadInfo == nil){
        //1. 创建一个plist文件
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    if (downloadInfo !=nil) {
        for (int i=0; i<downloadInfo.count; i++) {
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            NSDictionary  *tmp = [downloadInfo objectAtIndex:i];
            NSString *epid = [tmp objectForKey:@"pid"];
            if ([pid isEqualToString:epid]) {
            }
            else{
                NSString *state = [tmp objectForKey:@"state"]; //1下载中， 2下载完
                [data setObject:epid forKey:@"pid"];
                [data setObject:state forKey:@"state"];
                [projectInfo addObject:data];
            }
        }
    }
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    // 1下载中， 2下载完
    [data setObject:pid forKey:@"pid"];
    [data setObject:[NSString stringWithFormat:@"1"] forKey:@"state"];
    [projectInfo addObject:data];
    
    [projectInfo writeToFile:filePath atomically:YES];
    //NSLog(@"projectInfo====%@", projectInfo);
}

-(NSString *)filePanoPath:(NSString *)pid{
    NSString *fileName = [NSString stringWithFormat:@"panoDownload%@.plist",pid];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filePath=[path stringByAppendingPathComponent:fileName];
    return filePath;
}
-(NSMutableArray *)GetPanoDownList:(NSString *)pid{
    NSString *filePath = [self filePanoPath:pid];
    //读文件
    NSMutableArray* downloadInfo = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    return downloadInfo;
}
-(void)AddPanosDownList:(NSString *)pid panoInfo:(NSMutableArray *)panoInfo{
    if (pid == nil || panoInfo == nil) {
        return;
    }
    NSString *filePath = [self filePanoPath:pid];
        
    [panoInfo writeToFile:filePath atomically:YES];
}

-(void)downLoadProjectFile:(NSString *)pid{
    if(pid == nil){
        return ;
    }
    [self AddProjectDownList:pid];
    NSMutableArray *panoFileList = [self CountDownLoadFile:pid];
    [self AddPanosDownList:pid panoInfo:panoFileList];
}

-(NSMutableArray *)CountDownLoadFile:(NSString *)pid{
    if(pid == nil){
        return nil;
    }
    //NSMutableArray *projectInfo = [self GetProjectDownList];
    //NSLog(@"projectInfo=%@", projectInfo);
    NSMutableArray *downloadFiles = [[NSMutableArray alloc] init];
    //获取项目配置文件
    NSMutableArray *panoList = [configFile getProjectConfig:pid];
    NSMutableArray *panoMap = [configFile getPanoMap:pid];
    NSDictionary  *tmp = [panoMap objectAtIndex:0];
    NSString *mapUrl = [tmp objectForKey:@"mapUrl"];
    if (![mapUrl isEqualToString:@"nomap"] && ![mapUrl isEqualToString:@""]) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:mapUrl forKey:@"map"];
        //0未下载1下载中2下载完
        [data setObject:@"0" forKey:@"state"];
        [downloadFiles addObject:data];
    }

    //NSLog(@"panoMap=%@", panoMap);
    for (int i=0; i<panoList.count; i++) {
        NSDictionary  *tmp = [panoList objectAtIndex:i];
        NSString *panoid = [tmp objectForKey:@"pid"];
        NSMutableArray *panoInfo = [configFile getPanoConfig:panoid];

        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        
        NSDictionary  *musicTmp = [panoInfo objectAtIndex:1];
        NSString *musicUrl = [musicTmp objectForKey:@"music"];
        if (musicUrl != nil && ![musicUrl isEqualToString:@""]) {
            [data setObject:musicUrl forKey:@"music"];
            [data setObject:@"0" forKey:@"state"];
            [downloadFiles addObject:data];
        }
        NSDictionary  *faceTmp = [panoInfo objectAtIndex:2];
        
        data = [[NSMutableDictionary alloc] init];
        NSString *s_f = [faceTmp objectForKey:@"s_f"];
        [data setObject:s_f forKey:@"s_f"];
        [data setObject:@"0" forKey:@"state"];
        [downloadFiles addObject:data];
        
        data = [[NSMutableDictionary alloc] init];
        NSString *s_l = [faceTmp objectForKey:@"s_l"];
        [data setObject:s_l forKey:@"s_l"];
        [data setObject:@"0" forKey:@"state"];
        [downloadFiles addObject:data];
        
        data = [[NSMutableDictionary alloc] init];
        NSString *s_r = [faceTmp objectForKey:@"s_r"];
        [data setObject:s_r forKey:@"s_r"];
        [data setObject:@"0" forKey:@"state"];
        [downloadFiles addObject:data];
        
        data = [[NSMutableDictionary alloc] init];
        NSString *s_b = [faceTmp objectForKey:@"s_b"];
        [data setObject:s_b forKey:@"s_b"];
        [data setObject:@"0" forKey:@"state"];
        [downloadFiles addObject:data];
        
        data = [[NSMutableDictionary alloc] init];
        NSString *s_u = [faceTmp objectForKey:@"s_u"];
        [data setObject:s_u forKey:@"s_u"];
        [data setObject:@"0" forKey:@"state"];
        [downloadFiles addObject:data];
        
        data = [[NSMutableDictionary alloc] init];
        NSString *s_d = [faceTmp objectForKey:@"s_d"];
        [data setObject:s_d forKey:@"s_d"];
        [data setObject:@"0" forKey:@"state"];
        [downloadFiles addObject:data];
    }
    //NSLog(@"panoInfo=%@", downloadFiles);
    return downloadFiles;
}

@end
