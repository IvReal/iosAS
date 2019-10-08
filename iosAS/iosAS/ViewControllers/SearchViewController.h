//  SearchViewController.h
//  iosAS
//  Created by Iv on 05/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithFrom:(NSString*)from andTo:(NSString*)to;

@end

NS_ASSUME_NONNULL_END
