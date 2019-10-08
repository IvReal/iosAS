//  TicketViewController.m
//  iosAS
//  Created by Iv on 06/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "TicketViewController.h"
#import "MapPrice.h"
#import "City.h"

@interface TicketViewController ()

@property (nonatomic, weak) MapPrice *ticket;
@property (nonatomic, weak, readwrite) UIView* viewTicket;
@property (nonatomic, weak, readwrite) UILabel* labelPrice;
@property (nonatomic, weak, readwrite) UILabel* labelRoute;
@property (nonatomic, weak, readwrite) UILabel* labelRouteCode;
@property (nonatomic, weak, readwrite) UILabel* labelDepartDate;
@property (nonatomic, weak, readwrite) UILabel* labelGate;

@end

@implementation TicketViewController

- (instancetype)initWithObject:(MapPrice*)object
{
    self = [super init];
    if (self) {
        self.ticket = object;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Ticket";
    // Plum #DDA0DD 221, 160, 221
    self.view.backgroundColor = [UIColor colorWithRed:221/255.0f green:160/255.0f blue:221/255.0f alpha:1.0];

    [self addTicketView];
    [self addPriceLabel];
    [self addRouteLabel];
    [self addRouteCodeLabel];
    [self addDepartDateLabel];
    [self addGateLabel];
    
    self.labelPrice.text = [NSString stringWithFormat:@"%ld RUR", self.ticket.value];
    self.labelRoute.text = [NSString stringWithFormat:@"%@-%@", self.ticket.originCity.name, self.ticket.destinationCity.name];
    self.labelRouteCode.text = [NSString stringWithFormat:@"%@-%@", self.ticket.originIATA, self.ticket.destinationIATA];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    self.labelDepartDate.text = [dateFormatter stringFromDate:self.ticket.departDate];
    self.labelGate.text = self.ticket.gate;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat indent = 10;
    CGFloat y = self.view.safeAreaInsets.top + indent;
    CGFloat w = self.view.bounds.size.width - indent*2;
    
    self.viewTicket.frame = CGRectMake(indent, y, w, 170);
    
    y = 10;
    w = self.viewTicket.bounds.size.width - indent*2;
    
    self.labelPrice.frame = CGRectMake(indent, y, w, 30);
    y += self.labelPrice.frame.size.height;
    self.labelRoute.frame = CGRectMake(indent, y, w, 30);
    y += self.labelRoute.frame.size.height;
    self.labelRouteCode.frame = CGRectMake(indent, y, w, 30);
    y += self.labelRouteCode.frame.size.height;
    self.labelDepartDate.frame = CGRectMake(indent, y, w, 30);
    y += self.labelDepartDate.frame.size.height;
    self.labelGate.frame = CGRectMake(indent, y, w, 30);
}


- (void)addTicketView {
    if (nil != self.viewTicket) { return; }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 1.0;
    [self.view addSubview: view];
    self.viewTicket = view;
}

- (void)addPriceLabel {
    if (nil != self.labelPrice) { return; }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightBold];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.viewTicket addSubview: label];
    self.labelPrice = label;
}

- (void)addRouteLabel {
    if (nil != self.labelRoute) { return; }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightRegular];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.viewTicket addSubview: label];
    self.labelRoute = label;
}

- (void)addRouteCodeLabel {
    if (nil != self.labelRouteCode) { return; }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightRegular];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.viewTicket addSubview: label];
    self.labelRouteCode = label;
}

- (void)addDepartDateLabel {
    if (nil != self.labelDepartDate) { return; }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightRegular];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.viewTicket addSubview: label];
    self.labelDepartDate = label;
}

- (void)addGateLabel {
    if (nil != self.labelGate) { return; }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightRegular];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.viewTicket addSubview: label];
    self.labelGate = label;
}

@end
