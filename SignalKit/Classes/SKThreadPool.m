//
//  SKThreadPool.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/15.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKThreadPool.h"
#import "SKAtomic.h"
#import <pthread/pthread.h>

@implementation SKThreadPoopTaskState {
    @public
    SKAtomic<NSNumber *> *_cancelled;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cancelled = [SKAtomic atomicWithValue:@(NO)];
    }
    return self;
}

- (BOOL)isCancelled {
    return _cancelled.value.boolValue;
}

@end

@implementation SKThreadPoopTask {
    SKThreadPoopTaskState *_state;
    void (^_block)(SKThreadPoopTaskState *);
}

+ (instancetype)taskWithBlock:(void (^)(SKThreadPoopTaskState * _Nonnull))block {
    return [[self alloc] initWithBlock:block];
}

- (instancetype)initWithBlock:(void (^)(SKThreadPoopTaskState * _Nonnull))block {
    self = [super init];
    if (self) {
        NSParameterAssert(block);
        _state = [[SKThreadPoopTaskState alloc] init];
        _block = [block copy];
    }
    return self;
}

- (void)execute {
    if (!_state.isCancelled) {
        _block(_state);
    }
}

- (void)cancel {
    [_state->_cancelled swap:@(YES)];
}

@end

@interface SKThreadPool ()

- (void)workOnQueue:(SKThreadPoolQueue *)queue block:(void (^)(void))block;

@end

@implementation SKThreadPoolQueue {
    __weak SKThreadPool *_threadPool;
    NSMutableArray<SKThreadPoopTask *> *_tasks;
}

- (instancetype)initWithThreadPool:(SKThreadPool *)threadPool {
    self = [super init];
    if (self) {
        _threadPool = threadPool;
        _tasks = @[].mutableCopy;
    }
    return self;
}

- (void)addTask:(SKThreadPoopTask *)task {
    if (_threadPool) {
        [_threadPool workOnQueue:self block:^{
            [self->_tasks addObject:task];
        }];
    }
}

- (SKThreadPoopTask *)popFirstTask {
    SKThreadPoopTask *task = _tasks.firstObject;
    if (task) {
        [_tasks removeObjectAtIndex:0];
    }
    return task;
}

- (BOOL)hasTasks {
    return _tasks.count;
}

@end


@implementation SKThreadPool {
    pthread_mutex_t _lock;
    pthread_cond_t _cond;
    NSArray<NSThread *> *_threads;
    NSMutableArray<SKThreadPoolQueue *> *_queues;
    NSMutableArray<SKThreadPoolQueue *> *_takenQueues;
}

+ (void)threadEntryPoint:(SKThreadPool *)threadPool {
    SKThreadPoolQueue *queue;
    
    while (true) {
        SKThreadPoopTask *task;
        
        pthread_mutex_lock(&threadPool->_lock);
        
        if (queue) {
            NSUInteger index = [threadPool->_takenQueues indexOfObject:queue];
            if (index != NSNotFound) {
                [threadPool->_takenQueues removeObjectAtIndex:index];
            }
            
            if ([queue hasTasks]) {
                [threadPool->_queues addObject:queue];
            }
        }
        
        while (true) {
            while (threadPool->_queues.count == 0) {
                pthread_cond_wait(&threadPool->_cond, &threadPool->_lock);
            }
            
            if (threadPool->_queues.count != 0) {
                queue = threadPool->_queues.firstObject;
            }
            
            if (queue) {
                task = [queue popFirstTask];
                [threadPool->_takenQueues addObject:queue];
                
                NSUInteger index = [threadPool->_queues indexOfObject:queue];
                if (index != NSNotFound) {
                    [threadPool->_queues removeObjectAtIndex:index];
                }
                
                break;
            }
        }
        
        pthread_mutex_unlock(&threadPool->_lock);
        
        if (task) {
            @autoreleasepool {
                [task execute];
            }
        }
    }
}

- (instancetype)initWithThreadCount:(NSUInteger)threadCount threadPriority:(double)threadPriority {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        pthread_cond_init(&_cond, NULL);
        
        _queues = @[].mutableCopy;
        _takenQueues = @[].mutableCopy;
        
        NSMutableArray<NSThread *> *threads = @[].mutableCopy;
        for (int i = 0; i < threadCount; i ++) {
            NSThread *thread = [[NSThread alloc] initWithTarget:self.class selector:@selector(threadEntryPoint:) object:self];
            thread.threadPriority = threadPriority;
            [threads addObject:thread];
            [thread start];
        }
        _threads = [threads copy];
        
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
    pthread_cond_destroy(&_cond);
}

- (void)addTask:(SKThreadPoopTask *)task {
    SKThreadPoolQueue *tempQueue = [self nextQueue];
    [tempQueue addTask:task];
}

- (void)workOnQueue:(SKThreadPoolQueue *)queue block:(void (^)(void))block {
    pthread_mutex_lock(&_lock);
    block();
    if (![_queues containsObject:queue] && ![_takenQueues containsObject:queue]) {
        [_queues addObject:queue];
    }
    pthread_cond_broadcast(&_cond);
    pthread_mutex_unlock(&_lock);
}

- (SKThreadPoolQueue *)nextQueue {
    return [[SKThreadPoolQueue alloc] initWithThreadPool:self];
}

- (BOOL)isCurrentThreadInPool {
    NSThread *currentThread = [NSThread currentThread];
    for (NSThread *thread in _threads) {
        if ([currentThread isEqual:thread]) {
            return YES;
        }
    }
    return NO;
}

@end
