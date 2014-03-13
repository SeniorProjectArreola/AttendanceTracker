//
//  Event.h
//  AttendanceTracker
//
//  Created by Daniel Lozano on 3/13/14.
//  Copyright (c) 2014 adelaarreola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSDate *date;

@end
