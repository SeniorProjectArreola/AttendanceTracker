//
//  LoginViewController.m
//  AttendanceTracker
//
//  Created by Daniel Lozano on 3/12/14.
//  Copyright (c) 2014 adelaarreola. All rights reserved.
//

#import "LoginViewController.h"

#import "ProgressHUD.h"

#import "MainViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

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
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismissKeyboard)];
    [self.view addGestureRecognizer: gestureRecognizer];
}

- (void)dismissKeyboard
{
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedLogin:(id)sender
{
//    if(([self.userNameField.text isEqualToString: @"adela@stedwards.edu"] || [self.userNameField.text isEqualToString: @"adela"]) && [self.passwordField.text isEqualToString: @"password"]){
//        
//        UINavigationController *navViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"loggedInNavigationController"];
//        MainViewController *viewController = [[navViewController childViewControllers] objectAtIndex: 0];
//        viewController.userName = @"Adela";
//        viewController.email = @"adelaarreola@gmail.com";
//        
//        [self presentViewController: navViewController animated: YES completion: nil];
//        
//    }else{
//        [ProgressHUD showError: @"Wrong login."];
//        
//    }
    
    UINavigationController *navViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"loggedInNavigationController"];
    MainViewController *viewController = [[navViewController childViewControllers] objectAtIndex: 0];
    viewController.user_id = @"3";
    viewController.beacon_id = @"1234";
    
    [self presentViewController: navViewController animated: YES completion: nil];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userNameField) {
        [self.passwordField becomeFirstResponder];
        
    }else if(textField == self.passwordField){
        [self.passwordField resignFirstResponder];
        [self pressedLogin: textField];
        
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.passwordField) {
        [self scrollWindowUp: YES withDistance: 150];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.passwordField) {
        [self scrollWindowUp: NO withDistance: 150];
    }
}

#pragma mark - Helper's

- (void)scrollWindowUp:(BOOL)up withDistance:(NSInteger)distance
{
    const int movementDistance = distance;
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
}

@end
