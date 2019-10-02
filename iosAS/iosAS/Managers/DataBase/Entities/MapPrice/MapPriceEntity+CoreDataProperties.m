//  MapPriceEntity+CoreDataProperties.m
//  iosAS
//  Created by Iv on 01/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "MapPriceEntity+CoreDataProperties.h"

@implementation MapPriceEntity (CoreDataProperties)

+ (NSFetchRequest<MapPriceEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"MapPriceEntity"];
}

@dynamic destinationIATA;
@dynamic originIATA;
@dynamic value;
@dynamic gate;
@dynamic departDate;

@end
