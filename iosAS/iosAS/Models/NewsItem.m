//  NewsItem.m
//  iosAS
//  Created by Iv on 20/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "NewsItem.h"

@interface NewsItem ()

@property (nonatomic, strong, readwrite) NSString *author;
@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSString *descr;
@property (nonatomic, strong, readwrite) NSString *url;
@property (nonatomic, strong, readwrite) NSString *urlToImage;
@property (nonatomic, strong, readwrite) NSDate *publishedAt;
@property (nonatomic, strong, readwrite) NSString *content;

@end

@implementation NewsItem

+ (nullable NSDate*) getDateFromUtcString: (NSString*)utc {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    // Always use this locale when parsing fixed format date strings
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:posix];
    return [formatter dateFromString:utc];
}

+ (nullable NewsItem*) createWithDictionary: (NSDictionary*) dictionary; {
    NSString* author = [dictionary objectForKey: @"author"];
    if (NO == [author isKindOfClass: [NSString class]]) { author = @"(no author)"; }
    NSString* title = [dictionary objectForKey: @"title"];
    if (NO == [title isKindOfClass: [NSString class]]) { title = @"(no title)"; }
    NSString* descr = [dictionary objectForKey: @"description"];
    if (NO == [descr isKindOfClass: [NSString class]]) { descr = @"(no description)"; }
    NSString* url = [dictionary objectForKey: @"url"];
    if (NO == [url isKindOfClass: [NSString class]]) { url = @""; }
    NSString* urlToImage = [dictionary objectForKey: @"urlToImage"];
    if (NO == [urlToImage isKindOfClass: [NSString class]]) { urlToImage = @""; }
    
    //NSDate* publishedAt = [dictionary objectForKey: @"publishedAt"];
    //if (NO == [publishedAt isKindOfClass: [NSDate class]]) { return nil; }
    NSString* dateString = [dictionary objectForKey: @"publishedAt"];
    NSDate* publishedAt = nil;
    if (YES == [dateString isKindOfClass: [NSString class]]) {
        publishedAt = [self getDateFromUtcString:dateString];
    }

    NSString* content = [dictionary objectForKey: @"content"];
    if (NO == [content isKindOfClass: [NSString class]]) { content = @"(no content)"; }

    NewsItem* item = [NewsItem new];
    item.author = author;
    item.title = title;
    item.descr = descr;
    item.url = url;
    item.urlToImage = urlToImage;
    item.publishedAt = publishedAt;
    item.content = content;

    return item;
}

@end
