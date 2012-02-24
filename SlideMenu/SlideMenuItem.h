//
//  MIT License
//
//  Created by Jeremy Olmsted-Thompson on 2/10/12.
//  Copyright (c) 2012 JOT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuItem : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, copy) BOOL (^block)(SlideMenuItem *item);

-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action;
-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action accessoryType:(UITableViewCellAccessoryType)accessoryType;
-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action accessoryType:(UITableViewCellAccessoryType)accessoryType icon:(UIImage*)icon;
-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action accessoryType:(UITableViewCellAccessoryType)accessoryType icon:(UIImage*)icon textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor;

-(BOOL)runBlock;

@end
