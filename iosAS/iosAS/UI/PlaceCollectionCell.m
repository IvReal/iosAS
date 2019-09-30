//  PlaceCollectionCell.m
//  iosAS
//  Created by Iv on 27/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "PlaceCollectionCell.h"

@interface PlaceCollectionCell ()

@property (nonatomic, weak) UILabel *labelName;
@property (nonatomic, weak) UILabel *labelCode;

@end

@implementation PlaceCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void) configureWithName: (NSString*)name andCode:(NSString*)code {
    self.labelName.text = name;
    self.labelCode.text = code;
}

#pragma mark - Subviews

- (void) addSubviews {
    [self addNameLabel];
    [self addCodeLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat hName = self.contentView.bounds.size.height * 2 / 3;
    CGFloat hCode = self.contentView.bounds.size.height / 3;
    CGFloat xindent = 10;
    self.labelName.frame = CGRectMake(self.contentView.bounds.origin.x + xindent,
                                      self.contentView.bounds.origin.y,
                                      self.contentView.bounds.size.width,
                                      hName);
    self.labelCode.frame = CGRectMake(self.contentView.bounds.origin.x + xindent,
                                      self.contentView.bounds.origin.y + hName,
                                      self.contentView.bounds.size.width,
                                      hCode);
}

- (void) addNameLabel {
    if (nil != self.labelName) { return; }
    UILabel* label = [UILabel new];
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightBold];
    [self.contentView addSubview: label];
    self.labelName = label;
}

- (void) addCodeLabel {
    if (nil != self.labelCode) { return; }
    UILabel* label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12.0 weight: UIFontWeightRegular];
    [self.contentView addSubview: label];
    self.labelCode = label;
}

@end
