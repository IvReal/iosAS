//  NewsTableCell.h
//  iosAS
//  Created by Iv on 20/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsTableCell : UITableViewCell

- (void) configureWithTitle: (NSString*)title andAuthor:(NSString*)author andDate: (NSDate*)date;

@end

NS_ASSUME_NONNULL_END
