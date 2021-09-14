//
//  SKBag.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKBag.h"

@implementation SKBag {
    NSInteger _nextKey;
    NSMutableArray *_items;
    NSMutableArray *_itemKeys;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = @[].mutableCopy;
        _itemKeys = @[].mutableCopy;
    }
    return self;
}

- (NSInteger)addItem:(id)item {
    if (!item) {
        return -1;
    }
    
    NSInteger key = _nextKey;
    [_items addObject:item];
    [_itemKeys addObject:@(key)];
    _nextKey ++;
    
    return key;
}

- (void)enumerateItems:(void (^)(id _Nonnull))block {
    if (block) {
        for (id item in _items) {
            block(item);
        }
    }
}

- (void)removeItemForKey:(NSInteger)key {
    NSUInteger index = 0;
    for (NSNumber *itemKey in _itemKeys) {
        if (itemKey.integerValue == key) {
            [_items removeObjectAtIndex:index];
            [_itemKeys removeObjectAtIndex:index];
            break;
        }
        index ++;
    }
}

- (BOOL)isEmpty {
    return _items.count == 0;
}

- (NSArray *)allItems {
    return _items.copy;
}

@end
