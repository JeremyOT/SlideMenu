//
//  MIT License
//
//  Created by Jeremy Olmsted-Thompson on 2/8/12.
//  Copyright (c) 2012 JOT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrayView : UIView {
    UIImageView *_backgroundImageView;
    UIInterfaceOrientation _orientation;
    BOOL _supportedOrientations[7];
}

@property (nonatomic, readonly, getter = isDisplayed) BOOL displayed;
@property (nonatomic, retain) UIImage *backgroundImage;

-(void)showInWindow:(UIWindow*)window;
-(void)showInWindow:(UIWindow*)window withDuration:(NSTimeInterval)duration;
-(void)hide;
-(void)hideWithDuration:(NSTimeInterval)duration;
-(void)setUIInterfaceOrientation:(UIInterfaceOrientation)orientation supported:(BOOL)supported;

@end
