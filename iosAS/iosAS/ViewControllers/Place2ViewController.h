//  Place2ViewController.h
//  iosAS
//  Created by Iv on 27/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <UIKit/UIKit.h>
#import "PlaceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Place2ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating>

@property (nonatomic, strong) id<PlaceViewControllerDelegate>delegate;
- (instancetype)initWithType:(PlaceType)type;

@end

NS_ASSUME_NONNULL_END
