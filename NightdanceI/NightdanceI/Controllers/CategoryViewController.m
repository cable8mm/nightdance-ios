//
//  CategoryViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 10..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "CategoryViewController.h"
#include "../Global.h"

@interface CategoryViewController ()
@property (nonatomic, retain) NSArray *categories;
- (IBAction)close:(id)sender;
@end

@implementation CategoryViewController

@synthesize categories;

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
    
    NSString *clipUrlString   = [[NSString alloc] initWithFormat:@"%@%@%@", API_ROOT_URL, @"get_categories.php?token=", TOKEN];
    NSURL *clipUrl = [[NSURL alloc] initWithString:clipUrlString];
    NSData *clipData    = [[NSData alloc] initWithContentsOfURL:clipUrl];
    NSError *error;
    self->categories  = [NSJSONSerialization
                   JSONObjectWithData:clipData
                   options:NSJSONReadingAllowFragments
                   error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"Success Parsing %@", self->categories);
    }

}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = @"카테고리";
    return cell;
}

@end
