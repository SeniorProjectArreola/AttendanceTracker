//
//  ViewController.h
//  AttendanceTracker
//
//  Created by Daniel Lozano on 3/12/14.
//  Copyright (c) 2014 adelaarreola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) NSString *username;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;

@end
