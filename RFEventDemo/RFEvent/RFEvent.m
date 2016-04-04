//
//  RFEvent.m
//  RFEventDemo
//
//  Created by GZH on 16/4/3.
//  Copyright © 2016年 GZH. All rights reserved.
//

#import "RFEvent.h"

#pragma mark - RFEvent

@implementation RFEvent

- (id)initWithObserverObject:(id)observerObject
{
	self = [super init];
	if (self)
	{
		_notifyMap = [NSMutableDictionary dictionary];
		_kvoMap = [NSMutableDictionary dictionary];
		_observerObject = observerObject;
	}
	return self;
}

- (void)dealloc
{
	[self removeNotifyEvent:nil watchObject:nil ignoreLevel:YES level:0];
	[self removeKvoEvent:nil watchObject:nil ignoreLevel:YES level:0];
}

- (void)addNotifyEvent:(RFNotifyEvent *)ne forKey:(NSString *)key
{
	self.notifyMap[key] = ne;
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	__weak RFNotifyEvent *neRef = ne;
	ne.sysObserverObj = [nc addObserverForName:ne.event
										object:ne.watchObject
										 queue:[NSOperationQueue mainQueue]
									usingBlock:^(NSNotification *note){
										[neRef handleRFEventBlockCallback:note];
									}];
}

- (void)removeNotifyEventKey:(NSString *)key
{
	RFNotifyEvent *ne = self.notifyMap[key];

	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	if (ne.sysObserverObj != nil)
	{
		[nc removeObserver:ne.sysObserverObj];
		ne.sysObserverObj = nil;
	}
	
	[self.notifyMap removeObjectForKey:key];
}

- (void)addNotifyEvent:(NSString *)event
		   watchObject:(id)watchObject
		observerObject:(id)observerObject
				 level:(double)level
				 block:(RFNotifyBlock)block
{
	NSString *key = [NSString stringWithFormat:@"%@_%p", event, watchObject];
	RFNotifyEvent *ne = [self.notifyMap objectForKey:key];
	if (ne == nil)
	{
		// 添加监听
		ne = [[RFNotifyEvent alloc] initWithRFEvent:self event:event watchObject:watchObject];
		[self addNotifyEvent:ne forKey:key];
	}
	
	RFNotifyEventInfo *nei = [[RFNotifyEventInfo alloc] init];
	nei.level = level;
	nei.block = block;
	[ne add:nei];
}

- (void)removeNotifyEvent:(NSString *)event watchObject:(id)watchObject
			  ignoreLevel:(BOOL)bIgnoreLevel level:(double)level
{
	if (event == nil && watchObject == nil)
	{
		// 移除掉所有
		NSArray *keys = [self.notifyMap allKeys];
		for (NSString *key in keys)
		{
			[self removeNotifyEventKey:key];
		}
	}
	else if (event != nil && watchObject == nil)
	{
		NSArray *keys = [self.notifyMap allKeys];
		for (NSString *key in keys)
		{
			RFNotifyEvent *ne = self.notifyMap[key];
			if ([ne.event isEqualToString:event])
			{
				[self removeNotifyEventKey:key];
			}
		}
	}
	else if (event == nil && watchObject != nil)
	{
		NSArray *keys = [self.notifyMap allKeys];
		for (NSString *key in keys)
		{
			RFNotifyEvent *ne = self.notifyMap[key];
			if (ne.watchObject == watchObject)
			{
				[self removeNotifyEventKey:key];
			}
		}
	}
	else
	{
		NSArray *keys = [self.notifyMap allKeys];
		for (NSString *key in keys)
		{
			RFNotifyEvent *ne = self.notifyMap[key];
			if ([ne.event isEqualToString:event]
				&& ne.watchObject == watchObject)
			{
				if (bIgnoreLevel)
				{
					[self removeNotifyEventKey:key];
				}
				else
				{
					[ne removeLevel:level];
					if (ne.eventInfos.count == 0)
					{
						[self removeNotifyEventKey:key];
					}
				}
				break;
			}
		}
	}
}

- (void)addKvoEvent:(RFKvoEvent *)ke forKey:(NSString *)key
{
	self.kvoMap[key] = ke;
	
	[ke.watchObject addObserver:self forKeyPath:ke.event options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeKvoEventKey:(NSString *)key
{
	RFKvoEvent *ke = self.kvoMap[key];
	
	[ke.watchObject removeObserver:self forKeyPath:ke.event];
	
	[self.kvoMap removeObjectForKey:key];
}

- (void)addKeyPath:(NSString *)keyPath
	   watchObject:(id)watchObject
	observerObject:(id)observerObject
			 level:(double)level
			 block:(RFKvoBlock)block
{
	NSString *key = [NSString stringWithFormat:@"%@_%p", keyPath, watchObject];
	RFKvoEvent *ke = [self.kvoMap objectForKey:key];
	if (ke == nil)
	{
		// 添加监听
		ke = [[RFKvoEvent alloc] initWithRFEvent:self event:keyPath watchObject:watchObject];
		[self addKvoEvent:ke forKey:key];
	}
	
	RFKvoEventInfo *kei = [[RFKvoEventInfo alloc] init];
	kei.level = level;
	kei.block = block;
	[ke add:kei];
}

- (void)removeKvoEvent:(NSString *)keyPath watchObject:(id)watchObject
			  ignoreLevel:(BOOL)bIgnoreLevel level:(double)level
{
	if (keyPath == nil && watchObject == nil)
	{
		// 移除掉所有
		NSArray *keys = [self.kvoMap allKeys];
		for (NSString *key in keys)
		{
			[self removeKvoEventKey:key];
		}
	}
	else if (keyPath != nil && watchObject == nil)
	{
		NSArray *keys = [self.kvoMap allKeys];
		for (NSString *key in keys)
		{
			RFKvoEvent *ke = self.kvoMap[key];
			if ([ke.event isEqualToString:keyPath])
			{
				[self removeKvoEventKey:key];
			}
		}
	}
	else if (keyPath == nil && watchObject != nil)
	{
		NSArray *keys = [self.kvoMap allKeys];
		for (NSString *key in keys)
		{
			RFKvoEvent *ke = self.kvoMap[key];
			if (ke.watchObject == watchObject)
			{
				[self removeKvoEventKey:key];
			}
		}
	}
	else
	{
		NSArray *keys = [self.kvoMap allKeys];
		for (NSString *key in keys)
		{
			RFKvoEvent *ke = self.kvoMap[key];
			if ([ke.event isEqualToString:keyPath]
				&& ke.watchObject == watchObject)
			{
				if (bIgnoreLevel)
				{
					[self removeKvoEventKey:key];
				}
				else
				{
					[ke removeLevel:level];
					if (ke.eventInfos.count == 0)
					{
						[self removeKvoEventKey:key];
					}
				}
				break;
			}
		}
	}
}

@end

#pragma mark - RFEventObject

@implementation RFEventObject

- (id)initWithRFEvent:(RFEvent *)rfEvent event:(NSString *)event watchObject:(id)watchObject
{
	self = [super init];
	if (self)
	{
		_rfEvent = rfEvent;
		_event = event;
		_watchObject = watchObject;
		_eventInfos = [NSMutableArray array];
	}
	return self;
}

- (void)add:(RFEventObjectInfo *)info
{
	BOOL bAdd = NO;
	for (NSInteger i = 0; i < self.eventInfos.count; i++)
	{
		RFEventObjectInfo *eoi = self.eventInfos[i];
		if (eoi.level == info.level)
		{
			[self.eventInfos replaceObjectAtIndex:i withObject:info];
			bAdd = YES;
			break;
		}
		else if (eoi.level > info.level)
		{
			[self.eventInfos insertObject:info atIndex:i];
			bAdd = YES;
			break;
		}
	}
	if (!bAdd)
	{
		[self.eventInfos addObject:info];
	}
}

- (void)removeLevel:(double)level
{
	for (NSInteger i = 0; i < self.eventInfos.count; i++)
	{
		RFEventObjectInfo *eoi = self.eventInfos[i];
		if (eoi.level == level)
		{
			[self.eventInfos removeObjectAtIndex:i];
			break;
		}
	}
}

@end

#pragma mark - RFNotifyEvent

@implementation RFNotifyEvent

- (void)handleRFEventBlockCallback:(NSNotification *)note
{
	for (NSInteger i = self.eventInfos.count-1; i >= 0; i--)
	{
		RFNotifyEventInfo *nei = self.eventInfos[i];
		if (nei.block != nil)
		{
			nei.block(note, self.rfEvent.observerObject);
		}
	}
}

@end

#pragma mark - RFKvoEvent

@implementation RFKvoEvent

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
	if ([NSThread isMainThread])
	{
		[self _observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
	else
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			[self _observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		});
	}
}

- (void)_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
	for (NSInteger i = self.eventInfos.count-1; i >= 0; i--)
	{
		RFKvoEventInfo *kei = self.eventInfos[i];
		if (kei.block != nil)
		{
			kei.block(keyPath, object, change, self.rfEvent.observerObject);
		}
	}
}

@end

#pragma mark - RFEventObjectInfo

@implementation RFEventObjectInfo

@end

#pragma mark - RFNotifyEventInfo

@implementation RFNotifyEventInfo

@end

#pragma mark - RFKvoEventInfo

@implementation RFKvoEventInfo

@end
