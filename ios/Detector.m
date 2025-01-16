#import "Detector.h"

@implementation Detector {
    bool isCapturedNotificationSent;
}

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[
        @"UIApplicationUserDidTakeScreenshotNotification",
        @"UIScreenCapturedDidChangeNotification"
    ];
}

- (void)startObserving {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(sendNotificationToRN:)
                   name:UIApplicationUserDidTakeScreenshotNotification
                 object:nil];

    [center addObserver:self
               selector:@selector(sendScreenCapturedNotification:)
                   name:UIScreenCapturedDidChangeNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(sendScreenCapturedNotification:)
                   name:UIApplicationDidBecomeActiveNotification
                 object:nil];

}

- (void)stopObserving {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sendNotificationToRN:(NSNotification *)notification {
    [self sendEventWithName:notification.name
                   body:nil];
}

- (void)sendScreenCapturedNotification:(NSNotification *)notification {
    if (![UIScreen mainScreen].isCaptured) {
        isCapturedNotificationSent = NO;
        return;
    }
    if (isCapturedNotificationSent) {
        return;
    }
    isCapturedNotificationSent = YES;
    [self sendEventWithName:@"UIScreenCapturedDidChangeNotification" body:nil];
}

@end
