//
//  WALocationManager.h
//  weatherapp
//
//  Created by Vikas Jayaram on 25/04/2015.
//  Copyright (c) 2015 Vikas Jayaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol WALocationManagerDelegate <NSObject>
- (void)didUpdateToLocation:(CLLocation*)location;
@end
@interface WALocationManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;

@property(nonatomic,strong) id<WALocationManagerDelegate> delegate;
+ (WALocationManager*)shareInstance;

- (void)getCurrentLocation;
- (void)getAddressFromLocation:(CLLocation*)location withCompleteBlock:(void (^)(CLPlacemark* placemark))callbackBlock;

@end
