//
//  DownloadsViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 1. 27..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "DownloadsViewController.h"
#import "DownloadCell.h"
#import "DownloadManager.h"
#import "DownloadClip.h"
#import "NDCache.h"
#import "ClipPlayerViewController.h"
#import "UserManager.h"

@interface DownloadsViewController ()
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSMutableArray *clips;
- (void) accessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event;
@end

@implementation DownloadsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {   // this is it!
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) progressStart:(NSNotification *) notification {
    if ([[DownloadManager sharedObject].downloadClips count] == 0) {
        self.editButtonItem.enabled = NO;
    } else {
        self.editButtonItem.enabled = YES;
    }
    
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.clips  = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressStart:) name:@"NOTI_DOWNLOAD_CLIPS_END" object:nil];
    if ([[DownloadManager sharedObject].downloadClips count] == 0) {
        self.editButtonItem.enabled = NO;
    } else {
        self.editButtonItem.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressStart:) name:@"NOTI_DOWNLOAD_CLIPS_START" object:nil];

    UITabBarItem *tabBarItem3   = [self.tabBarController.tabBar.items objectAtIndex:2];
    [tabBarItem3 setBadgeValue:nil];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NOTI_DOWNLOAD_CLIPS_START" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[DownloadManager sharedObject].downloadClips count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DownloadCell";
    DownloadCell *cell = (DownloadCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib    = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (DownloadCell*)[nib objectAtIndex:0];
    }

    DownloadClip *downloadClip  = [[DownloadManager sharedObject].downloadClips objectAtIndex:indexPath.row];
    cell.indexpathRow   = (int)indexPath.row;
    cell.titleLabel.text    = downloadClip.clipTitle;
    cell.progressView.progress  = [downloadClip.progress floatValue];
    [cell remainSeconds:[downloadClip.remainSeconds intValue]];

    if (downloadClip.status == DownloadStatusComplete) {
        [cell isDownload:YES];
    }

    if ([UserManager canPlayClip] == NO && downloadClip.isFree == NO) {
        [cell.downloadButton timeout];
    } else {
        [cell.downloadButton addTarget: self
                                action: @selector(accessoryButtonTapped:withEvent:)
                      forControlEvents: UIControlEventTouchUpInside];
    }
    
    [[NDCache sharedObject] assignCachedImage:downloadClip.thumbnailString
                              completionBlock:^(UIImage *image) {
                                  if (image != nil) {
                                      cell.thumbnail.image  = image;
                                  }
                              }];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        DownloadClip *downloadClip  = [[DownloadManager sharedObject].downloadClips objectAtIndex:indexPath.row];
        [[DownloadManager sharedObject] removeDownloadClip:[downloadClip.clipId intValue]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([[DownloadManager sharedObject].downloadClips count] == 0) {
            self.editButtonItem.enabled = NO;
            [self setEditing:NO animated:YES];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


- (void) accessoryButtonTapped: (UIControl *) button withEvent: (UIEvent *) event
{
    button.selected = YES;
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.tableView]];
    if ( indexPath == nil )
        return;
    
    [self.tableView.delegate tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    DownloadClip *downloadClip  = [[DownloadManager sharedObject].downloadClips objectAtIndex:indexPath.row];
    
    NSURL *fileURL  = [[DownloadManager sharedObject] getFileURLFromFile:downloadClip.filename];
    
    if (fileURL == nil) {
        return;
    }
    
    NSURL *localURL = [NSURL fileURLWithPath:[fileURL path] isDirectory:NO]; //THIS IS THE KEY TO GET THIS RUN :)
    ClipPlayerViewController *_moviePlayer =  [[ClipPlayerViewController alloc] initWithContentURL:localURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer.moviePlayer];
    
    [self presentMoviePlayerViewControllerAnimated:_moviePlayer];
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadCell *cell  = (DownloadCell*)[tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showDetail" sender:cell];
}

- (void) myMovieFinishedCallback: (NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    
    [player stop];
	
	[self dismissMoviePlayerViewControllerAnimated];
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([[segue identifier] isEqualToString:@"showDetail"]) {
         DownloadCell *downloadCell = (DownloadCell*)sender;
//         NSIndexPath *indexPath = downloadCell.indexpathRow;
         DownloadClip *downloadClip  = [[DownloadManager sharedObject].downloadClips objectAtIndex:downloadCell.indexpathRow];
         [[segue destinationViewController] setClipId:downloadClip.clipId];
     }
}
@end
