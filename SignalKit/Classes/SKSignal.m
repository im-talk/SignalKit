//
//  SKSignal.m
//  SignalKit
//
//  Created by xueqooy on 2021/9/3.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal.h"
#import "SKSubscriberInternal.h"

@interface SKSubscriberDisposable : NSObject <SKDisposable>

@end

@implementation SKSubscriberDisposable {
    SKSubscriber *_subscriber;
    id<SKDisposable> _disposable;
}

- (instancetype)initWithSubscriber:(SKSubscriber *)subscriber disposable:(id<SKDisposable>)disposable {
    self = [super init];
    if (self) {
        _subscriber = subscriber;
        _disposable = disposable;
    }
    return self;
}

- (void)dispose {
    [_subscriber markTerminatedWithoutDisposal];
    [_disposable dispose];
}


@end

@implementation SKSignal {
    id<SKDisposable>_Nullable (^_generator)(SKSubscriber *subscriber);
}

- (instancetype)initWithGenerator:(id<SKDisposable> _Nullable (^)(SKSubscriber * _Nonnull))generator { 
    self = [super init];
    if (self) {
        _generator = [generator copy];
    }
    return self;
}

+ (instancetype)signalWithGenerator:(id<SKDisposable>  _Nullable (^)(SKSubscriber * _Nonnull))generator {
    return [[self alloc] initWithGenerator:generator];
}

- (id<SKDisposable>)startWithNext:(void (^)(id _Nullable))next {
    SKSubscriber *subscriber = [[SKSubscriber alloc] initWithNext:next error:nil completed:nil];
    id<SKDisposable> disposable = _generator(subscriber);
    [subscriber assignDisposable:disposable];
    return [[SKSubscriberDisposable alloc] initWithSubscriber:subscriber disposable:disposable];
}

- (id<SKDisposable>)startWithError:(void (^)(id _Nullable))error {
    SKSubscriber *subscriber = [[SKSubscriber alloc] initWithNext:nil error:error completed:nil];
    id<SKDisposable> disposable = _generator(subscriber);
    [subscriber assignDisposable:disposable];
    return [[SKSubscriberDisposable alloc] initWithSubscriber:subscriber disposable:disposable];
}

- (id<SKDisposable>)startWithCompleted:(void (^)(void))completed {
    SKSubscriber *subscriber = [[SKSubscriber alloc] initWithNext:nil error:nil completed:completed];
    id<SKDisposable> disposable = _generator(subscriber);
    [subscriber assignDisposable:disposable];
    return [[SKSubscriberDisposable alloc] initWithSubscriber:subscriber disposable:disposable];
}

- (id<SKDisposable>)startWithNext:(void (^)(id _Nullable))next error:(void (^)(id _Nullable))error {
    SKSubscriber *subscriber = [[SKSubscriber alloc] initWithNext:next error:error completed:nil];
    id<SKDisposable> disposable = _generator(subscriber);
    [subscriber assignDisposable:disposable];
    return [[SKSubscriberDisposable alloc] initWithSubscriber:subscriber disposable:disposable];
}

- (id<SKDisposable>)startWithNext:(void (^)(id _Nullable))next completed:(void (^)(void))completed {
    SKSubscriber *subscriber = [[SKSubscriber alloc] initWithNext:next error:nil completed:completed];
    id<SKDisposable> disposable = _generator(subscriber);
    [subscriber assignDisposable:disposable];
    return [[SKSubscriberDisposable alloc] initWithSubscriber:subscriber disposable:disposable];
}

- (id<SKDisposable>)startWithError:(void (^)(id _Nullable))error completed:(void (^)(void))completed {
    SKSubscriber *subscriber = [[SKSubscriber alloc] initWithNext:nil error:error completed:completed];
    id<SKDisposable> disposable = _generator(subscriber);
    [subscriber assignDisposable:disposable];
    return [[SKSubscriberDisposable alloc] initWithSubscriber:subscriber disposable:disposable];
}

- (id<SKDisposable>)startWithNext:(void (^)(id _Nullable))next error:(void (^)(id _Nullable))error completed:(nonnull void (^)(void))completed {
    SKSubscriber *subscriber = [[SKSubscriber alloc] initWithNext:next error:error completed:completed];
    id<SKDisposable> disposable = _generator(subscriber);
    [subscriber assignDisposable:disposable];
    return [[SKSubscriberDisposable alloc] initWithSubscriber:subscriber disposable:disposable];
}

@end
