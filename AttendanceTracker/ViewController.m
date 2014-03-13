//
//  ViewController.m
//  AttendanceTracker
//
//  Created by Daniel Lozano on 3/12/14.
//  Copyright (c) 2014 adelaarreola. All rights reserved.
//

#import "ViewController.h"

#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID: uuid identifier: @"com.adelaarreola.ibeacon_dongle"];
    
    [self.locationManager startRangingBeaconsInRegion: region];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
	CLBeacon *beacon = [beacons firstObject];
	NSLog(@"beacon: %@", beacon);
	self.uuidLabel.text = [beacon.proximityUUID UUIDString];
	[self.uuidLabel sizeToFit];
	switch(beacon.proximity)
	{
		case CLProximityFar:
			self.proximityLabel.text = [NSString stringWithFormat:@"Far - Accuracy %f", beacon.accuracy];
			break;
		case CLProximityImmediate:
			self.proximityLabel.text = [NSString stringWithFormat:@"Immediate - Accuracy %f", beacon.accuracy];
			break;
		case CLProximityNear:
			self.proximityLabel.text = [NSString stringWithFormat:@"Near - Accuracy %f", beacon.accuracy];
			break;
		case CLProximityUnknown:
			self.proximityLabel.text = [NSString stringWithFormat:@"Unknown - Accuracy %f", beacon.accuracy];
			break;
	}
	[self.view setNeedsUpdateConstraints];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"entered region %@", region);
    
    self.infoLabel.text = @"ENTERED";
    
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"exited region %@", region);
    
    self.infoLabel.text = @"EXITED";
    
    [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
	NSLog(@"monitoring failed = %@", error);
}

@end
