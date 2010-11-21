//
//  WPProgressHUD.h
//  WordPress
//
//  Created by Gareth Townsend on 9/07/09.
//

#import <UIKit/UIKit.h>
#import "LunchRunAppDelegate.h"

@interface LRProgressHUD : UIAlertView {
    UIActivityIndicatorView *activityIndicator;
    UILabel *progressMessage;
	UIImageView *backgroundImageView;
}

@property (nonatomic, assign) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *progressMessage;
@property (nonatomic, assign) UIImageView *backgroundImageView;

- (id)initWithLabel:(NSString *)text;
- (void)dismiss;

@end
