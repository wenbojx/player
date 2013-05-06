//
//  ConfigFile.m
//  PanoPlayer
//
//  Created by yiluhao on 13-5-5.
//
//

#import "ConfigFile.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@implementation ConfigFile

-(id)init{
    self = [super init];
    if (self){
        
    }
    return self;
}

-(NSMutableArray *)getProjectConfig:(NSString *)pid{
    NSMutableArray *panoList = [[NSMutableArray alloc] init];
    if(pid==nil){
        return panoList;
    }
    NSString *url = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/pl/id/%@", pid];
    NSString *responseData = [self getJsonFromUrl:url pid:pid];
    if(responseData !=nil){
        NSDictionary *resultsDictionary = [responseData objectFromJSONString];
        NSArray *panos = [resultsDictionary objectForKey:@"panos"];
        
        for(int i=0; i<panos.count; i++){
            NSDictionary  *tmp = [panos objectAtIndex:i];
            NSString *panoId = [tmp objectForKey:@"id"];
            NSString *panoTitle = [tmp objectForKey:@"title"];
            NSString *panoCreated = [tmp objectForKey:@"created"];
            NSString *panoThumb = [tmp objectForKey:@"thumb"];
            NSString *width = [tmp objectForKey:@"thumb-w"];
            NSString *height = [tmp objectForKey:@"thumb-h"];
            NSString *size = [tmp objectForKey:@"size"];
            if(size == nil){
                size = @"1";
            }
            
            NSMutableDictionary * pano = [[NSMutableDictionary alloc] init];
            
            [pano setValue:panoId forKey:@"pid"];
            [pano setValue:panoTitle forKey:@"title"];
            [pano setValue:panoCreated forKey:@"created"];
            [pano setValue:panoThumb forKey:@"url"];
            [pano setValue:height forKey:@"height"];
            [pano setValue:width forKey:@"width"];
            [pano setValue:size forKey:@"size"];
            [panoList addObject:pano];
        }
    }
    return panoList;
}

-(NSMutableArray *)getPanoConfig:(NSString *)pid{
    NSMutableArray *panoInfo = [[NSMutableArray alloc] init];
    if(pid==nil){
        return panoInfo;
    }
    NSString *url = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/pv/id/%@", pid];;
    NSString *responseData = [self getJsonFromUrl:url pid:pid];
    if(responseData !=nil){
        
        NSDictionary *resultsDictionary = [responseData objectFromJSONString];
        NSDictionary *pano = [resultsDictionary objectForKey:@"pano"];
        
        NSString *panoTitle = [pano objectForKey:@"title"];
        NSMutableDictionary *title = [[NSMutableDictionary alloc] init];
        [title setValue:panoTitle forKey:@"title"];

        [panoInfo addObject:title];
        
        NSString *musicUrl = [resultsDictionary objectForKey:@"music"];
        NSMutableDictionary *music = [[NSMutableDictionary alloc] init];
        [music setValue:musicUrl forKey:@"music"];
        
        [panoInfo addObject:music];

        
        NSString *s_f = [pano objectForKey:@"s_f"];
        NSString *s_r = [pano objectForKey:@"s_r"];
        NSString *s_b = [pano objectForKey:@"s_b"];
        NSString *s_l = [pano objectForKey:@"s_l"];
        NSString *s_u = [pano objectForKey:@"s_u"];
        NSString *s_d = [pano objectForKey:@"s_d"];
        
        NSMutableDictionary *face = [[NSMutableDictionary alloc] init];
        [face setValue:s_f forKey:@"s_f"];
        [face setValue:s_r forKey:@"s_r"];
        [face setValue:s_b forKey:@"s_b"];
        [face setValue:s_l forKey:@"s_l"];
        [face setValue:s_u forKey:@"s_u"];
        [face setValue:s_d forKey:@"s_d"];
        
        [panoInfo addObject:face];
        
        NSDictionary *panoCamera = [resultsDictionary objectForKey:@"camera"];
        int vlookat = 0-[[panoCamera objectForKey:@"vlookat"] intValue];
        int hlookat = 0-[[panoCamera objectForKey:@"hlookat"] intValue];
        int athmax, athmin, atvmax, atvmin;
        if ([panoCamera objectForKey:@"athmax"]!=nil) {
            athmin = 0-[[panoCamera objectForKey:@"athmax"] intValue];
        }
        else{
            athmin = -180;
        }
        if ([panoCamera objectForKey:@"athmin"]!=nil) {
            athmax = 0-[[panoCamera objectForKey:@"athmin"] intValue];
        }
        else{
            athmax = 180;
        }
        if ([panoCamera objectForKey:@"atvmax"]!=nil) {
            atvmax = [[panoCamera objectForKey:@"atvmax"] intValue];
        }
        else{
            atvmax = 90;
        }
        if ([panoCamera objectForKey:@"atvmin"]!=nil) {
            atvmin = [[panoCamera objectForKey:@"atvmin"] intValue];
        }
        else{
            atvmin = -90;
        }
        
        NSMutableDictionary *camera = [[NSMutableDictionary alloc] init];
        [camera setValue:[NSString stringWithFormat:@"%d", hlookat] forKey:@"hlookat"];
        [camera setValue:[NSString stringWithFormat:@"%d", vlookat] forKey:@"vlookat"];
        [camera setValue:[NSString stringWithFormat:@"%d", athmax] forKey:@"athmax"];
        [camera setValue:[NSString stringWithFormat:@"%d", athmin] forKey:@"athmin"];
        [camera setValue:[NSString stringWithFormat:@"%d", atvmax] forKey:@"atvmax"];
        [camera setValue:[NSString stringWithFormat:@"%d", atvmin] forKey:@"atvmin"];
        
        [panoInfo addObject:camera];
        
        NSMutableArray *hotspots = [[NSMutableArray alloc] init];
        NSArray *hotspotDct = [resultsDictionary objectForKey:@"hotspots"];
        for(int i=0; i<hotspotDct.count; i++){
            NSDictionary  *tmp = [hotspotDct objectAtIndex:i];
            
            NSString *hotspotId = [tmp objectForKey:@"id"];
            NSString *link_scene_id = [tmp objectForKey:@"link_scene_id"];
            NSString *tilt = [tmp objectForKey:@"tilt"];
            NSString *pan = [tmp objectForKey:@"pan"];
            NSString *transform = [tmp objectForKey:@"transform"];
            NSString *type = [tmp objectForKey:@"type"];
            NSString *filePath = @"";
            if([type isEqualToString:@"4"]){
                
                filePath = [tmp objectForKey:@"file_path"];
                //NSLog(@"filePath%@", filePath);
            }
            
            NSMutableDictionary *hotspotBox = [[NSMutableDictionary alloc] init];
            [hotspotBox setValue:hotspotId forKey:@"hotspotId"];
            [hotspotBox setValue:link_scene_id forKey:@"linkSceneId"];
            [hotspotBox setValue:tilt forKey:@"tilt"];
            [hotspotBox setValue:pan forKey:@"pan"];
            [hotspotBox setValue:transform forKey:@"transform"];
            [hotspotBox setValue:type forKey:@"type"];
            [hotspotBox setValue:filePath forKey:@"filePath"];
            //NSLog(@"FILEpath%@", filePath);
            [hotspots addObject:hotspotBox];
        }
        [panoInfo addObject:hotspots];
    }
    return panoInfo;
}

-(NSMutableArray *)getPanoMap:(NSString *)pid{
    NSMutableArray *panoMap = [[NSMutableArray alloc] init];
    if(pid==nil){
        return panoMap;
    }
    NSString *url = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/pm/id/%@", pid];
    NSString *responseData = [self getJsonFromUrl:url pid:pid];
    if(responseData !=nil){
        NSDictionary *resultsDictionary = [responseData objectFromJSONString];
        //coordsData = [resultsDictionary objectForKey:@"coords"];
        //NSLog(@"na%@", coordsData);
        NSString *mapUrl = [resultsDictionary objectForKey:@"map"];
        NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
        [map setValue:mapUrl forKey:@"mapUrl"];
        
        [panoMap addObject:map];

        NSArray *coordsData = [resultsDictionary objectForKey:@"coords"];
        [panoMap addObject:coordsData];
    }
    return panoMap;
}

- (NSString *)getJsonFromUrl:(NSString *)url pid:(NSString *) pid{
    if(url == nil){
        return @"";
    }
    
    NSString *responseData = [[NSString alloc] init];
    
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    
    
    Tools *tools = [[Tools alloc] init];
    NSString *fileCachePath = [tools getPanoFileCachePath:pid];
    
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
        responseData = [request responseString];
        //NSLog(@"response%@", responseData);
    }
    else {
        return @"";
    }
    return responseData;
}

@end
