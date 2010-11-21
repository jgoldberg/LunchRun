//
//  WPProgressHUD.m
//  WordPress
//
//  Created by Gareth Townsend on 9/07/09.
//

#import "LRProgressHUD.h"

@implementation LRProgressHUD

@synthesize backgroundImageView, activityIndicator, progressMessage;

- (id)initWithLabel:(NSString *)text {
    if (self = [super init]) {
		backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUDBackground.png"]];
		backgroundImageView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
		[self addSubview:backgroundImageView];

        progressMessage = [[UILabel alloc] initWithFrame:CGRectZero];
        progressMessage.textColor = [UIColor whiteColor];
        progressMessage.backgroundColor = [UIColor clearColor];
		progressMessage.font = [UIFont fontWithName:@"Helvetica" size:(14.0)];
        progressMessage.text = text;
        [self addSubview:progressMessage];

        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator startAnimating];
        [self addSubview:activityIndicator];
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
}

- (void)layoutSubviews {
    [progressMessage sizeToFit];
	
	progressMessage.center = backgroundImageView.center;
	activityIndicator.center = backgroundImageView.center;

    CGRect textRect = progressMessage.frame;
    textRect.origin.y += 30.0;
    progressMessage.frame = textRect;

    CGRect activityRect = activityIndicator.frame;
    activityRect.origin.y -= 10.0;
    activityIndicator.frame = activityRect;
	
    [self bringSubviewToFront:activityIndicator];
    [self bringSubviewToFront:progressMessage];
}

- (void)show {
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate];
    [super show];
    CGSize backGroundImageSize = self.backgroundImageView.image.size;
    self.bounds = CGRectMake(0, 0, backGroundImageSize.width, backGroundImageSize.height);
	[self layoutSubviews];
    [delegate setAlertRunning:YES];
    [self bringSubviewToFront:activityIndicator];
    [self bringSubviewToFront:progressMessage];
}

- (void)dismiss {
    LunchRunAppDelegate *delegate = (LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate];
	[super dismissWithClickedButtonIndex:0 animated:YES];
    [delegate setAlertRunning:NO];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    LunchRunAppDelegate *delegate = (LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate];
	[super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    [delegate setAlertRunning:NO];
}

- (void)dealloc {
    [activityIndicator release];
    [progressMessage release];
    [super dealloc];
}

@end
