//
//  ViewController.m
//  weatherapp
//
//  Created by Vikas Jayaram on 25/04/2015.
//  Copyright (c) 2015 Vikas Jayaram. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "WAWeatherDisplayCell.h"
#import "WALocationDetailsCell.h"
#import "WALocationPickerController.h"
#import "WALocationManager.h"
#import "WAAPIClient.h"
#import "WAWeatherData.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, WALocationManagerDelegate, WALocationPickerControllerDelegate>

@end

@implementation ViewController {
    NSMutableArray *weatherData;
    NSString *userLocation;
    CLLocation* geoLocation;
    UIRefreshControl* refreshControl;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    weatherData = [[NSMutableArray alloc] init];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor lightGrayColor];
    [refreshControl addTarget:self
                       action:@selector(refreshControlValueChanged:)
             forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [self getCurrentLocation];
}
- (void)refreshControlValueChanged:(UIRefreshControl*)refreshControl
{
    [self getCurrentLocation];
}
- (void) getCurrentLocation {
    [WALocationManager shareInstance].delegate = self;
    [[WALocationManager shareInstance] getCurrentLocation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma WALocationManagerDelegate

- (void)didUpdateToLocation:(CLLocation*)location
{
    [self didChangeToPlace:location];
}

#pragma mark WALocationPickerControllerDelegate

- (void)didChangeToPlace:(CLLocation*)place
{
    CGFloat lat = place.coordinate.latitude;
    CGFloat lon = place.coordinate.longitude;
    
    geoLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    [[WALocationManager shareInstance] getAddressFromLocation:geoLocation withCompleteBlock:^(CLPlacemark* placemark) {
        userLocation = [NSString stringWithFormat:@"%@, %@, %@",[placemark.addressDictionary valueForKey:@"City"], [placemark.addressDictionary valueForKey:@"Country"], [placemark.addressDictionary valueForKey:@"ZIP"]];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self getWeatherData:lat lon:lon];
    }];
}
-(NSString*) getCurrentTemperature: (WAWeatherData*) weather
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH.mm"];
    NSString *strCurrentTime = [dateFormatter stringFromDate:[NSDate date]];
    NSString* currentTemperature;
    NSLog(@"Check float value: %.2f",[strCurrentTime floatValue]);
    if ([strCurrentTime floatValue] >= 20.00 || [strCurrentTime floatValue]  <= 6.00){
        NSLog(@"It's night time");
        currentTemperature = [NSString stringWithFormat:@"%@°C", [weather nightTemperature]];
    } else if ([strCurrentTime floatValue] >= 16.00 || [strCurrentTime floatValue]  <= 20.00){
        currentTemperature = [NSString stringWithFormat:@"%@°C", [weather eveningTemperature]];
        NSLog(@"It's evening time");
    } else if ([strCurrentTime floatValue] >= 12.00 || [strCurrentTime floatValue]  <= 16.00){
        currentTemperature = [NSString stringWithFormat:@"%@°C", [weather dayTemperature]];
        NSLog(@"It's day time");
    } else {
        currentTemperature = [NSString stringWithFormat:@"%@°C", [weather morningTemperature]];
        NSLog(@"It's morning");
    }
    return currentTemperature;
}
-(NSString*) getBackgounfImageName: (WAWeatherData*) weather {
    NSString *imageName = @"default";
    int code = weather.code;
    if (code >= 200 && code <= 232) {
        //Thunderstorm
        
    } else if (code >= 300 && code <= 321) {
        //drizzle
    } else if(code >= 500 && code <= 531) {
        //rain
        //imageName = @"rain.jpeg";
    } else if (code >= 600 && code <= 622) {
        //snow
        //imageName = @"snow.jpeg";
    } else if (code >= 701 && code <= 781) {
        //atmosphere
    } else if (code >= 800 && code <= 804) {
        //clouds
    } else {
        //nodemal;
    }
    return imageName;
}
-(void) getWeatherData:(double) lat lon: (double) lon {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"EEEE"];
    [[WAAPIClient sharedClient] getWeatherDataForAddress:lat longitude:lon numberOfDays:7 success:^(NSURLSessionDataTask *task, id responseObject) {
        [weatherData removeAllObjects];
        NSArray* list = [responseObject valueForKeyPath:@"list"];
        for (NSDictionary* dict in list) {
            WAWeatherData* weather = [[WAWeatherData alloc] init];
            NSDictionary* weatherDetails = [[dict valueForKey:@"weather"] objectAtIndex:0];
            NSDictionary* temperature = [dict valueForKey:@"temp"];
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[dict valueForKey:@"dt"] doubleValue]];
            weather.description = [NSString stringWithFormat:@"%@", [weatherDetails valueForKey:@"description"]];
            weather.main = [NSString stringWithFormat:@"%@", [weatherDetails valueForKey:@"main"]];
            weather.dayOfWeek = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date] ];
//            weather.morningTemperature = [NSString stringWithFormat:@"%.1f°C", [[temperature valueForKey:@"morn"] doubleValue]];
            weather.morningTemperature = [NSString stringWithFormat:@"%.1f", [[temperature valueForKey:@"morn"] doubleValue]];
            weather.dayTemperature = [NSString stringWithFormat:@"%.1f", [[temperature valueForKey:@"day"] doubleValue]];
            weather.eveningTemperature = [NSString stringWithFormat:@"%.1f", [[temperature valueForKey:@"eve"] doubleValue]];
            weather.nightTemperature = [NSString stringWithFormat:@"%.1f", [[temperature valueForKey:@"night"] doubleValue]];
            weather.minimumTemperature = [NSString stringWithFormat:@"%.1f", [[temperature valueForKey:@"min"] doubleValue]];
            weather.maximumTemperature = [NSString stringWithFormat:@"%.1f", [[temperature valueForKey:@"max"] doubleValue]];
            
            weather.humidity = [NSString stringWithFormat:@"%.1f%%", [[dict valueForKey:@"humidity"] doubleValue]];
            weather.pressure = [NSString stringWithFormat:@"%.1f bar", [[dict valueForKey:@"pressure"] doubleValue]];
            weather.code = [[weatherDetails valueForKey:@"id"] intValue];
            weather.icon = [NSString stringWithFormat:@"%@", [weatherDetails valueForKey:@"icon"]];
            [weatherData addObject:weather];
            NSLog(@"day of week %@", weather.dayOfWeek);
        }
        //weatherData = [NSArray arrayWithArray:mutableWeatherData];
        //[_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
        
        [refreshControl endRefreshing];
        NSLog(@"resp %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error %@", error);
        [refreshControl endRefreshing];

    }];
    
}
#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (weatherData.count > 0) {
        return 2;
    } else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        //messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 44;
            break;
        default:
            return 180;
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  section == 0 ? 1 : [weatherData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationCell"];
        cell.imageView.image = [UIImage imageNamed:@"location"];
        cell.textLabel.text = userLocation.length > 0 ? userLocation : @"Search Weather in location";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    } else {
        static NSString *simpleTableIdentifier = @"WAWeatherDisplayCell";
        
        WAWeatherDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[WAWeatherDisplayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        WAWeatherData* weather = (WAWeatherData *)[weatherData objectAtIndex:indexPath.row];
        NSString* currentTemp = [self getCurrentTemperature:weather];
        NSString* imageBackground = [self getBackgounfImageName:weather];
        NSLog(@"imageBackground %@ %d", imageBackground, weather.code);
        //cell.main.image = [UIImage imageNamed:imageBackground];
        cell.icon.image = [UIImage imageNamed: [weather imageName]];
        //cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:imageBackground] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        cell.dayOfWeek.text = weather.dayOfWeek;
        cell.morningTemperature.text = weather.morningTemperature ? weather.morningTemperature : @"--";
        cell.dayTemperature.text = weather.dayTemperature ? weather.dayTemperature : @"--";
        cell.eveningTemperature.text = weather.eveningTemperature ? weather.eveningTemperature : @"--";
        cell.nightTemperature.text = weather.nightTemperature ? weather.nightTemperature : @"--";
        cell.minimumTemperature.text = weather.minimumTemperature ? weather.minimumTemperature :  @"--";
        cell.maximumTemperature.text = weather.maximumTemperature ? weather.maximumTemperature : @"--";
        cell.currentTemperature.text =  currentTemp ? currentTemp : @"--";
        cell.detail.text = weather.description ? weather.description : @"--";
        cell.humidity.text = weather.humidity ? weather.humidity : @"--";
        cell.pressure.text = weather.pressure ? weather.pressure : @"--";
        return cell;
        
    }
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    if (indexPath.section == 0) {
        WALocationPickerController* picker = [[WALocationPickerController alloc] init];
        picker.delegate = self;
        picker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:picker animated:YES];
    }
}
@end
