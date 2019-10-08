//  TicketViewController.h
//  iosAS
//  Created by Iv on 06/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MapPrice;

@interface TicketViewController : UIViewController

- (instancetype)initWithObject:(MapPrice*)object;

@end

NS_ASSUME_NONNULL_END
