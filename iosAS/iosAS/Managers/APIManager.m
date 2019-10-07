//  APIManager.m
//  iosAS
//  Created by Iv on 20/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "APIManager.h"
#import "NewsItem.h"
#import "MapPrice.h"

@implementation APIManager

+ (APIManager*) shared {
    static APIManager* shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void) getNewsForCountry: (NSString*) country completion: (APIManager_GetNewsCompletion) completion {
    NSURLSession* session = [NSURLSession sharedSession];
    NSString* key = @"f703c38e02494c87a2c36612266472a0";
    NSString* urlString = [NSString stringWithFormat: @"https://newsapi.org/v2/top-headlines?country=%@&apiKey=%@", country, key];
    NSURL* url = [NSURL URLWithString: urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL: url];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSDictionary* json = nil;
        if (nil != data) {
            NSError* jsonError;
            json = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
        }
        NSArray* newsDictionaries = nil;
        if ([json isKindOfClass: [NSDictionary class]]) {
            newsDictionaries = [json valueForKey: @"articles"];
        }
        NSMutableArray<NewsItem*>* news = [NSMutableArray new];
        if ([newsDictionaries isKindOfClass: [NSArray class]]) {
            for (NSDictionary* newsDictionary in newsDictionaries) {
                if (NO == [newsDictionary isKindOfClass: [NSDictionary class]]) { continue; }
                NewsItem* item = [NewsItem createWithDictionary: newsDictionary];
                if (NO == [item isKindOfClass: [NewsItem class]]) { continue; }
                [news addObject: item];
            }
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completion(news);
        }];
    }];
    [dataTask resume];
}

- (void) getMapPricesFrom: (NSString*) IATA completion: (APIManager_GetMapPricesCompletion) completion {
    NSURLSession* session = [NSURLSession sharedSession];
    NSString* urlString = [NSString stringWithFormat: @"https://map.aviasales.ru/prices.json?origin_iata=%@", IATA];
    NSURL* url = [NSURL URLWithString: urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL: url];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSArray* json = nil;
        if (nil != data) {
            NSError* jsonError;
            json = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
        }
        NSMutableArray<MapPrice*>* prices = [NSMutableArray new];
        if ([json isKindOfClass: [NSArray class]]) {
            for (NSDictionary* dictionary in json) {
                if (NO == [dictionary isKindOfClass: [NSDictionary class]]) { continue; }
                MapPrice* object = [MapPrice createWithDictionary: dictionary];
                if (NO == [object isKindOfClass: [MapPrice class]]) { continue; }
                [prices addObject: object];
            }
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completion(prices);
        }];
    }];
    [dataTask resume];
}

- (void) getMapPricesFrom: (NSString*) origin to: (NSString*) destination completion: (APIManager_GetMapPricesCompletion) completion {
    NSURLSession* session = [NSURLSession sharedSession];
    NSString* urlString = [NSString stringWithFormat: @"https://min-prices.aviasales.ru/calendar_preload?origin=%@&destination=%@", origin, destination];
    NSURL* url = [NSURL URLWithString: urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL: url];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest: request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSArray* json = nil;
        if (nil != data) {
            NSError* jsonError;
            json = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonError];
        }
        NSArray* newsDictionaries = nil;
        if ([json isKindOfClass: [NSDictionary class]]) {
            //newsDictionaries = [json valueForKey: @"best_prices"];
            newsDictionaries = [json valueForKey: @"current_depart_date_prices"];
        }
        NSMutableArray<MapPrice*>* prices = [NSMutableArray new];
        if ([newsDictionaries isKindOfClass: [NSArray class]]) {
            for (NSDictionary* dictionary in newsDictionaries) {
                if (NO == [dictionary isKindOfClass: [NSDictionary class]]) { continue; }
                MapPrice* object = [MapPrice createWithDictionary: dictionary];
                if (NO == [object isKindOfClass: [MapPrice class]]) { continue; }
                [prices addObject: object];
            }
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completion(prices);
        }];
    }];
    [dataTask resume];
}

@end

