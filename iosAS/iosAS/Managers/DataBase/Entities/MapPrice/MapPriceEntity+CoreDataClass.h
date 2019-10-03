//  MapPriceEntity+CoreDataClass.h
//  iosAS
//  Created by Iv on 01/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class MapPrice;

@interface MapPriceEntity : NSManagedObject

+ (MapPriceEntity*) createFrom: (MapPrice*) price context: (NSManagedObjectContext*) context;
- (MapPrice*) create;

@end

NS_ASSUME_NONNULL_END

#import "MapPriceEntity+CoreDataProperties.h"
