//
//  GetData.h
//  getData
//
//  Created by Jason on 16/4/15.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
//
#import "QQHLUrlSession.h"

@interface GetData : NSObject
//
typedef void(^getNetData)(id, NSError *error);
//如果需要后期继续定义需要的block

@end
