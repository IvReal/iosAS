//  LocalNotificationManager.m
//  iosAS
//  Created by Iv on 04/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import "LocalNotificationManager.h"
#import "DataBaseManager.h"
#import "DataManager.h"
#import "MapPrice.h"

@interface LocalNotificationManager () <UNUserNotificationCenterDelegate>

@end

@implementation LocalNotificationManager

+ (LocalNotificationManager*) shared {
    static LocalNotificationManager* shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (void) requestPermissions {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions: options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"LocalNotificationManager requestPermissions granted");
        } else {
            NSLog(@"LocalNotificationManager requestPermissions error %@", error);
        }
    }];
}

- (void) send: (NSString*) text after: (NSTimeInterval) delay id: (NSString*)ident {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent* content = [UNMutableNotificationContent new];
    content.title = @"AVIA SALES NOTIFICATION";
    content.body = text;
    content.sound = [UNNotificationSound defaultSound];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow: delay];
    NSCalendar* calendar = [NSCalendar calendarWithIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents* components = [calendar componentsInTimeZone: [NSTimeZone systemTimeZone]
                                                         fromDate: date];
    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    newComponents.calendar = calendar;
    newComponents.timeZone = [NSTimeZone defaultTimeZone];
    newComponents.month = components.month;
    newComponents.day = components.day;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    newComponents.second = components.second;
    UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents: newComponents
                                                                                                      repeats: NO];
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier: ident
                                                                          content: content
                                                                          trigger: trigger];
    [center addNotificationRequest: request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"addNotificationRequest %@, error %@", request, error);
    }];
}

- (void) send: (NSString*) text at: (NSDate*) date id: (NSString*)ident {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent* content = [UNMutableNotificationContent new];
    content.title = @"AVIA SALES NOTIFICATION";
    content.body = text;
    content.sound = [UNNotificationSound defaultSound];
    NSCalendar* calendar = [NSCalendar calendarWithIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents* components = [calendar componentsInTimeZone: [NSTimeZone systemTimeZone]
                                                         fromDate: date];
    NSDateComponents *newComponents = [[NSDateComponents alloc] init];
    newComponents.calendar = calendar;
    newComponents.timeZone = [NSTimeZone defaultTimeZone];
    newComponents.month = components.month;
    newComponents.day = components.day;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    newComponents.second = components.second;
    UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents: newComponents
                                                                                                      repeats: NO];
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier: ident
                                                                          content: content
                                                                          trigger: trigger];
    [center addNotificationRequest: request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"addNotificationRequest %@, error %@", request, error);
    }];
}

#pragma mark - UNUserNotificationCenterDelegate

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    NSString *ident = response.notification.request.identifier;
    //NSLog(@"didReceiveNotificationResponse, id=%@", ident);
    NSArray *array = [ident componentsSeparatedByString:@"-"];
    if (array.count >= 2) {
        MapPrice *price = [[DataBaseManager shared] getFavoriteByOrigin:array[0] andDestination:array[1]];
        if (price.originCity == nil && price.destinationCity == nil) {
            [price fillWithCities:[[DataManager shared] cities]];
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
        id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Напоминание" message:[NSString stringWithFormat:@"Билет\n%@-%@\n%@-%@\n%ld RUR\n%@\n%@",
                price.originCity.name,
                price.destinationCity.name,
                price.originIATA,
                price.destinationIATA,
                price.value,
                [dateFormatter stringFromDate:price.departDate],
                price.gate]
            preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

@end
