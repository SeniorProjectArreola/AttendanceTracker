//
//  TableViewCell.h
//  AttendanceTracker
//
//  Created by Daniel Lozano on 3/13/14.
//  Copyright (c) 2014 adelaarreola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
