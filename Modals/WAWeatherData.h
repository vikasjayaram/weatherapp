//
//  WAWeatherData.h
//  weatherapp
//
//  Created by Vikas Jayaram on 25/04/2015.
//  Copyright (c) 2015 Vikas Jayaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WAWeatherData : NSObject
@property(nonatomic, strong) NSString* dayOfWeek;
@property(nonatomic, strong) NSString* description;
@property(nonatomic, strong) NSString* humidity;
@property(nonatomic, strong) NSString* morningTemperature;
@property(nonatomic, strong) NSString* dayTemperature;
@property(nonatomic, strong) NSString* eveningTemperature;
@property(nonatomic, strong) NSString* nightTemperature;
@property(nonatomic, strong) NSString* minimumTemperature;
@property(nonatomic, strong) NSString* maximumTemperature;
@property(nonatomic, strong) NSString* pressure;
@property(nonatomic, strong) NSString* main;
@property(nonatomic, strong) NSString* icon;

@property(assign) int code;
- (NSString *)imageName;
@end
