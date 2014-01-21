//
//  ClipPlayerViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 8..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "ClipPlayerViewController.h"

@interface ClipPlayerViewController ()

@end

@implementation ClipPlayerViewController

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
    self.moviePlayer.controlStyle = MPMovieControlStyleFullscreen; // MPMovieControlStyleDefault
    self.moviePlayer.shouldAutoplay = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
@end
