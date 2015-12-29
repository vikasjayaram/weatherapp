//
//  WAAPIClient.h
//  weatherapp
//
//  Created by Vikas Jayaram on 25/04/2015.
//  Copyright (c) 2015 Vikas Jayaram. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

extern NSString * const kWeatherAPIKey;
extern NSString * const kWeatherBaseURLString;

@interface WAAPIClient : AFHTTPSessionManager
+ (WAAPIClient *)sharedClient;
- (void)getWeatherDataForAddress:(double)latitude
               longitude:(double)longitude
           numberOfDays:(int)numberOfDays
                success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
