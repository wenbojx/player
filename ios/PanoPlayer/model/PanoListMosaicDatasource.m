//
//  PanoListMosaicDatasource.m
//  PanoPlayer
//
//  Created by yiluhao on 13-4-18.
//
//

#import "PanoListMosaicDatasource.h"
#import "MosaicData.h"


@implementation PanoListMosaicDatasource

#pragma mark - Private

-(void)loadFromDisk:(NSMutableArray *) datas{
    
    for (NSDictionary *aModuleDict in datas){
        MosaicData *aMosaicModule = [[MosaicData alloc] initWithDictionary:aModuleDict];
        [elements addObject:aMosaicModule];
    }
    //NSLog(@"datas=%@", elements);
}

#pragma mark - Public

-(id)init:(NSMutableArray *) datas{
    self = [super init];
    if (self){
        elements = [[NSMutableArray alloc] init];
        
        [self loadFromDisk:datas];
    }
    
    return self;
}

//  Singleton method proposed in WWDC 2012
+ (PanoListMosaicDatasource *)sharedInstance:(NSMutableArray *) datas {
	static PanoListMosaicDatasource *sharedInstance;
	
    sharedInstance = [[PanoListMosaicDatasource alloc] init:datas];
    //}
	return sharedInstance;
}

#pragma mark - MosaicViewDatasourceProtocol

-(NSArray *)mosaicElements{
    NSArray *retVal = elements;
    return retVal;
}

@end
