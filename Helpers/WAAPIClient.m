//
//  WAAPIClient.m
//  weatherapp
//
//  Created by Vikas Jayaram on 25/04/2015.
//  Copyright (c) 2015 Vikas Jayaram. All rights reserved.
//

#import "WAAPIClient.h"
NSString * const kWeatherAPIKey = @"";
NSString * const kWeatherBaseURLString = @"http://api.openweathermap.org/data/2.5/forecast/daily";

@implementation WAAPIClient
+ (WAAPIClient *)sharedClient {
    static WAAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kWeatherBaseURLString]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

- (void)getWeatherDataForAddress:(double)latitude
                       longitude:(double)longitude
                    numberOfDays:(int)numberOfDays
                         success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString* path = [NSString stringWithFormat:@"?lat=%f&lon=%f&cnt=%d&units=metric",
                      latitude, longitude, numberOfDays];
    NSLog(@"url %@", path);
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

@end
