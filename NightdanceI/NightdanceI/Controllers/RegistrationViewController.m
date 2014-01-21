//
//  RegistrationViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 20..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()
@property (nonatomic, retain) IBOutlet UITextField *textUsername;
@property (nonatomic, retain) IBOutlet UITextField *textPassword;
-(IBAction)close:(id)sender;
@end

@implementation RegistrationViewController

-(IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)closeKeyboard:(id)sender {
    NSLog(@"키보드 닫기");
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textPassword) {
        [theTextField resignFirstResponder];
    } else if (theTextField == self.textUsername) {
        [self.textPassword becomeFirstResponder];
    }
    return YES;
}

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closeKeyboard:)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textUsername becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
