//
//  MainViewController.m
//  AttendanceTracker
//
//  Created by Daniel Lozano on 3/13/14.
//  Copyright (c) 2014 adelaarreola. All rights reserved.
//

#import "MainViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "TableViewCell.h"
#import "Event.h"

@interface MainViewController ()<CLLocationManagerDelegate>{
    BOOL _isInsideRegion;
}

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.events = [[NSMutableArray alloc] init];
    
    [self setUpBeacons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath:indexPath];
    
    Event *event = self.events[indexPath.row];
    
    if ([event.type isEqual: @"In"]) {
        [cell.typeImage setImage: [UIImage imageNamed: @"InCheck"]];
        
    }else{
        [cell.typeImage setImage: [UIImage imageNamed: @"OutCheck"]];
    }
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm:ss";
    
    cell.time.text = [timeFormatter stringFromDate: event.date];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier: @"HeaderCell"];
    
    return headerCell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 107.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

#pragma mark - IBeacon's

- (void)setUpBeacons
{
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

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside) {
        [self enteredRegion];
        
    }else if(state == CLRegionStateOutside){
        [self exitedRegion];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Entered Region: %@", region);
    //[self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Exited Region: %@", region);
    //[self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
	CLBeacon *beacon = [beacons firstObject];
	NSLog(@"beacon: %@", beacon);
	//self.uuidLabel.text = [beacon.proximityUUID UUIDString];
	//[self.uuidLabel sizeToFit];
	switch(beacon.proximity)
	{
		case CLProximityFar:
            self.statusBar.backgroundColor = [UIColor colorWithRed: 255.0/255.0 green: 178.0/255.0 blue: 102.0/255.0 alpha: 1];
			//self.proximityLabel.text = [NSString stringWithFormat:@"Far - Accuracy %f", beacon.accuracy];
			break;
		case CLProximityImmediate:
            self.statusBar.backgroundColor = [UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue: 102.0/255.0 alpha: 1];
			//self.proximityLabel.text = [NSString stringWithFormat:@"Immediate - Accuracy %f", beacon.accuracy];
			break;
		case CLProximityNear:
            self.statusBar.backgroundColor = [UIColor colorWithRed: 178.0/255.0 green: 255.0/255.0 blue: 102.0/255.0 alpha: 1];
			//self.proximityLabel.text = [NSString stringWithFormat:@"Near - Accuracy %f", beacon.accuracy];
			break;
		case CLProximityUnknown:
            self.statusBar.backgroundColor = [UIColor whiteColor];
			//self.proximityLabel.text = [NSString stringWithFormat:@"Unknown - Accuracy %f", beacon.accuracy];
			break;
	}
	//[self.view setNeedsUpdateConstraints];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
	NSLog(@"Monitoring Failed: %@", error);
}

#pragma mark - Helper's

- (void)enteredRegion
{
    if (!_isInsideRegion) {
        
        [self sendInNotification];
        [self addInEntry];
        
    }
    
    _isInsideRegion = YES;
}

- (void)exitedRegion
{
    if (_isInsideRegion) {
        
        [self sendOutNotification];
        [self addOutEntry];
        
    }
    
    _isInsideRegion = NO;
}

- (void)sendInNotification
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"You have entered the region!";
    notification.alertAction = @"Open";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow: notification];
}

- (void)sendOutNotification
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"You have left the region!";
    notification.alertAction = @"Open";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow: notification];
}

- (void)addInEntry
{
    Event *newEvent = [[Event alloc] init];
    newEvent.type = @"In";
    newEvent.date = [NSDate date];
    
    [self.events addObject: newEvent];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: [self.events count] - 1 inSection: 0];
    [self.tableView insertRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationBottom];
}

- (void)addOutEntry
{
    Event *newEvent = [[Event alloc] init];
    newEvent.type = @"Out";
    newEvent.date = [NSDate date];
    
    [self.events addObject: newEvent];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: [self.events count] - 1 inSection: 0];
    [self.tableView insertRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationBottom];
}

@end
