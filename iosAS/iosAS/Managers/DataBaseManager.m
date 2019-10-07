//  DatabaseManager.m
//  iosAS
//  Created by Iv on 01/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "DataBaseManager.h"
#import "MapPrice.h"
#import "MapPriceEntity+CoreDataClass.h"
#import <CoreData/CoreData.h>

@interface DataBaseManager () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSPersistentContainer* container;
@property (nonatomic, strong) NSFetchedResultsController* citiesSearchFetchedResultsController;

@end

@implementation DataBaseManager

+ (DataBaseManager*) shared {
    static DataBaseManager* shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        
        NSURL* fileURL = [DataBaseManager dbFile];
        NSLog(@"fileURL %@", fileURL);
        
        NSPersistentStoreDescription* storeDescription = [NSPersistentStoreDescription persistentStoreDescriptionWithURL: fileURL];
        
        shared.container = [NSPersistentContainer persistentContainerWithName: @"iosAS"];
        shared.container.persistentStoreDescriptions = @[storeDescription];
        
        [shared.container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * storeDescription, NSError * error) {
            
        }];
    });
    return shared;
}

- (void)addMapPriceToFavorite:(MapPrice *)price {
    [self.container performBackgroundTask:^(NSManagedObjectContext * context) {
        /*MapPriceEntity *entity = */[MapPriceEntity createFrom:price context:context];
        NSError* error = nil;
        [context save: &error];
        NSLog(@"saveMapPriceFavorite, error %@", error);
    }];
}

- (void)removeMapPriceFromFavorite:(MapPrice *)price {
    //[self.container performBackgroundTask:^(NSManagedObjectContext * context) {
        NSManagedObjectContext * context = self.container.viewContext;
        MapPriceEntity *entity = [MapPriceEntity createFrom:price context:context];
        [context deleteObject:entity];
        NSError* error = nil;
        [context save: &error];
        NSLog(@"removeMapPriceFavorite, error %@", error);
    //}];
}

- (BOOL)isFavorite:(MapPrice *)price {
    MapPriceEntity* entity = nil;
    //[self.container performBackgroundTask:^(NSManagedObjectContext * context) {
        NSFetchRequest<MapPriceEntity *> * fetchRequest = [MapPriceEntity fetchRequest];
        fetchRequest.predicate = [NSPredicate predicateWithFormat: @"originIATA == %@ and destinationIATA == %@", price.originIATA, price.destinationIATA];
        fetchRequest.fetchLimit = 1;
        NSError* error = nil;
        NSArray* result = [self.container.viewContext executeFetchRequest: fetchRequest error: &error];
        entity = [result firstObject];
    //}];
    return entity != nil;
}

- (MapPrice*)getFavoriteByOrigin:(NSString*)origin andDestination:(NSString*)destination {
    MapPrice* price = nil;
    NSFetchRequest<MapPriceEntity*>* fetchRequest = [MapPriceEntity fetchRequest];
    fetchRequest.predicate = [NSPredicate predicateWithFormat: @"originIATA == %@ and destinationIATA == %@", origin, destination];
    fetchRequest.fetchLimit = 1;
    NSError* error = nil;
    NSArray* result = [self.container.viewContext executeFetchRequest: fetchRequest error: &error];
    MapPriceEntity* entity = [result firstObject];
    price = [entity create];
    return price;
}

- (void)loadFavoriteMapPricesWithSort:(PriceSort)sort completion: (DataBaseManager_MapPriceCompletion) completion {
    [self.container performBackgroundTask:^(NSManagedObjectContext * context) {
        NSFetchRequest* fetchRequest = [MapPriceEntity fetchRequest];
        if (sort == PriceSortDate) {
            fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey: @"departDate" ascending: YES] ];
        }
        else if (sort == PriceSortPrice) {
            fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey: @"value" ascending: YES] ];
        }
        
        NSError* error = nil;
        NSArray* result = [context executeFetchRequest: fetchRequest error: &error];
        
        NSMutableArray* prices = [NSMutableArray new];
        for (MapPriceEntity* entity in result) {
            if (NO == [entity isKindOfClass: [MapPriceEntity class]]) { continue; }
            MapPrice* price = [entity create];
            [prices addObject: price];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completion(prices);
        }];
    }];
}

+ (NSURL*) dbFile {
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths firstObject];
    NSString* filePath = [documentPath stringByAppendingPathComponent: @"iosAS.sqlite"];
    return [NSURL fileURLWithPath: filePath];
}

@end
