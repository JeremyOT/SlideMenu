//
//  MIT License
//
//  Created by Jeremy Olmsted-Thompson on 2/8/12.
//  Copyright (c) 2012 JOT. All rights reserved.
//

#import "TrayView.h"
#import <QuartzCore/QuartzCore.h>

@interface TrayView ()

@property (nonatomic, assign) UIView *slideView;

@end

@implementation TrayView

@synthesize slideView = _slideView;
@synthesize displayed = _displayed;

- (id)initWithFrame:(CGRect)frame {
    if (([super initWithFrame:frame])) {
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
        self.autoresizingMask = 0;
        _supportedOrientations[UIDeviceOrientationUnknown] = NO;
        _supportedOrientations[UIInterfaceOrientationPortrait] = YES;
        _supportedOrientations[UIInterfaceOrientationPortraitUpsideDown] = YES;
        _supportedOrientations[UIInterfaceOrientationLandscapeLeft] = YES;
        _supportedOrientations[UIInterfaceOrientationLandscapeRight] = YES;
        _supportedOrientations[UIDeviceOrientationFaceUp] = NO;
        _supportedOrientations[UIDeviceOrientationFaceDown] = NO;
        _orientation = [[UIApplication sharedApplication] statusBarOrientation];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

-(UIImage *)backgroundImage {
    return _backgroundImageView.image;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage {
    [_backgroundImageView removeFromSuperview];
    [_backgroundImageView release];
    if (!backgroundImage) {
        _backgroundImageView = nil;
        return;
    }
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundImageView.image = backgroundImage;
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_backgroundImageView];
    [self sendSubviewToBack:_backgroundImageView];
}

-(void)showInWindow:(UIWindow *)window {
    [self showInWindow:window withDuration:0.5];
}

-(void)showInWindow:(UIWindow *)window withDuration:(NSTimeInterval)duration {
    _displayed = YES;
    self.transform = CGAffineTransformIdentity;
    CGRect trayFrame = self.frame;
    switch (_orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            trayFrame.size.height = window.rootViewController.view.bounds.size.height;
            trayFrame.origin.y = 0;
            trayFrame.origin.x = window.frame.size.width - self.frame.size.width;
            self.frame = trayFrame;
            self.transform = CGAffineTransformMakeRotation(M_PI);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            trayFrame.size.height = window.rootViewController.view.frame.size.width;
            self.frame = trayFrame;
            self.transform = CGAffineTransformMakeRotation(-M_PI_2);
            trayFrame = self.frame;
            trayFrame.origin.x = window.frame.size.width - window.rootViewController.view.frame.size.width;
            trayFrame.origin.y = window.frame.size.height - self.frame.size.height;
            self.frame = trayFrame;
            break;
        case UIInterfaceOrientationLandscapeRight:
            trayFrame.size.height = window.rootViewController.view.frame.size.width;
            self.frame = trayFrame;
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            trayFrame = self.frame;
            trayFrame.origin.x = 0;
            trayFrame.origin.y = 0;
            self.frame = trayFrame;
            break;
        case UIInterfaceOrientationPortrait:
        default:
            trayFrame.size.height = window.rootViewController.view.bounds.size.height;
            trayFrame.origin.y = window.frame.size.height - window.rootViewController.view.frame.size.height;
            trayFrame.origin.x = 0;
            self.frame = trayFrame;
            break;
    }
    [window addSubview:self];
    [window sendSubviewToBack:self];
    _slideView = window.rootViewController.view;
    _slideView.layer.masksToBounds = NO;
    _slideView.layer.shadowRadius = 8;
    _slideView.layer.shadowOpacity = 0.5;
    _slideView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_slideView.bounds].CGPath;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = _slideView.frame;
        switch (_orientation) {
            case UIInterfaceOrientationPortraitUpsideDown:
                frame.origin.x = -self.bounds.size.width;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                frame.origin.y = -self.bounds.size.width;
                break;
            case UIInterfaceOrientationLandscapeRight:
                frame.origin.y = self.bounds.size.width;
                break;
            case UIInterfaceOrientationPortrait:
            default:
                frame.origin.x = self.bounds.size.width;
                break;
        }
        _slideView.frame = frame;
    }];
}

-(void)hide {
    [self hideWithDuration:0.5];
}

-(void)hideWithDuration:(NSTimeInterval)duration {
    _displayed = NO;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = _slideView.frame;
        switch (_orientation) {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                frame.origin.y = 0;
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
            case UIInterfaceOrientationPortrait:
            default:
                frame.origin.x = 0;
                break;
        }
        _slideView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _slideView.clipsToBounds = YES;
        _slideView = nil;
    }];
}

-(void)setUIInterfaceOrientation:(UIInterfaceOrientation)orientation supported:(BOOL)supported {
    _supportedOrientations[orientation] = supported;
}

-(void)orientationDidChange:(NSNotification*)note {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == _orientation || !_supportedOrientations[orientation]) {
        return;
    }
    if (_displayed) {
        [UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration] animations:^{
            CGRect frame = self.frame;
            switch (_orientation) {
                case UIInterfaceOrientationPortraitUpsideDown:
                    frame.origin.x = self.window.frame.size.width;
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                    frame.origin.y = self.window.frame.size.height;
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    frame.origin.y = -frame.size.height;
                    break;
                case UIInterfaceOrientationPortrait:
                default:
                    frame.origin.x = 0;
                    break;
            }
            self.frame = frame;
        } completion:^(BOOL finished) {
            [self showInWindow:self.window];
        }];
    }
    _orientation = orientation;
}

@end
