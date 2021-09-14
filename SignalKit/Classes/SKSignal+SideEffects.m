//
//  SKSignal+SideEffects.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal+SideEffects.h"
#import "SKCompoundDisposable.h"
#import "SKBlockDisposable.h"

@implementation SKSignal (SideEffects)

- (SKSignal *)onStart:(void (^)(void))block {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        block();
        return [self startWithNext:^(id  _Nullable value) {
            [subscriber putNext:value];
        } error:^(id  _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            [subscriber putCompletion];
        }];
    }];
}

- (SKSignal *)onNext:(void (^)(id _Nullable))block {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        return [self startWithNext:^(id  _Nullable value) {
            block(value);
            [subscriber putNext:value];
        } error:^(id  _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            [subscriber putCompletion];
        }];
    }];
}

- (SKSignal *)afterNext:(void (^)(id _Nullable))block {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        return [self startWithNext:^(id  _Nullable value) {
            [subscriber putNext:value];
            block(value);
        } error:^(id  _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            [subscriber putCompletion];
        }];
    }];
}

- (SKSignal *)onError:(void (^)(id _Nullable))block {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        return [self startWithNext:^(id  _Nullable value) {
            [subscriber putNext:value];
        } error:^(id  _Nullable error) {
            block(error);
            [subscriber putError:error];
        } completed:^{
            [subscriber putCompletion];
        }];
    }];
}

- (SKSignal *)afterError:(void (^)(id _Nullable))block {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        return [self startWithNext:^(id  _Nullable value) {
            [subscriber putNext:value];
        } error:^(id  _Nullable error) {
            [subscriber putError:error];
            block(error);
        } completed:^{
            [subscriber putCompletion];
        }];
    }];
}

- (SKSignal *)onCompletion:(void (^)(void))block {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        return [self startWithNext:^(id  _Nullable value) {
            [subscriber putNext:value];
        } error:^(id  _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            block();
            [subscriber putCompletion];
        }];
    }];
}

-(SKSignal *)afterCompletion:(void (^)(void))block {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        return [self startWithNext:^(id  _Nullable value) {
            [subscriber putNext:value];
        } error:^(id  _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            [subscriber putCompletion];
            block();
        }];
    }];
}

- (SKSignal *)onDispose:(void (^)(void))block {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        SKCompoundDisposable *compoundDisposable = [[SKCompoundDisposable alloc] init];
        
        [compoundDisposable addDisposable:[self startWithNext:^(id  _Nullable value) {
            [subscriber putNext:value];
        } error:^(id  _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            [subscriber putCompletion];
        }]];
        
        [compoundDisposable addDisposable:[SKBlockDisposable disposableWithBlock:^{
            block();
        }]];
        
        return compoundDisposable;
    }]; 
}
@end
