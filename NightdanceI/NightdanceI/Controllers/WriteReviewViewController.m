//
//  WriteReviewViewController.m
//  NightdanceI
//
//  Created by cable8mm on 2014. 2. 17..
//  Copyright (c) 2014년 Lee Samgu. All rights reserved.
//

#import "WriteReviewViewController.h"
#import "../Libraries/NSString+StringEmpty.h"
#import "../Libraries/SCManager.h"

@interface WriteReviewViewController ()
@property(nonatomic, retain) IBOutlet UITextView *writeTextView;
-(IBAction)save:(id)sender;
@end

@implementation WriteReviewViewController

-(IBAction)save:(id)sender {
    NSLog(@"save action");
    if ([self.writeTextView.text isStringEmpty]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"내용을 넣어주세요."
                                                      delegate:nil
                                             cancelButtonTitle:@"확인"
                                             otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *params    = [NSString stringWithFormat:@"device_type=1&clip_id=%@", self.clipId];
    NSString *urlString = [SCManager getAuthUrl:@"submit_review.php" param:params];
    NSDictionary *postObject    = [NSDictionary dictionaryWithObject:self.writeTextView.text forKey:@"review"];

    NSDictionary *jsonData  = [SCManager getJsonPostData:urlString post:postObject];
    
    if ([jsonData[@"isSubmit"] boolValue]) {
        [self.delegate addComment:self.writeTextView.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    CGFloat keyboardHeight;
    CGRect viewFrame = _writeTextView.frame;
    CGFloat textMaxY = CGRectGetMaxY(_writeTextView.frame);
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        keyboardHeight = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.width;
    } else {
        keyboardHeight = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    }
    CGFloat maxVisibleY = self.view.bounds.size.height - keyboardHeight;
    viewFrame.size.height = viewFrame.size.height - (textMaxY - maxVisibleY);
    _writeTextView.frame = viewFrame;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
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
    // Do any additional setup after loading the view from its nib.
    //Here I add a UITextView in code, it will work if it's added in IB too
    //To make the border look very close to a UITextField
    _writeTextView.text = @"";
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_writeTextView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
