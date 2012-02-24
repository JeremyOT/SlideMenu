//
//  MIT License
//
//  Created by Jeremy Olmsted-Thompson on 2/10/12.
//  Copyright (c) 2012 JOT. All rights reserved.
//

#import "SlideMenuItem.h"

@implementation SlideMenuItem

@synthesize title = _title;
@synthesize icon = _icon;
@synthesize accessoryType = _accessoryType;
@synthesize textColor = _textColor;
@synthesize backgroundColor = _backgroundColor;
@synthesize block = _block;

#pragma mark - Lifecycle

-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action {
    return [self initWithTitle:title block:action accessoryType:UITableViewCellAccessoryNone icon:nil];
}

-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action accessoryType:(UITableViewCellAccessoryType)accessoryType {
    return [self initWithTitle:title block:action accessoryType:accessoryType icon:nil textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
}

-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action accessoryType:(UITableViewCellAccessoryType)accessoryType icon:(UIImage *)icon {
    return [self initWithTitle:title block:action accessoryType:accessoryType icon:icon textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]];
}

-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action accessoryType:(UITableViewCellAccessoryType)accessoryType icon:(UIImage*)icon textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor {
    if ((self = [super init])) {
        self.title = title;
        self.icon = icon;
        self.accessoryType = accessoryType;
        self.textColor = textColor ? textColor : [UIColor whiteColor];
        self.backgroundColor = backgroundColor ? backgroundColor : [UIColor clearColor];
        self.block = action;
    }
    return self;
}

-(void)dealloc {
    [_title release];
    [_icon release];
    [_textColor release];
    [_backgroundColor release];
    [_block release];
    [super dealloc];
}

#pragma mark - Run

-(BOOL)runBlock {
    return _block(self);
}

@end
