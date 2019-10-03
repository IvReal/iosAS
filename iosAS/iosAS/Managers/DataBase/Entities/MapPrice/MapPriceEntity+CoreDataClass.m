//  MapPriceEntity+CoreDataClass.m
//  iosAS
//  Created by Iv on 01/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "MapPriceEntity+CoreDataClass.h"
#import "MapPrice.h"

@implementation MapPriceEntity

- (MapPrice*) create {
    MapPrice* price = [MapPrice new];
    price.originIATA = self.originIATA;
    price.destinationIATA = self.destinationIATA;
    price.value = self.value;
    price.gate = self.gate;
    price.departDate = self.departDate;
    return price;
}

+ (MapPriceEntity*) createFrom: (MapPrice*) price context: (NSManagedObjectContext*) context {
    MapPriceEntity* entity = nil;
    
    NSFetchRequest<MapPriceEntity *> * fetchRequest = [MapPriceEntity fetchRequest];
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"originIATA == %@ and destinationIATA == %@", price.originIATA, price.destinationIATA];
    fetchRequest.fetchLimit = 1;
    
    NSError* error = nil;
    NSArray* result = [context executeFetchRequest: fetchRequest error: &error];
    entity = [result firstObject];
    
    if (nil == entity) {
        entity = [NSEntityDescription insertNewObjectForEntityForName: @"MapPriceEntity" inManagedObjectContext: context];
        
        entity.originIATA = price.originIATA;
        entity.destinationIATA = price.destinationIATA;
        entity.value = price.value;
        entity.gate = price.gate;
        entity.departDate = price.departDate;
    }
    return entity;
}

@end
