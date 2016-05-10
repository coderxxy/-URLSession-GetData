//
//  QQHLUrlSession.h
//  getData
//
//  Created by Jason on 16/4/15.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
//
typedef void(^NetHandler)(id, NSError *);

@interface QQHLUrlSession : NSObject

/**
 *  单例
 *
 *  @return 返回单例对象
 */
+ (QQHLUrlSession *)defaultSession;

/**
 *  网络请求数据
 *
 *  @param urlStr   网络url
 *  @param handeler 返回的结果
 */
//get
- (void)accessServerGet:(NSString *)urlStr backHandler:(NetHandler)handeler;


//post
- (void)accessServerPost:(NSString *)urlStr parameters:(id)parameter backHandler:(NetHandler)handler;


@end
