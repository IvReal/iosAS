//  PlaceTableCell.h
//  iosAS
//  Created by Iv on 19/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlaceTableCell : UITableViewCell

- (void) configureWithName: (NSString*)name andCode:(NSString*)code;

@end

NS_ASSUME_NONNULL_END
