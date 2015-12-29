//
//  WAWeatherData.m
//  weatherapp
//
//  Created by Vikas Jayaram on 25/04/2015.
//  Copyright (c) 2015 Vikas Jayaram. All rights reserved.
//

#import "WAWeatherData.h"

@implementation WAWeatherData
@synthesize dayOfWeek;
@synthesize description;
@synthesize morningTemperature;
@synthesize dayTemperature;
@synthesize eveningTemperature;
@synthesize nightTemperature;
@synthesize minimumTemperature;
@synthesize maximumTemperature;
@synthesize pressure;
@synthesize humidity;
@synthesize main;
@synthesize code;
@synthesize icon;

+ (NSDictionary *)imageMap {
    static NSDictionary *_imageMap = nil;
    if (! _imageMap) {
        _imageMap = @{
                      @"01d" : @"weather-clear",
                      @"02d" : @"weather-few",
                      @"03d" : @"weather-few",
                      @"04d" : @"weather-broken",
                      @"09d" : @"weather-shower",
                      @"10d" : @"weather-rain",
                      @"11d" : @"weather-tstorm",
                      @"13d" : @"weather-snow",
                      @"50d" : @"weather-mist",
                      @"01n" : @"weather-moon",
                      @"02n" : @"weather-few-night",
                      @"03n" : @"weather-few-night",
                      @"04n" : @"weather-broken",
                      @"09n" : @"weather-shower",
                      @"10n" : @"weather-rain-night",
                      @"11n" : @"weather-tstorm",
                      @"13n" : @"weather-snow",
                      @"50n" : @"weather-mist",
                      };
    }
    return _imageMap;
}
- (NSString *)imageName {
    return [WAWeatherData imageMap][self.icon];
}
@end
