//
//  HTTPSession.h
//  Linker
//
//  Created by spenly.jia on 2017/3/12.
//  Copyright © 2017年 spenly.jia. All rights reserved.
//

#import <Foundation/Foundation.h>

#define START @"start"
#define SUCCESS @"success"
#define FAILED @"failed"
#define REDIRECT @"redirect"
#define ERROR @"error"


@interface HTTPSession : NSObject


@property (nonatomic, copy) void (^httpGetCallBack)(NSString* responseData);
// @property (nonatomic)NSURLSession *httpSession;
- (void) httpGet:(NSString*) surl;
//- (void) httpGetUrl:(NSString*) surl;
- (void) startRequest: (NSString*) surl;

@end

