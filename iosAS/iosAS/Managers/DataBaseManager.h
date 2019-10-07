//  DatabaseManager.h
//  iosAS
//  Created by Iv on 01/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MapPrice;

typedef enum PriceSort {
    PriceSortDate,
    PriceSortPrice
} PriceSort;


typedef void(^DataBaseManager_MapPriceCompletion)(NSArray<MapPrice*>*);

@interface DataBaseManager : NSObject

+ (DataBaseManager*) shared;

- (void)addMapPriceToFavorite:(MapPrice *)price;
- (void)removeMapPriceFromFavorite:(MapPrice *)price;
- (BOOL)isFavorite:(MapPrice *)price;
- (void)loadFavoriteMapPricesWithSort:(PriceSort)sort completion: (DataBaseManager_MapPriceCompletion) completion;
- (MapPrice*)getFavoriteByOrigin:(NSString*)origin andDestination:(NSString*)destination;

@end

NS_ASSUME_NONNULL_END
