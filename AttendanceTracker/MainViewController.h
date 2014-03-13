//
//  MainViewController.h
//  AttendanceTracker
//
//  Created by Daniel Lozano on 3/13/14.
//  Copyright (c) 2014 adelaarreola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UITableViewController

@property (strong, nonatomic) NSString *userName;

@property (strong, nonatomic) NSMutableArray *events;

@property (weak, nonatomic) IBOutlet UIView *statusBar;

@end
