//
//  WebViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 14..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property(nonatomic, retain) IBOutlet UIWebView *webView;
@end

@implementation WebViewController

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
    // Do any additional setup after loading the view from its nib.
    NSURL *url  = [NSURL URLWithString:@"http://google.com"];
    NSURLRequest *request   = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
