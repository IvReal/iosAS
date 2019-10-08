//  APIManager.h
//  iosAS
//  Created by Iv on 20/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NewsItem;
@class MapPrice;

typedef void (^APIManager_GetNewsCompletion)(NSArray<NewsItem*>*);
typedef void (^APIManager_GetMapPricesCompletion)(NSArray<MapPrice*>*);

@interface APIManager : NSObject

+ (APIManager*) shared;

- (void) getNewsForCountry: (NSString*) country completion: (APIManager_GetNewsCompletion) completion;
- (void) getMapPricesFrom: (NSString*) IATA completion: (APIManager_GetMapPricesCompletion) completion;
- (void) getMapPricesFrom: (NSString*) origin to: (NSString*) destination completion: (APIManager_GetMapPricesCompletion) completion;

@end

NS_ASSUME_NONNULL_END
