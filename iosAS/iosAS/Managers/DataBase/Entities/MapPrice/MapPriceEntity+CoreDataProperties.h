//  MapPriceEntity+CoreDataProperties.h
//  iosAS
//  Created by Iv on 01/10/2019.
//  Copyright © 2019 Iv. All rights reserved.


#import "MapPriceEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MapPriceEntity (CoreDataProperties)

+ (NSFetchRequest<MapPriceEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *destinationIATA;
@property (nullable, nonatomic, copy) NSString *originIATA;
@property (nonatomic) int64_t value;
@property (nullable, nonatomic, copy) NSString *gate;
@property (nullable, nonatomic, copy) NSDate *departDate;

@end

NS_ASSUME_NONNULL_END
