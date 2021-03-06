//
//  TransactionDetailNavigationController.m
//  Blockchain
//
//  Created by Kevin Wu on 9/2/16.
//  Copyright © 2016 Blockchain Luxembourg S.A. All rights reserved.
//

#import "TransactionDetailNavigationController.h"
#import "TransactionRecipientsViewController.h"

@implementation TransactionDetailNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, DEFAULT_HEADER_HEIGHT)];
    topBar.backgroundColor = COLOR_BLOCKCHAIN_BLUE;
    [self.view addSubview:topBar];
    
    self.headerLabel = [[UILabel alloc] initWithFrame:FRAME_HEADER_LABEL];
    self.headerLabel.font = [UIFont fontWithName:FONT_MONTSERRAT_REGULAR size:FONT_SIZE_TOP_BAR_TEXT];
    self.headerLabel.textColor = [UIColor whiteColor];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.adjustsFontSizeToFitWidth = YES;
    self.headerLabel.text = BC_STRING_TRANSACTION;
    self.headerLabel.center = CGPointMake(topBar.center.x, self.headerLabel.center.y);
    [topBar addSubview:self.headerLabel];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(self.view.frame.size.width - 80, 15, 80, 51);
    self.closeButton.imageEdgeInsets = IMAGE_EDGE_INSETS_CLOSE_BUTTON_X;
    self.closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    self.closeButton.center = CGPointMake(self.closeButton.center.x, self.headerLabel.center.y);
    [self.closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:self.closeButton];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.backButton.frame = FRAME_BACK_BUTTON;
    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.backButton setTitle:@"" forState:UIControlStateNormal];
    [topBar addSubview:self.backButton];
    
    [self setupBusyView];
}

- (void)setupBusyView
{
    BCFadeView *busyView = [[BCFadeView alloc] initWithFrame:self.view.frame];
    busyView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    UIView *textWithSpinnerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 110)];
    textWithSpinnerView.backgroundColor = [UIColor whiteColor];
    [busyView addSubview:textWithSpinnerView];
    textWithSpinnerView.center = busyView.center;
    
    UILabel *busyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BUSY_VIEW_LABEL_WIDTH, BUSY_VIEW_LABEL_HEIGHT)];
    busyLabel.adjustsFontSizeToFitWidth = YES;
    busyLabel.font = [UIFont fontWithName:FONT_MONTSERRAT_REGULAR size:BUSY_VIEW_LABEL_FONT_SYSTEM_SIZE];
    busyLabel.alpha = BUSY_VIEW_LABEL_ALPHA;
    busyLabel.textAlignment = NSTextAlignmentCenter;
    busyLabel.text = BC_STRING_LOADING_SYNCING_WALLET;
    busyLabel.center = CGPointMake(textWithSpinnerView.bounds.origin.x + textWithSpinnerView.bounds.size.width/2, textWithSpinnerView.bounds.origin.y + textWithSpinnerView.bounds.size.height/2 + 15);
    [textWithSpinnerView addSubview:busyLabel];
    self.busyLabel = busyLabel;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(textWithSpinnerView.bounds.origin.x + textWithSpinnerView.bounds.size.width/2, textWithSpinnerView.bounds.origin.y + textWithSpinnerView.bounds.size.height/2 - 15);
    [textWithSpinnerView addSubview:spinner];
    [textWithSpinnerView bringSubviewToFront:spinner];
    [spinner startAnimating];
    
    busyView.containerView = textWithSpinnerView;
    [busyView fadeOut];
    
    [self.view addSubview:busyView];
    
    [self.view bringSubviewToFront:busyView];
    
    self.busyView = busyView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.viewControllers.count > 1) {
        [self.backButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self.backButton setImage:[UIImage imageNamed:@"back_chevron_icon"] forState:UIControlStateNormal];
        self.backButton.imageEdgeInsets = IMAGE_EDGE_INSETS_BACK_BUTTON_CHEVRON;
        [self.backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        self.closeButton.hidden = YES;
    } else {
        [self.backButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self.backButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
        self.backButton.imageEdgeInsets = IMAGE_EDGE_INSETS_BACK_BUTTON_SHARE;
        [self.backButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        self.closeButton.hidden = NO;
    }
    
    if ([self.visibleViewController isMemberOfClass:[TransactionRecipientsViewController class]]) {
        self.headerLabel.text = BC_STRING_RECIPIENTS;
    } else {
        self.headerLabel.text = BC_STRING_TRANSACTION;
    }
}

- (void)popViewController
{
    if (self.viewControllers.count > 1) {
        [self popViewControllerAnimated:YES];
    } else {
        [self dismiss];
    }
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.onDismiss) self.onDismiss();
    }];
}

#pragma mark - Busy View Delegate

- (void)showBusyViewWithLoadingText:(NSString *)text
{
    [self.busyLabel setText:text];
        
    if (self.busyView.alpha < 1.0) {
        [self.busyView fadeIn];
    }
}

- (void)hideBusyView
{
    if (self.busyView.alpha == 1.0) {
        [self.busyView fadeOut];
    }
}

#pragma mark - Actions

- (void)share
{
    NSURL *url = [NSURL URLWithString:[URL_SERVER stringByAppendingFormat:@"/tx/%@", self.transactionHash]];
        
    NSArray *activityItems = @[self, url];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypePostToFacebook];
    
    [activityViewController setValue:BC_STRING_TRANSACTION_DETAILS forKey:@"subject"];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
