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

-(void)loadFromDisk{
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *elementsData = [NSData dataWithContentsOfFile:pathString];
    
    NSError *anError = nil;
    NSArray *parsedElements = [NSJSONSerialization JSONObjectWithData:elementsData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&anError];
    
    for (NSDictionary *aModuleDict in parsedElements){
        MosaicData *aMosaicModule = [[MosaicData alloc] initWithDictionary:aModuleDict];
        [elements addObject:aMosaicModule];
    }
}

#pragma mark - Public

-(id)init{
    self = [super init];
    
    if (self){
        elements = [[NSMutableArray alloc] init];
        [self loadFromDisk];
    }
    
    return self;
}

//  Singleton method proposed in WWDC 2012
+ (PanoListMosaicDatasource *)sharedInstance {
	static PanoListMosaicDatasource *sharedInstance;
	if (sharedInstance == nil)
		sharedInstance = [PanoListMosaicDatasource new];
	return sharedInstance;
}

#pragma mark - MosaicViewDatasourceProtocol

-(NSArray *)mosaicElements{
    NSArray *retVal = elements;
    return retVal;
}

@end
