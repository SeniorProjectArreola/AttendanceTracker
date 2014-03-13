//
//  ViewController.m
//  AttendanceTracker
//
//  Created by Daniel Lozano on 3/12/14.
//  Copyright (c) 2014 adelaarreola. All rights reserved.
//

#import "ViewController.h"

#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>{
    BOOL _isInsideRegion;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID: uuid identifier: @"com.adelaarreola.ibeacon_senior_project"];
    region.notifyEntryStateOnDisplay = YES;
    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    
    [self.locationManager startRangingBeaconsInRegion: region];
    [self.locationManager startMonitoringForRegion: region];
    
    [self.locationManager requestStateForRegion: region];
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
    NSLog(@"Entered Region: %@", region);
    self.infoLabel.text = @"IN";
    
    //[self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exited Region: %@", region);
    self.infoLabel.text = @"OUT";
    
    //[self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    [self updateScreenForState: state];
    
    if (state == CLRegionStateInside) {
        [self sendEnterNotification];
        
    }else if(state == CLRegionStateOutside){
        [self sendExitNotification];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
	NSLog(@"Monitoring Failed: %@", error);
}

#pragma mark - Helper's

- (void)updateScreenForState:(CLRegionState)state
{
    if (state == CLRegionStateInside){
        self.infoLabel.text = @"IN";
        
    }else if (state == CLRegionStateOutside){
        self.infoLabel.text = @"OUT";
        
    }else{
        self.infoLabel.text = @"?";
    }
}

- (void)sendEnterNotification
{
    if (!_isInsideRegion) {
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"You have entered the region!";
        notification.alertAction = @"Open";
        
        [[UIApplication sharedApplication] presentLocalNotificationNow: notification];
    }
    
    _isInsideRegion = YES;
}

- (void)sendExitNotification
{
    if (_isInsideRegion) {
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"You have left the region!";
        notification.alertAction = @"Open";
        
        [[UIApplication sharedApplication] presentLocalNotificationNow: notification];
    }
    
    _isInsideRegion = NO;
}

@end
