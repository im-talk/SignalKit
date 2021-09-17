//
//  SKThreadPool.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/15.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SKThreadPool;

@interface SKThreadPoopTaskState : NSObject

@property (nonatomic, readonly) BOOL isCancelled;

@end

@interface SKThreadPoopTask : NSObject

+ (instancetype)taskWithBlock:(void (^)(SKThreadPoopTaskState *state))block;

- (instancetype)initWithBlock:(void (^)(SKThreadPoopTaskState *state))block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

- (void)execute;
- (void)cancel;

@end

@interface SKThreadPoolQueue : NSObject

- (instancetype)initWithThreadPool:(SKThreadPool *)threadPool NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

- (void)addTask:(SKThreadPoopTask *)task;

@end

@interface SKThreadPool : NSObject

- (instancetype)initWithThreadCount:(NSUInteger)threadCount threadPriority:(double)threadPriority NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

- (void)addTask:(SKThreadPoopTask *)task;

- (SKThreadPoolQueue *)nextQueue;

- (BOOL)isCurrentThreadInPool;

@end

NS_ASSUME_NONNULL_END
