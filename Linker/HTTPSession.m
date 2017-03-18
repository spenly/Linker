//
//  HTTPSession.m
//  Linker
//
//  Created by spenly.jia on 2017/3/12.
//  Copyright © 2017年 spenly.jia. All rights reserved.
//



#import "HTTPSession.h"
#import "AFURLSessionManager.h"

@interface HTTPSession ()<NSURLSessionTaskDelegate, NSURLSessionDelegate>
@end

@implementation HTTPSession

- (instancetype)init{
    self = [super init];
    return self;
}


- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler{
    NSData * data = [[NSData alloc] initWithBase64EncodedString:@"#redirect#" options:kNilOptions];
//    NSLog(@"==reponse is :%@",response);
    NSString* result = [self handleData:data handleResponse:response withError:nil];
    if(self.httpGetCallBack!=nil) self.httpGetCallBack(result);
}


//-(void) httpGetUrl:(NSString*) surl{
//    NSURL* url = [NSURL URLWithString:surl];
//    NSURLRequest * request = [NSURLRequest requestWithURL:url];
//    AFURLSessionManager * sesm = [[AFURLSessionManager alloc] init];
//    [sesm setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request) {
//        NSData * data = [[NSData alloc] initWithBase64EncodedString:@"#redirect#"
//                                                            options:kNilOptions];
//        NSString* result = [self handleData:data handleResponse:response withError:nil];
//        if(self.httpGetCallBack!=nil) self.httpGetCallBack(result);
//        return request;
//    }];
//    NSURLSessionDataTask *task = [sesm dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSData * data = (NSData*)responseObject;
//        NSString* result = [self handleData:data handleResponse:response withError:error];
//        if(self.httpGetCallBack!=nil) self.httpGetCallBack(result);
//    }];
//    [task resume];
//}

- (void) startRequest: (NSString*) surl{
    [self httpGet:surl];
    self.httpGetCallBack([NSString stringWithFormat:@"%@\n[%@]: %@",@"start ...",START,surl]);
}


- (void) httpGet:(NSString*) surl{
    NSURL* url = [NSURL URLWithString:surl];
    //NSURLSession * httpSession = [NSURLSession sharedSession];
    NSURLSession * httpSession = [NSURLSession
                                  sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    NSURLSessionDataTask *task = [httpSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString* result = [self handleData:data handleResponse:response withError:error];
        if(self.httpGetCallBack!=nil) self.httpGetCallBack(result);
    }];
    [task resume];
    
}

- (NSString*) handleData:(NSData*)data
          handleResponse:(NSURLResponse*)response
               withError:(NSError*)error{
    NSString* result = @"";
    if(error!=nil){
        result = [NSString stringWithFormat:@"%@: %@",ERROR,error.localizedDescription];
        return result;
    }
    else{
        NSHTTPURLResponse* rep = (NSHTTPURLResponse*) response;
//        NSLog(@"%@", [NSString stringWithFormat:@"%li => %@",(long)rep.statusCode, rep.URL.absoluteString]);
        if(rep.statusCode == 200){
            result = [NSString stringWithFormat:@"[%@]: %@\n%@",SUCCESS,response.URL,@"Here landing page is"];
            return result;
        }
        else if(( rep.statusCode == 301 || rep.statusCode==302)
                && [rep.allHeaderFields.allKeys containsObject:@"Location"]){
            NSString * location = rep.allHeaderFields[@"Location"];
            NSString * server = [rep.allHeaderFields.allKeys containsObject:@"Server"] ? rep.allHeaderFields[@"Server"]:@"unknow";
            result = [NSString stringWithFormat:@"[%@][%@]: %@",REDIRECT,server, location];
            [self httpGet:location];
            return result;
        }
        else{
            // return what request responses
            result = [NSString stringWithFormat:@"[%@]: %@",FAILED,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        }
    }
    return result;
}

@end
