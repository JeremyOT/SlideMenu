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
@property (nonatomic, retain) UIView *accessoryView;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, assign) CGFloat cellHeight;
// By default this is NSStringFromClass([self class]) and only needs to be overridden if a subclass
// represents more than one type of cell.
@property (nonatomic, readonly) NSString *cellReuseIdentifier;
@property (nonatomic, copy) BOOL (^block)(SlideMenuItem *item);

-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action;
-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action accessoryType:(UITableViewCellAccessoryType)accessoryType;
-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action accessoryView:(UIView*)accessoryView;
-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action accessoryType:(UITableViewCellAccessoryType)accessoryType icon:(UIImage*)icon;
-(id)initWithTitle:(NSString*)title block:(BOOL (^)(SlideMenuItem *item))action accessoryType:(UITableViewCellAccessoryType)accessoryType icon:(UIImage*)icon textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor;

-(BOOL)runBlock;
// Override this in a subclass to generate a different type of table view cell. The new cell must
// be instantiated with self.cellReuseIdentifier as the reuseIdentifier for UITableView caching
// to work. This method is only called if there are not enough cached cells with the matching
// reuse identifier.
-(UITableViewCell*)generatedCell;
// Override this method to populate the cell for this item.
-(void)configureTableViewCell:(UITableViewCell*)cell;

@end
