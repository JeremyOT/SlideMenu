//
//  MIT License
//
//  Created by Jeremy Olmsted-Thompson on 2/8/12.
//  Copyright (c) 2012 JOT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrayView.h"
#import "SlideMenuItem.h"

@class SlideMenu;

@protocol SlideMenuDelegate <NSObject>

@optional
-(UITableViewCell*)slideMenu:(SlideMenu*)slideMenu cellForItem:(SlideMenuItem*)item tableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;

@end

@interface SlideMenu : TrayView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, assign) NSObject<SlideMenuDelegate>* delegate;

+(SlideMenu*)sharedMenu;

-(UIView*)headerForSection:(NSInteger)section;
-(SlideMenuItem*)itemAtIndexPath:(NSIndexPath*)indexPath;

-(void)addSectionWithName:(NSString*)name items:(NSArray*)items;
-(void)addSectionWithName:(NSString*)name items:(NSArray*)items headerColor:(UIColor*)color;
-(void)addSectionWithHeader:(UIView*)name items:(NSArray*)items;
-(void)addItem:(SlideMenuItem*)item inSection:(NSInteger)section;

-(void)removeSection:(NSInteger)section;
-(void)removeItemAtIndexPath:(NSIndexPath*)indexPath;
-(void)clearItems;

@end
