//
//  NSObject+RFEvent.h
//  RFEventDemo
//
//  Created by GZH on 16/4/3.
//  Copyright © 2016年 GZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFEvent.h"

/*
 RFEvent说明：
 1、不要在block用self，因self保存block，如果不手工Unwatch，100%会循环引用。用传入的selfRef代替。
	(这里的循环引用逻辑上是正确的，监听事件如果不手工注销，永远没有一个时点结束自身。因此如果block有self强引用，self将得不到时点释放。)
 2、所有回调均在主线程执行。
 3、注册事件适合在viewDidAppear，取消事件适合在viewWillDisappear，减少BUG产生。
 4、集中注册事件时，简单事件处理适合使用block, 复杂事件处理适合selector
 5、事件注销不是必要操作，对象被释放时自动注销
 */

@interface NSObject (RFEvent)

- (RFEvent *)rfEvent;

// 不要在block用self，因self保存block，100%会循环引用。用传入的selfRef
- (void)rfWatchObject:(id)object event:(NSString *)event mainBlock:(RFNotifyBlock)block;
- (void)rfWatchObject:(id)object event:(NSString *)event level:(double)level mainBlock:(RFNotifyBlock)block;
- (void)rfWatchObject:(id)object keyPath:(NSString *)keyPath mainBlock:(RFKvoBlock)block;
- (void)rfWatchObject:(id)object keyPath:(NSString *)keyPath level:(double)level mainBlock:(RFKvoBlock)block;

- (void)rfUnwatchEvents;
- (void)rfUnwatchObject:(id)object;

- (void)rfUnwatchObject:(id)object event:(NSString *)event;
- (void)rfUnwatchObject:(id)object event:(NSString *)event level:(double)level;

- (void)rfUnwatchObject:(id)object keyPath:(NSString *)keyPath;
- (void)rfUnwatchObject:(id)object keyPath:(NSString *)keyPath level:(double)level;

- (void)rfPostEvent:(NSString *)event userInfo:(NSDictionary *)userInfo;

@end

