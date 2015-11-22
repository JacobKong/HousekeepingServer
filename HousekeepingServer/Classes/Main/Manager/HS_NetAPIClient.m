//
//  HS_NetAPIClient.m
//  HousekeepingServer
//
//  Created by Jacob on 15/11/21.
//  Copyright © 2015年 com.jacob. All rights reserved.
//

#import "HS_NetAPIClient.h"
#import "NSObject+Common.h"
#import "XBConst.h"

#define kNetworkMethodName @[ @"Get", @"Post", @"Put", @"Delete" ]

@implementation HS_NetAPIClient
static HS_NetAPIClient *_shareClient = nil;
static dispatch_once_t onceToken;
+ (HS_NetAPIClient *)sharedJsonClient {
  dispatch_once(&onceToken, ^{
    _shareClient = [[HS_NetAPIClient alloc]
        initWithBaseURL:[NSURL URLWithString:[NSObject baseURLStr]]];
  });
  return _shareClient;
}

/**
 *  override super's initWithBaseURL method
 */
- (id)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (!self) {
    return nil;
  }
    self.requestSerializer = [AFJSONRequestSerializer serializer]; 
  self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
  self.responseSerializer.acceptableContentTypes = [NSSet
      setWithObjects:@"application/json", @"text/plain", @"text/javascript",
                     @"text/json", @"text/html", nil];

  [self.requestSerializer setValue:@"application/json"
                forHTTPHeaderField:@"Accept"];
  [self.requestSerializer setValue:url.absoluteString
                forHTTPHeaderField:@"Referer"];

  self.securityPolicy.allowInvalidCertificates = YES;
    
  return self;
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary *)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block {
  [self requestJsonDataWithPath:aPath
                     withParams:params
                 withMethodType:method
                  autoShowError:YES
                       andBlock:block];
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary *)params
                 withMethodType:(NetworkMethod)method
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block {
    // aPath为空
    if (!aPath || aPath.length <= 0) {
        return;
    }
    // log请求数据
    XBLog(@"\n===========request===========\n%@\n%@:\n%@",
          kNetworkMethodName[method], aPath, params);
    //    发起请求
    switch (method) {
        case Get: {
            //所有 Get 请求，增加缓存机制
            NSMutableString *localPath = [aPath mutableCopy];
            if (params) {
                [localPath appendString:params.description];
            }
            
            [self GET:aPath
           parameters:params
              success:^(AFHTTPRequestOperation *_Nonnull operation,
                        id _Nonnull responseObject) {
                  XBLog(@"\n===========response===========\n%@:\n%@", aPath,
                        responseObject);
                  block(responseObject, nil);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  XBLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                  !autoShowError || [NSObject showError:error];
                  block(nil, error);
              }];
            break;
        }
        case Post: {
            [self POST:aPath parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                XBLog(@"\n===========response===========\n%@:\n%@", aPath,
                      responseObject);
                block(responseObject, nil);
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                XBLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                !autoShowError || [NSObject showError:error];
                block(nil, error);
            }];
            break;
        }
        default:
            break;
    }
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                           file:(NSDictionary *)file
                     withParams:(NSDictionary *)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block {
    // log请求数据
    XBLog(@"\n===========request===========\n%@\n%@:\n%@",
          kNetworkMethodName[method], aPath, params);
//    aPath = [aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    // Data
    NSData *data;
    NSString *name, *fileName;
    
    if (file) {
        UIImage *image = file[@"image"];
        
        // 缩小到最大 800x800
        //        image = [image scaledToMaxSize:CGSizeMake(500, 500)];
        
        // 压缩
        data = UIImageJPEGRepresentation(image, 1.0);
        if ((float)data.length/1024 > 1000) {
            data = UIImageJPEGRepresentation(image, 1024*1000.0/(float)data.length);
        }
        
        name = file[@"name"];
        fileName = file[@"fileName"];
    }

//    NSURL *fileURL = [NSURL URLWithString:file[@"fileURL"]];
//    NSString *fileName = file[@"fileName"];
//    NSLog(@"fileURL----%@,fileName-----%@",fileURL,fileName);
    switch (method) {
        case Post:{
            
          [self POST:aPath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
              if (file) {
                  [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
              }

//                if (file) {
//                    [formData appendPartWithFileURL:fileURL
//                                               name:fileName
//                                              error:nil];
//                NSLog(@"asdjfhakjdjladj---------");
//                }
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                XBLog(@"\n===========response===========\n%@:\n%@", aPath,
                      responseObject);
                block(responseObject, nil);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                XBLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                [NSObject showError:error];
                block(nil, error);
            }];

            break;
        }
        default:
            break;
    }

}

@end
