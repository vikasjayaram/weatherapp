//
//  WALocationPickerController.h
//  weatherapp
//
//  Created by Vikas Jayaram on 25/04/2015.
//  Copyright (c) 2015 Vikas Jayaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol WALocationPickerControllerDelegate <NSObject>

- (void)didChangeToPlace:(CLLocation*)place;

@end

@interface WALocationPickerController : UITableViewController

@property(nonatomic, strong) NSString *currentCity;
@property(nonatomic, weak) id<WALocationPickerControllerDelegate>delegate;

@end
