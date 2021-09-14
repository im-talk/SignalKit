//
//  SKSignal+Take.m
//  SignalKit_Example
//
//  Created by mac on 2021/9/14.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal+Take.h"
#import "SKAtomic.h"

@implementation SKSignalTakeAction

+ (instancetype)actionWithPassthrough:(BOOL)passthrough complete:(BOOL)complete {
    SKSignalTakeAction *action = [[self alloc] init];
    action.passthrough = passthrough;
    action.complete = complete;
    return action;
}

@end

@implementation SKSignal (Take)

- (SKSignal *)take:(NSUInteger)count {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        SKAtomic<NSNumber *> *counter = [SKAtomic atomicWithValue:@(0)];
        return [self startWithNext:^(id  _Nullable value) {
            __block BOOL passthrough = NO;
            __block BOOL complete = NO;
            [counter modify:^id _Nullable(NSNumber * _Nullable value) {
                NSUInteger updatedCount = [value unsignedIntegerValue] + 1;
                if (updatedCount <= count) {
                    passthrough = YES;
                }
                if (updatedCount == count) {
                    complete = YES;
                }
                return @(updatedCount);
            }];
            
            if (passthrough) {
                [subscriber putNext:value];
            }
            if (complete) {
                [subscriber putCompletion];
            }
        } error:^(id  _Nullable error) {
            [subscriber putNext:error];
        } completed:^{
            [subscriber putCompletion];
        }];
    }];
}

- (SKSignal *)takeLast {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        SKAtomic *lastValue = [SKAtomic new];
        return [self startWithNext:^(id  _Nullable value) {
            [lastValue swap:value];
        } error:^(id  _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            [subscriber putNext:lastValue.value];
            [subscriber putCompletion];
        }];
    }];
}

- (SKSignal *)takeWhile:(SKSignalTakeAction * _Nonnull (^)(id _Nullable))predicate {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        return [self startWithNext:^(id  _Nullable value) {
            SKSignalTakeAction *action = predicate(value);
            if (action.passthrough) {
                [subscriber putNext:value];
            }
            if (action.complete) {
                [subscriber putCompletion];
            }
        } error:^(id  _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            [subscriber putCompletion];
        }];
    }];
}

@end
