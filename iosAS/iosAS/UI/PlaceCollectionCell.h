//  PlaceCollectionCell.h
//  iosAS
//  Created by Iv on 27/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlaceCollectionCell : UICollectionViewCell

- (void) configureWithName: (NSString*)name andCode:(NSString*)code;

@end

NS_ASSUME_NONNULL_END
