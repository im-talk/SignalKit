//
//  SKQueue.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKQueue : NSObject

@property (nonatomic, class, readonly) SKQueue *mainQueue;
@property (nonatomic, class, readonly) SKQueue *concurrentDefaultQueue;
@property (nonatomic, class, readonly) SKQueue *concurrentBackgroundQueue;

@property (nonatomic, readonly) dispatch_queue_t underlyingQueue;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) dispatch_qos_class_t qos;
@property (nonatomic, readonly) BOOL isConcurrent;

- (instancetype)initWithUnderlyingQueue:(dispatch_queue_t)underlyingQueue;
- (instancetype)initWithName:(NSString *_Nullable)name concurrent:(BOOL)concurrent qos:(dispatch_qos_class_t)qos;

- (BOOL)isCurrent;

- (void)async:(void (^)(void))block;
- (void)sync:(void (NS_NOESCAPE ^)(void))block;
- (void)delay:(NSTimeInterval)seconds execute:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
