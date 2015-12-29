//
//  WAWeatherDisplayCell.h
//  weatherapp
//
//  Created by Vikas Jayaram on 25/04/2015.
//  Copyright (c) 2015 Vikas Jayaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAWeatherDisplayCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel* dayOfWeek;
@property(nonatomic,strong) IBOutlet UILabel* morningTemperature;
@property(nonatomic,strong) IBOutlet UILabel* dayTemperature;
@property(nonatomic,strong) IBOutlet UILabel* eveningTemperature;
@property(nonatomic,strong) IBOutlet UILabel* nightTemperature;
@property(nonatomic,strong) IBOutlet UILabel* currentTemperature;
@property(nonatomic,strong) IBOutlet UILabel* humidity;
@property(nonatomic,strong) IBOutlet UILabel* pressure;
@property(nonatomic,strong) IBOutlet UILabel* detail;
@property(nonatomic,strong) IBOutlet UIImageView* main;
@property(nonatomic,strong) IBOutlet UIImageView* icon;



@property(nonatomic,strong) IBOutlet UILabel* minimumTemperature;
@property(nonatomic,strong) IBOutlet UILabel* maximumTemperature;

@end
