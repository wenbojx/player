//
//  DownLoad.m
//  PanoPlayer
//
//  Created by yiluhao on 13-5-5.
//
//

#import "DownLoad.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@implementation DownLoad

@synthesize updateDelegate;
@synthesize currentProjectId;
@synthesize hasExitPage;
@synthesize stopDown;

-(id)init{
    self = [super init];
    if (self){
        hasExitPage = false;
        stopDown = false;
        configFile = [[ConfigFile alloc] init];
    }
    return self;
}
-(void) startDownLoad{

    [NSThread detachNewThreadSelector:@selector(DownloadThread:) toTarget:self withObject:nil];
}

-(void)updateRightItem:(NSMutableDictionary *)datas{
    if (!hasExitPage) {
        [updateDelegate updateRightItem:datas];
    }
    return;
}

-(void) DownloadThread:(id)sender{
    NSString *pid = currentProjectId;
    
    NSLog(@"pid=%@", pid);
    if(pid == nil){
        return ;
    }
    pool = [[NSAutoreleasePool alloc] init];
    NSDictionary *panoFileList = [configFile getProjectFiles:pid];
    NSMutableArray *fileList = [panoFileList objectForKey:@"files"];

    NSString  *totalSize = [panoFileList objectForKey:@"size"];
    //NSLog(@"totalSize=%@", totalSize);
    [self AddPanosDownList:pid panoInfo:fileList];
    
    [self AddProjectDownList:pid size:totalSize];
    
    [self startDownLoads];
    [pool release];
}

-(void)restetProjectState{
    [self ChangeProjectDownConfig:@"all" gstate:@"4" gfinishSize:nil delete:false];
}

-(void) startDownLoads{
    NSMutableArray *projects = [self GetProjectDownList];
    
    if (projects == nil) {
        return;
    }
    
    Boolean hasDownLoading = false;
    NSString *projectId = @"";
    NSString *fristStateOne = @""; //第一个出现的状态为1的项目
    Boolean isFristStateOne = true;//是否第一个状态为1的项目
    
    for (int i=0; i<projects.count; i++) {
        NSDictionary  *tmp = [projects objectAtIndex:i];
        NSString *state = [tmp objectForKey:@"state"];

        if (isFristStateOne && [state isEqualToString:@"1"]) {
            fristStateOne = [tmp objectForKey:@"pid"];
            isFristStateOne = false;
        }
        if ([state isEqualToString:@"2"] || [state isEqualToString:@"5"]) {  //2,5下载中
            hasDownLoading = true;
            projectId = [tmp objectForKey:@"pid"];
        }
        
    }
    
    //如果没有下载中的项目则从第一个状态为1的开始
    if (!hasDownLoading) {
        projectId = fristStateOne;
        //[self ChangeProjectDownConfig:projectId gstate:@"2" gfinishSize:nil];
    }
    if ( projectId==nil || [projectId isEqualToString:@""]) {
        return;
    }
    [self DownPanosFile:projectId];

}

-(void)DownPanosFile:(NSString *)projectId{
    //NSLog(@"projectId=%@", projectId);
    [self ChangeProjectDownConfig:projectId gstate:@"5" gfinishSize:nil delete:false];
    
    NSDictionary *panoFileList = [self GetPanoDownList:projectId];
    //NSLog(@"panoFileList=%@", panoFileList);
    
    NSArray *keys;
    int i, count;
    id key;
    NSDictionary *value;
    
    keys = [panoFileList allKeys];
    Tools *tools = [[Tools alloc]init];
    keys = [tools ArraySort:keys];
    //keys = [keys sortedArrayUsingSelector:@selector(compare:)];
    
    //NSLog(@"keys=%@", keys);
    
    count = [keys count];
    for (i = 0; i < count; i++){
        value = [[NSDictionary alloc] init];
        key = [keys objectAtIndex: i];
        value = [panoFileList objectForKey: key];
        NSString *state = [value objectForKey:@"state"];
        if ([state isEqualToString:@"3"]) {
            continue;
        }
        NSString *url = [value objectForKey:@"url"];
        if (url == nil || [url isEqualToString:@""]) {
            continue;
        }
        NSString *size = [value objectForKey:@"size"];
        size = [NSString stringWithFormat:@"%@", size];
        Boolean getFileFlag = [self GetFile:url projectId:projectId];
        if (stopDown) {
            //[pool release];
            return;
        }
        //NSLog(@"key=%@", key);
        
        if (getFileFlag) {
            //改变下载项目的size
            [self ChangeProjectDownConfig:projectId gstate:nil gfinishSize:size delete:false];

            NSMutableDictionary *updateData = [[NSMutableDictionary alloc] init];
            [updateData setValue:ctotalSize forKey:@"totalSize"];
            [updateData setValue:cfinishSize forKey:@"finishSize"];
            [updateData setValue:projectId forKey:@"projectId"];
            
            [self performSelectorOnMainThread:@selector(updateRightItem:) withObject:updateData waitUntilDone:NO];
            
        }
    }
    [self ChangeProjectDownConfig:projectId gstate:nil gfinishSize:nil delete:true];
    NSString *panoConfigFilePath = [self filePanoPath:projectId];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:panoConfigFilePath error:NULL];
    
    NSLog(@"download finish");
}

-(Boolean)GetFile:(NSString *)url projectId:(NSString *)projectId{
    if(url == nil || [url isEqualToString:@""]){
        return false;
    }
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    Tools *tools = [[Tools alloc] init];
    NSString *fileCachePath = [tools getPanoFileCachePath:projectId];
    
    [cache setStoragePath:fileCachePath];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    [request setDownloadCache:cache];
    
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [cache setShouldRespectCacheControlHeaders:NO];
    //[]
    ConfigDataSource *configDatas = [[ConfigDataSource alloc] init];
    
    int cacheDay = [configDatas getConfigCache];
    int days = 60*60*24*cacheDay;
    
    [request setSecondsToCache:days]; //30
    //NSLog(@"%d", days);
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        return true;
    }else {
        return false;
    }

}

-(void)ChangeProjectDownConfig:(NSString *)projectId gstate:(NSString *)gstate gfinishSize:(NSString *)gfinishSize delete:(Boolean)delete{
    
    NSString *filePath = [self fileProjectPath];
    NSMutableArray *projectInfo = [[NSMutableArray alloc] init];
    NSMutableArray *downloadInfo = [self GetProjectDownList];
    
    if (downloadInfo !=nil) {
        for (int i=0; i<downloadInfo.count; i++) {
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            NSDictionary  *tmp = [downloadInfo objectAtIndex:i];
            
            NSString *epid = [tmp objectForKey:@"pid"];
            NSString *state = [tmp objectForKey:@"state"]; //1未开始， 2下载未完成 3下载完 4暂停 5正在下载
            NSString *size = [tmp objectForKey:@"totalSize"];
            NSString *finishSize = [tmp objectForKey:@"finishSize"];
            
            
            if ([projectId isEqualToString:@"all"]) {
                state = gstate;
            }
            else{
                if (![projectId isEqualToString:epid]) {
                    [data setObject:state forKey:@"state"];
                    [data setObject:finishSize forKey:@"finishSize"];
                
                }else{
                    if (delete) {
                        continue;
                    }
                    if (gstate!=nil && ![gstate isEqualToString:@""]) {
                        state = gstate;
                    }
                    if (gfinishSize!=nil && ![gfinishSize isEqualToString:@""]) {
                        int finished = [finishSize intValue]+[gfinishSize intValue];
                        //NSLog(@"finished=%d", finished);
                        finishSize = [NSString stringWithFormat:@"%d", finished];
                        cfinishSize = finishSize;
                        ctotalSize = size;
                    }
                
                }
            }
            [data setObject:epid forKey:@"pid"];
            [data setObject:size forKey:@"totalSize"];
            [data setObject:finishSize forKey:@"finishSize"];
            [data setObject:state forKey:@"state"];
            [projectInfo addObject:data];
        }
    }
    //NSLog(@"projectInfo=%@",projectInfo);
    [projectInfo writeToFile:filePath atomically:YES];
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
- (void) getWrong:(NSString*)str{
    NSString *msg = [NSString stringWithFormat:@"%@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
-(void)AddProjectDownList:(NSString *)pid size:(NSString *)size{
    if (pid == nil) {
        return;
    }
    NSLog(@"size=%@", size);
    NSString *filePath = [self fileProjectPath];
    NSMutableArray *projectInfo = [[NSMutableArray alloc] init];
    NSMutableArray *downloadInfo = [self GetProjectDownList];
    if(downloadInfo == nil){
        //1. 创建一个plist文件
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    if (downloadInfo == nil) {
        [self getWrong:@"获取数据失败，请检查您的网络"];
        return;
    }
    //NSLog(@"downloadInfo=%@",downloadInfo);
        for (int i=0; i<downloadInfo.count; i++) {
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            NSDictionary  *tmp = [downloadInfo objectAtIndex:i];
            NSString *epid = [tmp objectForKey:@"pid"];
            
            if (![pid isEqualToString:epid]) {
                NSString *state = [tmp objectForKey:@"state"]; //1未开始， 2下载中 3下载完 4暂停
                NSString *size = [tmp objectForKey:@"totalSize"];
                NSString *finishSize = [tmp objectForKey:@"finishSize"];
                if (size == nil) {
                    size = @"0";
                }
                if (finishSize == nil) {
                    finishSize = @"0";
                }
                
                [data setObject:epid forKey:@"pid"];
                
                [data setObject:size forKey:@"totalSize"];
                [data setObject:finishSize forKey:@"finishSize"];
                [data setObject:state forKey:@"state"];
                [projectInfo addObject:data];
            }
        }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    // 1未开始， 2下载中 3下载完4暂停
    [data setObject:pid forKey:@"pid"];
    [data setObject:size forKey:@"totalSize"];
    [data setObject:@"0" forKey:@"finishSize"];
    [data setObject:[NSString stringWithFormat:@"1"] forKey:@"state"];
    [projectInfo addObject:data];
    
    [projectInfo writeToFile:filePath atomically:YES];
    //NSLog(@"projectInfo====%@", projectInfo);
}



-(NSString *)filePanoPath:(NSString *)pid{
    NSString *fileName = [NSString stringWithFormat:@"panoDown-%@.plist",pid];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filePath=[path stringByAppendingPathComponent:fileName];
    return filePath;
}
-(NSDictionary *)GetPanoDownList:(NSString *)pid{
    NSString *filePath = [self filePanoPath:pid];
    //读文件
    NSDictionary* downloadInfo = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    //NSLog(@"info=%@", downloadInfo);
    return downloadInfo;
}
-(void)AddPanosDownList:(NSString *)pid panoInfo:(NSMutableArray *)panoInfo{
    if (pid == nil || panoInfo == nil) {
        return;
    }
    NSString *filePath = [self filePanoPath:pid];
        
    [panoInfo writeToFile:filePath atomically:YES];
}







/*
-(NSString *)getProjectSize:(NSString *)pid{
    if (pid==nil) {
        return @"0";
    }
    //NSString *size = [configFile getProjectSize:pid];
    return size;
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
    int j=1;
    if (![mapUrl isEqualToString:@"nomap"] && ![mapUrl isEqualToString:@""]) {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setObject:[NSString stringWithFormat:@"%d", j] forKey:@"id"];
        [data setObject:mapUrl forKey:@"map"];
        //0未下载1下载中2下载完
        [data setObject:@"0" forKey:@"state"];
        [downloadFiles addObject:data];
        j++;
    }
    
    //NSLog(@"panoMap=%@", panoMap);
    for (int i=0; i<panoList.count; i++) {
        NSDictionary  *tmp = [panoList objectAtIndex:i];
        NSString *panoid = [tmp objectForKey:@"pid"];
        NSMutableArray *panoInfo = [configFile getPanoConfig:panoid projectId:pid];

        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        
        NSDictionary  *musicTmp = [panoInfo objectAtIndex:1];
        NSString *musicUrl = [musicTmp objectForKey:@"music"];
        if (musicUrl != nil && ![musicUrl isEqualToString:@""]) {
            [data setObject:musicUrl forKey:@"music"];
            [data setObject:@"0" forKey:@"state"];
            [data setObject:[NSString stringWithFormat:@"%d", j] forKey:@"id"];
            j++;
            [downloadFiles addObject:data];
        }
        NSDictionary  *faceTmp = [panoInfo objectAtIndex:2];
        
        data = [[NSMutableDictionary alloc] init];
        NSString *s_f = [faceTmp objectForKey:@"s_f"];
        [data setObject:s_f forKey:@"s_f"];
        [data setObject:@"0" forKey:@"state"];
        [data setObject:[NSString stringWithFormat:@"%d", j] forKey:@"id"];
        j++;
        [downloadFiles addObject:data];
        
        data = [[NSMutableDictionary alloc] init];
        NSString *s_l = [faceTmp objectForKey:@"s_l"];
        [data setObject:s_l forKey:@"s_l"];
        [data setObject:@"0" forKey:@"state"];
        [data setObject:[NSString stringWithFormat:@"%d", j] forKey:@"id"];
        j++;
        [downloadFiles addObject:data];
        
        data = [[NSMutableDictionary alloc] init];
        NSString *s_r = [faceTmp objectForKey:@"s_r"];
        [data setObject:s_r forKey:@"s_r"];
        [data setObject:@"0" forKey:@"state"];
        [data setObject:[NSString stringWithFormat:@"%d", j] forKey:@"id"];
        j++;
        [downloadFiles addObject:data];
        
        data = [[NSMutableDictionary alloc] init];
        NSString *s_b = [faceTmp objectForKey:@"s_b"];
        [data setObject:s_b forKey:@"s_b"];
        [data setObject:@"0" forKey:@"state"];
        [data setObject:[NSString stringWithFormat:@"%d", j] forKey:@"id"];
        j++;
        [downloadFiles addObject:data];
        
        data = [[NSMutableDictionary alloc] init];
        NSString *s_u = [faceTmp objectForKey:@"s_u"];
        [data setObject:s_u forKey:@"s_u"];
        [data setObject:@"0" forKey:@"state"];
        [data setObject:[NSString stringWithFormat:@"%d", j] forKey:@"id"];
        j++;
        [downloadFiles addObject:data];
        
        data = [[NSMutableDictionary alloc] init];
        NSString *s_d = [faceTmp objectForKey:@"s_d"];
        [data setObject:s_d forKey:@"s_d"];
        [data setObject:@"0" forKey:@"state"];
        [data setObject:[NSString stringWithFormat:@"%d", j] forKey:@"id"];
        j++;
        [downloadFiles addObject:data];
    }
    //NSLog(@"panoInfo=%@", downloadFiles);
    return downloadFiles;
}
 */

@end
