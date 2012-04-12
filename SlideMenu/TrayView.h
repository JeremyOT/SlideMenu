//
//  MIT License
//
//  Created by Jeremy Olmsted-Thompson on 2/8/12.
//  Copyright (c) 2012 JOT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TrayPositionLeft = 0,
    TrayPositionRight = 1
} TrayPosition;

@interface TrayView : UIView {
    UIImageView *_backgroundImageView;
    UIInterfaceOrientation _orientation;
    BOOL _supportedOrientations[7];
}

@property (nonatomic, readonly, getter = isDisplayed) BOOL displayed;
@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, assign) TrayPosition trayPosition;
@property (nonatomic) BOOL tapOffToClose;
@property (nonatomic) NSTimeInterval defaultAnimationDuration;
@property (nonatomic, copy) void (^closedBlock)();
@property (nonatomic, copy) void (^bouncedBlock)();

-(id)initWithDefaultFrame;
-(void)showInWindow:(UIWindow*)window;
-(void)showInWindow:(UIWindow*)window withDuration:(NSTimeInterval)duration;
-(void)showInWindow:(UIWindow *)window underView:(UIView*)view withDuration:(NSTimeInterval)duration;
-(void)showUnderViewController:(UIViewController*)controller;
-(void)showUnderViewController:(UIViewController*)controller withDuration:(NSTimeInterval)duration;
-(void)hide;
-(void)hideWithDuration:(NSTimeInterval)duration bounce:(BOOL)bounce;
-(void)setUIInterfaceOrientation:(UIInterfaceOrientation)orientation supported:(BOOL)supported;

@end
