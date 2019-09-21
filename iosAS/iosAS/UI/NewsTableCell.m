//  NewsTableCell.m
//  iosAS
//  Created by Iv on 20/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "NewsTableCell.h"

@interface NewsTableCell ()

@property (nonatomic, weak) UILabel *labelAuthor;
@property (nonatomic, weak) UILabel *labelDate;
@property (nonatomic, weak) UILabel *labelTitle;

@end

@implementation NewsTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
    [self addSubviews];
    return self;
}

- (void) configureWithTitle: (NSString*)title andAuthor:(NSString*)author andDate: (NSDate*)date {
    self.labelTitle.text = title;
    self.labelAuthor.text = author;
    // TODO: move to helper
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    self.labelDate.text = [dateFormatter stringFromDate:date];
}

#pragma mark - Subviews

- (void) addSubviews {
    [self addTitleLabel];
    [self addAuthorLabel];
    [self addDateLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat xindent = 10;
    CGFloat y = self.contentView.bounds.origin.y;
    CGFloat w = self.contentView.bounds.size.width - xindent * 2;
    self.labelDate.frame = CGRectMake(self.contentView.bounds.origin.x + xindent, y, w, 20);
    y += self.labelDate.frame.size.height;
    self.labelAuthor.frame = CGRectMake(self.contentView.bounds.origin.x + xindent, y, w, 20);
    y += self.labelAuthor.frame.size.height;
    self.labelTitle.frame = CGRectMake(self.contentView.bounds.origin.x + xindent, y, w, 0);
    [self.labelTitle sizeToFit];
}

- (void) addTitleLabel {
    if (nil != self.labelTitle) { return; }
    UILabel* label = [UILabel new];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:14.0 weight: UIFontWeightBold];
    [self.contentView addSubview: label];
    self.labelTitle = label;
}

- (void) addAuthorLabel {
    if (nil != self.labelAuthor) { return; }
    UILabel* label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12.0 weight: UIFontWeightRegular];
    [self.contentView addSubview: label];
    self.labelAuthor = label;
}

- (void) addDateLabel {
    if (nil != self.labelDate) { return; }
    UILabel* label = [UILabel new];
    label.font = [UIFont systemFontOfSize:12.0 weight: UIFontWeightRegular];
    [self.contentView addSubview: label];
    self.labelDate = label;
}

@end
