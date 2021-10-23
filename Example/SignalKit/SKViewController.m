//
//  SKViewController.m
//  SignalKit
//
//  Created by xue03106991 on 09/03/2021.
//  Copyright (c) 2021 xue03106991. All rights reserved.
//

#import "SKViewController.h"
#import <SignalKit/SignalKit.h>

#import "SKSignal+Meta.h"


@interface SKViewController ()

@property (nonatomic) SKSignal<NSNumber *, NSString *> *signal;

@property (nonatomic) SKPipe<NSNumber *> *pipe;

@property (nonatomic) SKTimer *timer;

@property (nonatomic) SKThreadPool *threadPool;

@end

@implementation SKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.signal = [[[[[[[[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
//        [subscriber putNext:@(1)];
//        [subscriber putNext:@(2)];
//        [subscriber putNext:@(3)];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [subscriber putCompletion];
//
//        });
//        return [[SKBlockDisposable alloc] initWithBlock:^{
//            NSLog(@"disposed");
//        }];
//    }] onStart:^{
//        NSLog(@"on start");
//    }] afterNext:^(id  _Nullable value) {
//        NSLog(@"after next %@", value);
//    }] onNext:^(id  _Nullable value) {
//        NSLog(@"on next %@", value);
//    }] onDispose:^{
//        NSLog(@"on dispose");
//    }] onCompletion:^{
//        NSLog(@"on completion");
//    }] afterCompletion:^{
//        NSLog(@"after completion");
//    }] ;
//    self.signal = [SKSignal fail:@123];
//
//    [self.signal startWithNext:^(NSNumber * _Nullable value) {
//            NSLog(@"%@", value);
//        } error:^(id  _Nullable error) {
//            NSLog(@"%@", error);
//        } completed:^{
//            NSLog(@"completed");
//        }] ;

//    SKQueue *q1 = [[SKQueue alloc] initWithUnderlyingQueue:dispatch_get_main_queue()];
//    SKQueue *q2 = [SKQueue concurrentBackgroundQueue];
    
//    dispatch_async(q2.underlyingQueue, ^{
////        NSLog(@"q1 %@", q1);
//        NSLog(@"q2 %@", q2);
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            NSLog(@"q1 %@", q1);
//            NSLog(@"q2 %@", q2);
//        });
//    });
    //    id<SKDisposable> disposable = [[self.signal distinctUntilChangedWithBlock:^BOOL(id  _Nonnull value, id  _Nonnull lastValue) {
//        return [value isKindOfClass:NSNumber.class] && [lastValue isKindOfClass:NSNumber.class];
//    }] startWithNext:^(NSNumber * _Nullable value) {
//        NSLog(@"%@", value);
//    } error:^(NSString * _Nullable error) {
//        NSLog(@"%@", error);
//    } completed:^{
//        NSLog(@"completed");
//
//    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [disposable dispose];
//    });
    

//    _timer = timer;
    
//    self.signal = [SKSignal signalWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
//        [subscriber putNext:@1];
//        [subscriber putNext:@2];
//        [subscriber putNext:@3];
//        return nil;
//    }];
//
//    self.signal = [self.signal takeWhile:^SKSignalTakeAction * _Nonnull(NSNumber * _Nullable value) {
//        SKSignalTakeAction *action = [SKSignalTakeAction new];
//        if (value.integerValue == 1) {
//            action.complete = YES;
//        }
//        if (value.integerValue == 3) {
//            action.complete = YES;
//        }
//        return action;
//    }];
//
//    [self.signal startWithNext:^(NSNumber * _Nullable value) {
//        NSLog(@"value %@", value);
//    } error:^(NSString * _Nullable error) {
//        NSLog(@"error %@", error);
//    } completed:^{
//        NSLog(@"completed");
//    }];
    
//    self.threadPool = [[SKThreadPool alloc] initWithThreadCount:3 threadPriority:0.5];
//
//    SKQueue *queue = [SKQueue concurrentDefaultQueue];
//    [queue async:^{
//        self.signal = [SKSignal signalWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
//            [queue async:^{
//                [subscriber putNext:@1];
//                [subscriber putCompletion];
//
//            }];
//            return nil;
//        }];
////        self.signal = [[self.signal runOnQueue:SKQueue.mainQueue] deliverOnMainQueue];
//        self.signal = [[self.signal runOnThreadPool:self.threadPool] deliverOnQueue:SKQueue.mainQueue];
//
//        [self.signal startWithNext:^(NSNumber * _Nullable value) {
//            NSLog(@"value %@", value);
//        } error:^(NSString * _Nullable error) {
//            NSLog(@"error %@", error);
//        } completed:^{
//            NSLog(@"completed");
//        }];
//
//    }];
//
//    SKSignal *signal = [SKSignal signalWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
//        [subscriber putNext:@1];
//        [subscriber putNext:@2];
//        [subscriber putCompletion];
//        [subscriber putError:nil];
//        [subscriber putCompletion];
//        [subscriber putNext:@1];
//        [subscriber putNext:@(1)];
//        return nil;
//    }];
//
//    [signal startWithNext:^(id  _Nullable value) {
//        NSLog(@"%@", value);
//    } error:^(id  _Nullable error) {
//        NSLog(@"%@", error);
//    } completed:^{
//
//    }];

//    SKThreadPoolQueue *queue = [self.threadPool nextQueue];
//    for (int i = 0; i < 10; i ++) {
//        SKThreadPoopTask *task = [SKThreadPoopTask taskWithBlock:^(SKThreadPoopTaskState * _Nonnull state) {
//            [NSThread sleepForTimeInterval:1];
//            NSLog(@"task %i", i);
//        }];
//        [queue addTask:task];
//    }
   
    self.signal = [SKSignal defer:^SKSignal * _Nonnull{
//        NSLog(@"123");
        
        return [SKSignal signalWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
            [subscriber putNext:@1];
            [subscriber putCompletion];
            return nil;
        }];
    }];
    
    self.signal = [[SKSignal signalWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        [subscriber putNext:@1];
        [subscriber putCompletion];
        return nil;
    }] onStart:^{
        NSLog(@"123");

    }];
    
    [ self.signal startWithNext:^(id  _Nullable value) {
        NSLog(@"%@", value);
    } error:^(id  _Nullable error) {
        NSLog(@"%@", error);
    } completed:^{
        NSLog(@"completed");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
