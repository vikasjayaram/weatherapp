//
//  WALocationManager.m
//  weatherapp
//
//  Created by Vikas Jayaram on 25/04/2015.
//  Copyright (c) 2015 Vikas Jayaram. All rights reserved.
//

#import "WALocationManager.h"
@implementation WALocationManager
+ (WALocationManager*)shareInstance
{
    static dispatch_once_t once;
    static WALocationManager* instance;
    dispatch_once(&once, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (void)getAddressFromLocation:(CLLocation*)location withCompleteBlock:(void (^)(CLPlacemark*))callbackBlock
{
    CLGeocoder* coder = [[CLGeocoder alloc] init];
    [coder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error) {
        CLPlacemark *placemark = [placemarks firstObject];
        callbackBlock(placemark);
    }];
}

- (void)getCurrentLocation
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    [self.locationManager stopUpdatingLocation];
    
    CLLocation* location = [locations firstObject];
    [self.delegate didUpdateToLocation:location];
}

@end
