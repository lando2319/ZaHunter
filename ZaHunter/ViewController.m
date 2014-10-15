//
//  ViewController.m
//  ZaHunter
//
//  Created by MIKE LAND on 10/15/14.
//  Copyright (c) 2014 MIKE LAND. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>
@property CLLocationManager *myLocationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myLocationManager = [[CLLocationManager alloc] init];
    [self.myLocationManager requestWhenInUseAuthorization];
    self.myLocationManager.delegate = self;
    [self.myLocationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000) {
            NSLog(@"%@", location);
            [self.myLocationManager stopUpdatingLocation];
            break;
        }
    }
}


@end
