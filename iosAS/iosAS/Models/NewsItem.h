//  NewsItem.h
//  iosAS
//  Created by Iv on 20/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsItem : NSObject

@property (nonatomic, strong, readonly) NSString *author;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *descr;
@property (nonatomic, strong, readonly) NSString *url;
@property (nonatomic, strong, readonly) NSString *urlToImage;
@property (nonatomic, strong, readonly) NSDate *publishedAt;
@property (nonatomic, strong, readonly) NSString *content;

+ (nullable NewsItem*) createWithDictionary: (NSDictionary*) dictionary;

@end

NS_ASSUME_NONNULL_END
