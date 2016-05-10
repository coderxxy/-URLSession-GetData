//
//  QQHLUrlCaches.h
//  getData
//
//  Created by Jason on 16/4/15.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QQHLUrlCaches : NSObject
/**
 *  存储url对应的缓存数据
 *
 *  @param urlStr 当前的url
 *  @param data   url请求到的数据
 */
+ (void)saveCachesDataWithUrlStr:(NSString *)urlStr data:(NSData *)data;

/**
 *  获取缓存数据的接口。里面会判断里面是否需要获取缓存数据
 *
 *  @param urlStr 挡圈url
 *
 *  @return 上次缓存的数据
 */
+ (id)getCachesDataWithUrl:(NSString *)urlStr;

@end
