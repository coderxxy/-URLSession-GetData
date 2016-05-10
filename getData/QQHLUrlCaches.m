//
//  QQHLUrlCaches.m
//  getData
//
//  Created by Jason on 16/4/15.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "QQHLUrlCaches.h"

@implementation QQHLUrlCaches
#pragma mark - 保存缓存数据 -
+ (void)saveCachesDataWithUrlStr:(NSString *)urlStr data:(NSData *)data{
    //拆分url链接
    NSArray *urlArr = [urlStr componentsSeparatedByString:@"?"];
    
    //NSString *theUrlPro = urlArr[0];
    NSString *paraMeterStr = urlArr[1];
    //获取page参数值
    NSDictionary *paraDic = [self paraMeterDicWithStr:paraMeterStr];
    
    //NSString *pageStr = paraDic[@"page"];
    NSString *pageStr = paraDic[@"id"];
    
    //获取这条链接的存储路径
    NSString *thisUrlProPath= [self getPathWithUrlPro:urlStr];
    //获取日期保存路径, 数据保存路径
    NSString *datePath = [thisUrlProPath stringByAppendingFormat:@"/%@.txt", pageStr];
    NSString *dataPath = [thisUrlProPath stringByAppendingFormat:@"/%@.png", pageStr];
    
    //获取当前时间的毫秒数
    NSString *currentTime = [self getTimeStamp];
    
    //创建中间路径
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:thisUrlProPath]) {
        
        [fm createDirectoryAtPath:thisUrlProPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"thisUrlProPath:%@", thisUrlProPath);
    //写入缓存数据
    //写入当前时间
    [currentTime writeToFile:datePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    //写入数据
    [data writeToFile:dataPath atomically:NO];
}

#pragma mark - 访问缓存数据 -

+ (id)getCachesDataWithUrl:(NSString *)urlStr{
    
    //拆分url链接
    NSArray *urlArr = [urlStr componentsSeparatedByString:@"?"];
    //
    //NSString *theUrlPro = urlArr[0];
    NSString *paraMeterStr = urlArr[1];
    
    //获取page参数值
    NSDictionary *paraDic = [self paraMeterDicWithStr:paraMeterStr];
    //NSString *pageStr = paraDic[@"page"];
    NSString *pageStr = paraDic[@"id"];
    
    
    //获取这条链接的存储路径
    NSString *thisUrlProPath= [self getPathWithUrlPro:urlStr];
    //获取日期保存路径, 数据保存路径
    NSString *datePath = [thisUrlProPath stringByAppendingFormat:@"/%@.txt", pageStr];
    
    //获取上次加载数据的时间
    NSString *lastLoadTime = [NSString stringWithContentsOfFile:datePath encoding:NSUTF8StringEncoding error:nil];
    //如果没有上次访问时间记录，说明没有缓存数据
    if (!lastLoadTime) {
        return nil;
    }
    //获取当前时间和上次记录时间对比，判断是否超时
    NSString *currentTime = [self getTimeStamp];
    //时间差 如果超时返回nil 则访问网络;再次拿到服务器数据，会覆盖当前数据(毫秒)
#warning mark - 超出这个时间则缓存失效,重新加载数据 -
    if (currentTime.doubleValue - lastLoadTime.doubleValue > 6000) {
        return nil;
    }
    //获取上次缓存的数据
    NSString *dataPath = [thisUrlProPath stringByAppendingFormat:@"/%@.png", pageStr];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    
    return data;
}

#pragma mark -  -

//获取时间戳
+ (NSString *)getTimeStamp{
    NSTimeInterval time = [[[NSDate alloc] init]timeIntervalSince1970];
    NSString *timeStr = [NSString stringWithFormat:@"%f", time];
    return timeStr;
}

//参数字符串拆分成一个参数字典
+ (NSDictionary *)paraMeterDicWithStr:(NSString *)paraMeterStr{
    NSArray *keyValuePairs = [paraMeterStr componentsSeparatedByString:@"&"];
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    for (NSString *onePair in keyValuePairs) {
        
        NSArray *pairArr = [onePair componentsSeparatedByString:@"="];
        
        [paraDic addEntriesFromDictionary:@{pairArr[0]:pairArr[1]}];
    }
    return paraDic;
}

//获取当前链接存储日期的路径
+ (NSString *)getPathWithUrlPro:(NSString *)urlPro{
    
    NSString *sandBoxPath = [self getSandBoxCachesPath];
    NSString *path = [NSString stringWithFormat:@"%@/%@", sandBoxPath, urlPro];
    
    return path;
}

//获取沙盒缓存总路径
+ (NSString *)getSandBoxCachesPath{
    return [NSString stringWithFormat:@"%@/Library/Caches/MyCaches", NSHomeDirectory()];
}

@end
