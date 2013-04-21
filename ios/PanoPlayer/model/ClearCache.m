//
//  ClearCache.m
//  PanoPlayer
//
//  Created by yiluhao on 13-4-21.
//
//

#import "ClearCache.h"

@implementation ClearCache

-(id)init{
    self = [super init];
    if (self){
        fileManager = [NSFileManager defaultManager];
    }
    return self;
}

-(void)cleanConfigCache{
    //获取
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/Caches"];
    [self deleteFile:documentsDirectory];
    
}
-(void)deleteFile:(NSString *)path{
    NSLog(@"path=%@", path);
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    //NSLog(@"contents%@", contents);
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    BOOL isDir = NO;
    //NSString *subPath = path;
    while ((filename = [e nextObject])) {
        NSString *subPath = [path stringByAppendingFormat:@"/%@", filename];
        //NSLog(@"dir=%@", subPath);
        [fileManager fileExistsAtPath:subPath isDirectory:(&isDir)];
        //NSLog(@"isDir=%@",filename);
        if (isDir) {
            [self deleteFile:subPath];
        }
        else{
            NSLog(@"file=%@", subPath);
            [fileManager removeItemAtPath:subPath error:NULL];
        }
        //isDir = NO;
        /*
         if ([[filename pathExtension] isEqualToString:extension]) {
         
         [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
         }
         */
    }

}


-(void)cleanDataCache{
    
}

@end
