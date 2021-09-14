//
//  SKBag.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKBag<__covariant ObjectType> : NSObject

- (NSInteger)addItem:(ObjectType)item;
- (void)enumerateItems:(void (^)(ObjectType))block;
- (void)removeItemForKey:(NSInteger)key;
- (BOOL)isEmpty;
- (NSArray<ObjectType> *)allItems;

@end

NS_ASSUME_NONNULL_END
