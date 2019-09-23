//  NewsItemViewController.h
//  iosAS
//  Created by Iv on 21/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NewsItem;

@interface NewsItemViewController : UIViewController

- (instancetype)initWithObject:(NewsItem*)object;

@end

NS_ASSUME_NONNULL_END
