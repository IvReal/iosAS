//  LocalNotificationManager.h
//  iosAS
//  Created by Iv on 04/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalNotificationManager : NSObject

+ (LocalNotificationManager*) shared;
- (void) requestPermissions;
- (void) send: (NSString*) text after: (NSTimeInterval) delay id: (NSString*)ident;
- (void) send: (NSString*) text at: (NSDate*) date id: (NSString*)ident;

@end

NS_ASSUME_NONNULL_END
