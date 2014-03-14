//
//  LoginViewController.m
//  AttendanceTracker
//
//  Created by Daniel Lozano on 3/12/14.
//  Copyright (c) 2014 adelaarreola. All rights reserved.
//

#import "LoginViewController.h"

#import "MainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedLogin:(id)sender
{
//    if ([self.userNameField.text isEqualToString: @"hunter@stedwards.edu"]) {
//        
//        ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier: @"viewController"];
//        viewController.username = @"hunter";
//        
//        [self presentViewController: viewController animated: YES completion: nil];
//        
//    }else if([self.userNameField.text isEqualToString: @"adela@stedwards.edu"]){
//        
    UINavigationController *navViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"loggedInNavigationController"];
    MainViewController *viewController = [[navViewController childViewControllers] objectAtIndex: 0];
    viewController.userName = @"Adela";
    viewController.email = @"adelaarreola@gmail.com";
    
    [self presentViewController: navViewController animated: YES completion: nil];
        
//    }else{
//        NSLog(@"Erorr");
//        
//    }
}

@end
