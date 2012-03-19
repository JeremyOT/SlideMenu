//
//  MIT License
//
//  Created by Jeremy Olmsted-Thompson on 2/10/12.
//  Copyright (c) 2012 JOT. All rights reserved.
//

#import "SlideMenuItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation SlideMenuItem

@synthesize title = _title;
@synthesize icon = _icon;
@synthesize accessoryView = _accessoryView;
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

-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action accessoryView:(UIView*)accessoryView {
    if ((self = [self initWithTitle:title block:action accessoryType:UITableViewCellAccessoryNone icon:nil textColor:[UIColor whiteColor] backgroundColor:[UIColor clearColor]])) {
        self.accessoryView = accessoryView;
    }
    return self;
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
    [_accessoryView release];
    [_block release];
    [super dealloc];
}

#pragma mark - Run

-(BOOL)runBlock {
    return _block(self);
}

#pragma mark - Cell Population

-(NSString*)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

-(UITableViewCell*)generatedCell {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellReuseIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor colorWithRed:1 green:1 blue:1 alpha:0.05] CGColor],
                            (id)[[UIColor colorWithRed:1 green:1 blue:1 alpha:0.05] CGColor],
                            (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor],
                            (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor],
                            (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] CGColor],
                            (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] CGColor],
                            nil];
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0],
                               [NSNumber numberWithFloat:0.023],
                               [NSNumber numberWithFloat:0.023],
                               [NSNumber numberWithFloat:0.977],
                               [NSNumber numberWithFloat:0.977],
                               [NSNumber numberWithFloat:1.0],
                               nil];
    gradientLayer.frame = cell.bounds;
    [cell.layer insertSublayer:gradientLayer atIndex:0];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:19.0];
    return cell;
}

-(void)configureTableViewCell:(UITableViewCell*)cell {
    cell.textLabel.text = self.title;
    cell.textLabel.textColor = self.textColor;
    cell.imageView.image = self.icon;
    cell.contentView.backgroundColor = self.backgroundColor;
    cell.accessoryType = self.accessoryType;
    cell.accessoryView = self.accessoryView;
}

@end
