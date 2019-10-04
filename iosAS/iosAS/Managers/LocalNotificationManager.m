//  LocalNotificationManager.m
//  iosAS
//  Created by Iv on 04/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "LocalNotificationManager.h"
#import <UserNotifications/UserNotifications.h>

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
            //[self send: @"Test" after: 5];
        } else {
            NSLog(@"LocalNotificationManager requestPermissions error %@", error);
        }
    }];
}

- (void) send: (NSString*) text after: (NSTimeInterval) delay {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent* content = [UNMutableNotificationContent new];
    content.title = @"Title";
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
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier: @"Local notification"
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
    NSLog(@"didReceiveNotificationResponse");
}

@end
