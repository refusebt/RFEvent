//
//  NSObject+RFEvent.m
//  RFEventDemo
//
//  Created by GZH on 16/4/3.
//  Copyright © 2016年 GZH. All rights reserved.
//

#import "NSObject+RFEvent.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (RFEvent)

- (RFEvent *)rfEvent
{
	static void * kRFEventKey = "kRFEventKey";
	RFEvent *rfEvent = (RFEvent *)objc_getAssociatedObject(self, kRFEventKey);
	if (rfEvent == nil)
	{
		rfEvent = [[RFEvent alloc] initWithObserverObject:self];
		objc_setAssociatedObject(self, kRFEventKey, rfEvent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return rfEvent;
}

- (void)rfWatchObject:(id)object event:(NSString *)event mainBlock:(RFNotifyBlock)block
{
	[[self rfEvent] addNotifyEvent:event watchObject:object observerObject:self level:RFEventLevelDefault block:block];
}

- (void)rfWatchObject:(id)object event:(NSString *)event level:(double)level mainBlock:(RFNotifyBlock)block
{
	[[self rfEvent] addNotifyEvent:event watchObject:object observerObject:self level:level block:block];
}

- (void)rfWatchObject:(id)object keyPath:(NSString *)keyPath mainBlock:(RFKvoBlock)block
{
	[[self rfEvent] addKeyPath:keyPath watchObject:object observerObject:self level:RFEventLevelDefault block:block];
}

- (void)rfWatchObject:(id)object keyPath:(NSString *)keyPath level:(double)level mainBlock:(RFKvoBlock)block
{
	[[self rfEvent] addKeyPath:keyPath watchObject:object observerObject:self level:level block:block];
}

- (void)rfUnwatchEvents
{
	[[self rfEvent] removeNotifyEvent:nil watchObject:nil ignoreLevel:YES level:0];
	[[self rfEvent] removeKvoEvent:nil watchObject:nil ignoreLevel:YES level:0];
}

- (void)rfUnwatchObject:(id)object
{
	[[self rfEvent] removeNotifyEvent:nil watchObject:object ignoreLevel:YES level:0];
	[[self rfEvent] removeKvoEvent:nil watchObject:object ignoreLevel:YES level:0];
}

- (void)rfUnwatchObject:(id)object event:(NSString *)event
{
	[[self rfEvent] removeNotifyEvent:event watchObject:object ignoreLevel:YES level:0];
}

- (void)rfUnwatchObject:(id)object event:(NSString *)event level:(double)level
{
	[[self rfEvent] removeNotifyEvent:event watchObject:object ignoreLevel:YES level:level];
}

- (void)rfUnwatchObject:(id)object keyPath:(NSString *)keyPath
{
	[[self rfEvent] removeKvoEvent:keyPath watchObject:object ignoreLevel:YES level:0];
}

- (void)rfUnwatchObject:(id)object keyPath:(NSString *)keyPath level:(double)level
{
	[[self rfEvent] removeKvoEvent:keyPath watchObject:object ignoreLevel:YES level:level];
}

- (void)rfPostEvent:(NSString *)event userInfo:(NSDictionary *)userInfo
{
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:event object:self userInfo:userInfo];
}

@end
