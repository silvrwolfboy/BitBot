//
//  BRProgressObserver.m
//  Bitrise
//
//  Created by Deszip on 21/02/2019.
//  Copyright © 2019 Bitrise. All rights reserved.
//

#import "BRProgressObserver.h"

static void *BRProgressObserverContext = &BRProgressObserverContext;
static NSString * const kProgressFractionKey = @"fractionCompleted";

@interface BRProgressObserver ()

@property (strong, nonatomic) NSProgress *progress;
@property (weak, nonatomic) NSProgressIndicator *indicator;

@end

@implementation BRProgressObserver

#pragma mark - Public API -

- (void)bindProgress:(NSProgress *)progress toIndicator:(NSProgressIndicator *)indicator {
    self.progress = progress;
    self.indicator = indicator;
    
    [self.progress addObserver:self forKeyPath:kProgressFractionKey options:0 context:BRProgressObserverContext];
}

- (void)stop {
    [self.progress removeObserver:self forKeyPath:kProgressFractionKey context:BRProgressObserverContext];
}

#pragma mark - KVO -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == BRProgressObserverContext) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([keyPath isEqualToString:kProgressFractionKey]) {
                self.indicator.doubleValue = [(NSProgress *)object fractionCompleted];
            }
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
