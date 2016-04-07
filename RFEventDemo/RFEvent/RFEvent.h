//
//  RFEvent.h
//  RFEventDemo
//
//  Created by GZH on 16/4/3.
//  Copyright © 2016年 GZH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RFEvent;
@class RFEventObject;
@class RFNotifyEvent;
@class RFKvoEvent;
@class RFEventObjectInfo;
@class RFNotifyEventInfo;
@class RFKvoEventInfo;

#define RFEventLevelDefault						1000.0f

typedef void (^RFNotifyBlock) (NSNotification *note, id selfRef);
typedef void (^RFKvoBlock) (NSString *keyPath, id object, NSDictionary<NSString *,id> *change, id selfRef);

#pragma mark - RFEvent

@interface RFEvent : NSObject
@property (nonatomic, strong) NSMutableDictionary *notifyMap;	// key:通知名_watchObject value:RFNotifyEvent
@property (nonatomic, strong) NSMutableDictionary *kvoMap;		// key:属性名_watchObject value:RFKvoEvent
@property (nonatomic, weak) id observerObject;					// selfRef

- (id)initWithObserverObject:(id)observerObject;

//////////////////////////////////////////
// Notify
//////////////////////////////////////////

- (void)addNotifyEvent:(RFNotifyEvent *)ne forKey:(NSString *)key;
- (void)removeNotifyEventKey:(NSString *)key;

- (void)addNotifyEvent:(NSString *)event
		   watchObject:(id)watchObject
		observerObject:(id)observerObject
				 level:(double)level
				 block:(RFNotifyBlock)block;

// 可以单独移除某一优先级的回调，event不为空，bIgnoreLevel为YES
- (void)removeNotifyEvent:(NSString *)event watchObject:(id)watchObject
			  ignoreLevel:(BOOL)bIgnoreLevel level:(double)level;

//////////////////////////////////////////
// KVO
//////////////////////////////////////////

- (void)addKvoEvent:(RFKvoEvent *)ke forKey:(NSString *)key;
- (void)removeKvoEventKey:(NSString *)key;

- (void)addKeyPath:(NSString *)keyPath
	   watchObject:(id)watchObject
	observerObject:(id)observerObject
			 level:(double)level
			 block:(RFKvoBlock)block;

- (void)removeKvoEvent:(NSString *)keyPath watchObject:(id)watchObject
			  ignoreLevel:(BOOL)bIgnoreLevel level:(double)level;

@end

#pragma mark - RFEventObject 承载监听

@interface RFEventObject : NSObject
@property (nonatomic, weak) RFEvent *rfEvent;
@property (nonatomic, weak) id watchObject;				// 被观察对象
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSMutableArray *eventInfos;

- (id)initWithRFEvent:(RFEvent *)rfEvent event:(NSString *)event watchObject:(id)watchObject;

- (void)add:(RFEventObjectInfo *)info;
- (void)removeLevel:(double)level;

@end

#pragma mark - RFNotifyEvent 承载监听

@interface RFNotifyEvent : RFEventObject
@property (nonatomic, weak) id sysObserverObj;
- (void)handleRFEventBlockCallback:(NSNotification *)note;
@end

#pragma mark - RFKvoEvent 承载监听

@interface RFKvoEvent : RFEventObject

@end

#pragma mark - RFEventObjectInfo

@interface RFEventObjectInfo : NSObject
@property (nonatomic, assign) double level;
@end

#pragma mark - RFNotifyEventInfo

@interface RFNotifyEventInfo : RFEventObjectInfo
@property (nonatomic, copy) RFNotifyBlock block;
@end

#pragma mark - RFKvoEventInfo

@interface RFKvoEventInfo : RFEventObjectInfo
@property (nonatomic, copy) RFKvoBlock block;
@end
