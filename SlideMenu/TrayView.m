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
@synthesize trayPosition = _trayPosition;
@synthesize bouncesOnClose = _bouncesOnClose;
@synthesize defaultAnimationDuration = _defaultAnimationDuration;
@synthesize closedBlock = _closedBlock;
@synthesize bouncedBlock = _bouncedBlock;

#pragma mark - Lifecycle

-(id)initWithDefaultFrame { 
    return [self initWithFrame:CGRectMake(0, 0, 280, 480)];
}

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
        _defaultAnimationDuration = 0.25;
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [_slideView release];
    [_backgroundImageView release];
    [_closedBlock release];
    [_bouncedBlock release];
    [super dealloc];
}

#pragma mark - Display

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
    [self showInWindow:window withDuration:_defaultAnimationDuration];
}

-(void)showUnderViewController:(UIViewController *)controller {
    [self showUnderViewController:controller withDuration:_defaultAnimationDuration];
}

-(void)showUnderViewController:(UIViewController *)controller withDuration:(NSTimeInterval)duration {
    [self showInWindow:controller.view.window underView:controller.view withDuration:duration];
}

-(void)showInWindow:(UIWindow *)window withDuration:(NSTimeInterval)duration {
    [self showInWindow:window underView:window.rootViewController.view withDuration:duration];
}

-(void)showInWindow:(UIWindow *)window underView:(UIView*)view withDuration:(NSTimeInterval)duration {
    _displayed = YES;
    self.transform = CGAffineTransformIdentity;
    CGRect trayFrame = self.frame;
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    switch (_trayPosition) {
        case TrayPositionRight:
            switch (_orientation) {
                case UIInterfaceOrientationPortraitUpsideDown:
                    trayFrame.size.height = window.frame.size.height - statusBarFrame.size.height;
                    trayFrame.origin.y = 0;
                    trayFrame.origin.x = 0;
                    self.frame = trayFrame;
                    self.transform = CGAffineTransformMakeRotation(M_PI);
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                    trayFrame.size.height = window.frame.size.width - statusBarFrame.size.width;
                    self.frame = trayFrame;
                    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
                    trayFrame = self.frame;
                    trayFrame.origin.x = statusBarFrame.size.width;
                    trayFrame.origin.y = 0;
                    self.frame = trayFrame;
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    trayFrame.size.height = window.frame.size.width - statusBarFrame.size.width;
                    self.frame = trayFrame;
                    self.transform = CGAffineTransformMakeRotation(M_PI_2);
                    trayFrame = self.frame;
                    trayFrame.origin.x = 0;
                    trayFrame.origin.y = window.frame.size.height - self.frame.size.height;
                    self.frame = trayFrame;
                    break;
                case UIInterfaceOrientationPortrait:
                default:
                    trayFrame.size.height = window.frame.size.height - statusBarFrame.size.height;
                    trayFrame.origin.y = statusBarFrame.size.height;
                    trayFrame.origin.x = window.frame.size.width - self.frame.size.width;
                    self.frame = trayFrame;
            }
            break;
        case TrayPositionLeft:
        default:
            switch (_orientation) {
                case UIInterfaceOrientationPortraitUpsideDown:
                    trayFrame.size.height = window.frame.size.height - statusBarFrame.size.height;
                    trayFrame.origin.y = 0;
                    trayFrame.origin.x = window.frame.size.width - self.frame.size.width;
                    self.frame = trayFrame;
                    self.transform = CGAffineTransformMakeRotation(M_PI);
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                    trayFrame.size.height = window.frame.size.width - statusBarFrame.size.width;
                    self.frame = trayFrame;
                    self.transform = CGAffineTransformMakeRotation(-M_PI_2);
                    trayFrame = self.frame;
                    trayFrame.origin.x = statusBarFrame.size.width;
                    trayFrame.origin.y = window.frame.size.height - self.frame.size.height;
                    self.frame = trayFrame;
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    trayFrame.size.height = window.frame.size.width - statusBarFrame.size.width;
                    self.frame = trayFrame;
                    self.transform = CGAffineTransformMakeRotation(M_PI_2);
                    trayFrame = self.frame;
                    trayFrame.origin.x = 0;
                    trayFrame.origin.y = 0;
                    self.frame = trayFrame;
                    break;
                case UIInterfaceOrientationPortrait:
                default:
                    trayFrame.size.height = window.frame.size.height - statusBarFrame.size.height;
                    trayFrame.origin.y = statusBarFrame.size.height;
                    trayFrame.origin.x = 0;
                    self.frame = trayFrame;
            }
    }
    [window addSubview:self];
    [window sendSubviewToBack:self];
    _slideView = view;
    _slideView.layer.masksToBounds = NO;
    _slideView.layer.shadowRadius = 8;
    _slideView.layer.shadowOpacity = 0.5;
    _slideView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_slideView.bounds].CGPath;
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = _slideView.frame;
        switch (_trayPosition) {
            case TrayPositionRight:
                switch (_orientation) {
                    case UIInterfaceOrientationPortraitUpsideDown:
                        frame.origin.x = self.bounds.size.width;
                        break;
                    case UIInterfaceOrientationLandscapeLeft:
                        frame.origin.y = self.bounds.size.width;
                        break;
                    case UIInterfaceOrientationLandscapeRight:
                        frame.origin.y = -self.bounds.size.width;
                        break;
                    case UIInterfaceOrientationPortrait:
                    default:
                        frame.origin.x = -self.bounds.size.width;
                }
                break;
            case TrayPositionLeft:
            default:
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
                }
        }
        _slideView.frame = frame;
    }];
}

-(void)hide {
    [self hideWithDuration:_defaultAnimationDuration bounce:_bouncesOnClose];
}

-(void)hideWithDuration:(NSTimeInterval)duration bounce:(BOOL)bounce{
    _displayed = NO;
    void (^closeAnimation)() = ^{
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
            if (_closedBlock) {
                _closedBlock();
            }
        }];
    };
    if (bounce) {
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = _slideView.frame;
            switch (_orientation) {
                case UIInterfaceOrientationLandscapeLeft:
                    frame.origin.y = _trayPosition == TrayPositionLeft ? -frame.size.height : frame.size.height;
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    frame.origin.y = _trayPosition == TrayPositionLeft ? frame.size.height : -frame.size.height;
                    break;
                case UIInterfaceOrientationPortraitUpsideDown:
                    frame.origin.x = _trayPosition == TrayPositionLeft ? -frame.size.width : frame.size.width;
                    break;
                case UIInterfaceOrientationPortrait:
                default:
                    frame.origin.x = _trayPosition == TrayPositionLeft ? frame.size.width : -frame.size.width;
                    break;
            }
            _slideView.frame = frame;
        } completion: ^(BOOL completed) {
            if (_bouncedBlock) {
                _bouncedBlock();
            }
            closeAnimation();
        }];
    } else {
        closeAnimation();
    }
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
        _displayed = NO;
        [UIView animateWithDuration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration] animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.alpha = 1;
        }];
    }
    _orientation = orientation;
}

@end
