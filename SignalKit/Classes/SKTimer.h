//
//  SKTimer.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKTimer : NSObject

@property (nonatomic, readonly) BOOL isRunning;

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval repeat:(BOOL)repeat queue:(SKQueue *_Nullable)queue block:(void (^)(SKTimer *timer))block;

- (instancetype)initWithTimeInterval:(NSTimeInterval)interval repeat:(BOOL)repeat queue:(SKQueue *_Nullable)queue block:(void (^)(SKTimer *timer))block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)start;
- (void)fire;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
