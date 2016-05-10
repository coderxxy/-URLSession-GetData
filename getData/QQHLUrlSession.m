//
//  QQHLUrlSession.m
//  getData
//
//  Created by Jason on 16/4/15.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "QQHLUrlSession.h"
//
#import "QQHLUrlCaches.h"

@implementation QQHLUrlSession
{
    NSURLSession *_session;
}
//
- (instancetype)initf{
    if (self == [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    }
    return self;
}
/**
 *  单例对象
 *
 *  @return 单例对象
 */
+ (QQHLUrlSession *)defaultSession{
    
    static QQHLUrlSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        session = [[QQHLUrlSession alloc] init];
    });
    
    return session;
}
//get
- (void)accessServerGet:(NSString *)urlStr backHandler:(NetHandler)handeler{
    //防止中文
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
#warning mark - 处理缓存 -
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    
//    //
    NSData *cachesData = [QQHLUrlCaches getCachesDataWithUrl:urlStr];
    if (cachesData) {
        
        if (handeler) {
            handeler(cachesData, nil);
        }
        return;
    }
    //
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //如果访问服务器没有发生错误，并且url里面含有page，才能缓存数据
        if (!error &&[urlStr containsString:@"id"]) {
            [QQHLUrlCaches saveCachesDataWithUrlStr:urlStr data:data];
        }
        
        //这里拿到服务器返回结果，在这里返回。
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handeler) {
                handeler(data, error);
            }
        });
    }];
    //开始下载数据任务
    [dataTask resume];
}
//post
/**
 *  Post请求
 *
 *  @param urlStr    域名加接口
 *  @param parameter 需要拼接的字符串
 *  @param handelr   返回的data
 */
- (void)accessServerPost:(NSString *)urlStr parameters:(id)parameter backHandler:(NetHandler)handler{
    
    //防止中文
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //
    request.HTTPMethod = @"POST";
    
    NSData *body = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = body;
    
    
    NSData *cachesData = [QQHLUrlCaches getCachesDataWithUrl:urlStr];
    if (cachesData) {
        
        if (handler) {
            handler(cachesData, nil);
        }
        
        return;
    }
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //如果访问服务器没有发生错误，并且url里面含有page，才能缓存数据
        if (!error &&[urlStr containsString:@"id"]) {
            [QQHLUrlCaches saveCachesDataWithUrlStr:urlStr data:data];
        }
        
        //访问网络
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(data, error);
            }
        });
        
    }];
    //开始访问
    [dataTask resume];
}

@end
