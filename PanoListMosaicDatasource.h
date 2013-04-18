//
//  PanoListMosaicDatasource.h
//  PanoPlayer
//
//  Created by yiluhao on 13-4-18.
//
//

#import <Foundation/Foundation.h>
#import "MosaicViewDatasourceProtocol.h"

@interface PanoListMosaicDatasource : NSObject <MosaicViewDatasourceProtocol>{
    NSMutableArray *elements;
}

+ (PanoListMosaicDatasource *)sharedInstance;


@end
