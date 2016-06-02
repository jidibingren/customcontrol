//
//  SCDGHttpTool.m
//  deigo
//
//  Created by SC on 16/5/11.
//  Copyright © 2016年 SC. All rights reserved.
//

#import "SCDGHttpTool.h"

@implementation SCDGHttpTool

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary* json))success failure:(void (^)(NSError *error))failure{
    [self requestWithURL:url method:@"GET" params:params constructingBodyWithBlock:nil success:success failure:failure];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(NSDictionary* json))success failure:(void (^)(NSError *error))failure{
    [self requestWithURL:url method:@"GET" params:params constructingBodyWithBlock:nil success:success failure:failure];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary* json))success failure:(void (^)(NSError *error))failure{
    [self requestWithURL:url method:@"POST" params:params constructingBodyWithBlock:nil success:success failure:failure];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void (^)(NSDictionary* json))success failure:(void (^)(NSError *error))failure{
    [self requestWithURL:url method:@"POST" params:params constructingBodyWithBlock:nil success:success failure:failure];
}


+ (void)requestWithURL:(NSString *)url
                method:(NSString*)method
                params:(NSDictionary *)params
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
               success:(void (^)(NSDictionary*))success
               failure:(void (^)(NSError *))failure
{
    if (!params) {
        params = @{};
    }
    params = [params mutableCopy];
    
    [params setValue:[SCDGUtils getUUID] forKey:@"device"];
    [params setValue:@"2" forKey:@"platform"];
    [params setValue:[SCDGUtils getCurrentVersionFull] forKey:@"version"];
    
    
    [self signAndEncryption:(NSMutableDictionary*)params];
    
    void (^onFailure)(NSURLSessionTask *operation, NSError *error) = ^(NSURLSessionTask *operation, NSError *error) {

        if (failure) {
            failure(error);
        } else {
            NSString* errorStr = [error localizedDescription];
            //避免显示空的字符串
            if ([errorStr stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
                errorStr = NSLocalizedString(@"网络错误", nil);
            }
//            [SCDGUtils makeShortToastAtCenter:errorStr];
        }
        
    };
    
    void (^onNetworkFailure)(NSURLSessionTask *operation, NSError *error) = ^(NSURLSessionTask *operation, NSError *error) {
        BOOL networkNotConnected = error && error.code == NSURLErrorNotConnectedToInternet;
        NSString* errorStr = networkNotConnected ? NSLocalizedString(@"暂无网络连接，请检查网络", nil) : NSLocalizedString(@"网络连接异常，请检查网络", nil);
        onFailure(operation, [SCDGUtils makeError:errorStr]);
    };
    
    void (^onSuccess)(NSURLSessionTask *operation, id responseObject) = ^(NSURLSessionTask *operation, id responseObject) {
//        if (![responseObject isKindOfClass: [NSDictionary class]]) {
//            NSString* error = [NSString stringWithFormat:NSLocalizedString(@"服务器错误：返回的不是json: %@", nil), responseObject];
//            onFailure(operation, [SCDGUtils makeError: error]);
//            return;
//        }
        
        if (success) {
            success(responseObject);
        }
    };
    [self doRequest:url method:method parameters:params constructingBodyWithBlock:block success:onSuccess failure:onNetworkFailure];
}

+ (NSURLSessionTask *)doRequest:(NSString *)URLString
                         method: (NSString*)method
                     parameters:(id)parameters
      constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                        success:(void (^)(NSURLSessionTask *operation, id responseObject))success
                        failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//    mgr.responseSerializer.acceptableStatusCodes = nil;
    
//    if ([method isEqualToString:@"GET"]) {
//        [mgr GET:URLString parameters:parameters progress:nil success:success failure:failure];
//    }else if ([method isEqualToString:@"POST"]){
//        [mgr POST:URLString parameters:parameters progress:nil success:success failure:failure];
//    }
    
//    if ([method isEqualToString:@"GET"]) {
//        [mgr GET:URLString parameters:parameters progress:nil success:success failure:failure];
//    }else if ([method isEqualToString:@"POST"]){
//        [mgr POST:URLString parameters:parameters constructingBodyWithBlock:block progress:nil success:success failure:failure];
//    }
    NSMutableURLRequest *request = nil;
    NSError *error;
    
    if (block) {
        request = [mgr.requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:&error];
    }else{
        request = [mgr.requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:&error];
    }
    
    if (error) {
        if (failure) {
            dispatch_async(mgr.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, error);
            });
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    if (block) {
        dataTask = [mgr uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                if (failure) {
                    failure(dataTask, error);
                }
            } else {
                if (success) {
                    success(dataTask, responseObject);
                }
            }
        }];
    }else{
        dataTask = [mgr dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            if (error) {
                if (failure) {
                    failure(dataTask, error);
                }
            } else {
                if (success) {
                    success(dataTask, responseObject);
                }
            }
        }];
    }
    
    [dataTask resume];
    
    return dataTask;
}

+ (void) signAndEncryption:(NSMutableDictionary *)dict{
    
    __block NSString *tempStr = [NSMutableString new];
    
    NSArray *keys = [dict allKeys];
    
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
        
        return [obj1 compare:obj2];
        
    }];

    
    for (NSString * key in keys) {
        
        id value = [dict objectForKey:key];
        
        tempStr = [tempStr stringByAppendingString:key];
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSConstantString class]]) {
            
            tempStr = [tempStr stringByAppendingString:value];
            
        }else if ([value isKindOfClass:[NSNumber class]]){
            
            tempStr = [tempStr stringByAppendingString:[value stringValue]];
            
        }
        
    }
    
    
    NSString *nonceStr = [SCDGUtils getNonce];
    
    tempStr = [tempStr stringByAppendingString:nonceStr];
    
    dict[@"_sign"] = [[SCDGSign sharedInstance] md5LowercaseStr:tempStr];

    dict[@"_noice"] = [[SCDGEncryption sharedInstance] encryptWithString:nonceStr];
    
}

@end
