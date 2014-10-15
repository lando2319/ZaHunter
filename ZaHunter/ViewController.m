//
//  ViewController.m
//  ZaHunter
//
//  Created by MIKE LAND on 10/15/14.
//  Copyright (c) 2014 MIKE LAND. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController () <CLLocationManagerDelegate>
@property CLLocationManager *myLocationManager;
@property (weak, nonatomic) IBOutlet UITableView *pizzaJointsTableView;
@property NSMutableArray *pizzaJoints;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pizzaJoints = [[NSMutableArray alloc] init];
    self.myLocationManager = [[CLLocationManager alloc] init];
    [self.myLocationManager requestWhenInUseAuthorization];
    self.myLocationManager.delegate = self;
    [self.myLocationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000) {
            NSLog(@"%@", location);
            [self reverseGeocoding:location];
            [self.myLocationManager stopUpdatingLocation];
            break;
        }
    }
}

-(void)reverseGeocoding:(CLLocation *)location {
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks.firstObject;
        NSString *address = [NSString stringWithFormat:@"%@ %@ \n %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.locality];
        NSLog(@"%@", address);
        [self findPizzaJoint:placemark.location];
    }];
}

-(void)findPizzaJoint:(CLLocation *)location {
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"pizza";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1));
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.pizzaJoints = [response.mapItems mutableCopy];
//        MKMapItem *pizzaJoint = self.pizzaJoints.firstObject;
        NSLog(@"%@", self.pizzaJoints);
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //    NSDictionary *pizzaJointsDictionary = [self.pizzaJoints objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCellID"];
    cell.textLabel.text = @"toast";
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}



















@end
