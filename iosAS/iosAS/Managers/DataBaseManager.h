//  DatabaseManager.h
//  iosAS
//  Created by Iv on 01/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MapPrice;

typedef void(^DataBaseManager_MapPriceCompletion)(NSArray<MapPrice*>*);

@interface DataBaseManager : NSObject

+ (DataBaseManager*) shared;

- (void)addMapPriceToFavorite:(MapPrice *)price;
- (void)removeMapPriceFromFavorite:(MapPrice *)price;
- (BOOL)isFavorite:(MapPrice *)price;
- (void)loadFavoriteMapPrices:(DataBaseManager_MapPriceCompletion) completion;

@end

NS_ASSUME_NONNULL_END
