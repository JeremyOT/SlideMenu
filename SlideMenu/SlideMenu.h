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

@interface SlideMenu : TrayView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) UITableView *tableView;

+(SlideMenu*)sharedMenu;
+(SlideMenu*)sharedMenuRight;

-(UIView*)headerForSection:(NSInteger)section;
-(SlideMenuItem*)itemAtIndexPath:(NSIndexPath*)indexPath;
-(NSInteger)sectionCount;

-(void)addSectionWithName:(NSString*)name items:(NSArray*)items;
-(void)addSectionWithName:(NSString*)name items:(NSArray*)items headerColor:(UIColor*)color;
-(void)addSectionWithHeader:(UIView*)name items:(NSArray*)items;
-(void)addSectionWithName:(NSString*)name items:(NSArray*)items atIndex:(NSInteger)index;
-(void)addSectionWithName:(NSString*)name items:(NSArray*)items headerColor:(UIColor*)color atIndex:(NSInteger)index;
-(void)addSectionWithHeader:(UIView*)name items:(NSArray*)items atIndex:(NSInteger)index;
-(void)addItem:(SlideMenuItem*)item inSection:(NSInteger)section;

-(void)replaceItemsInSection:(NSInteger)section withItems:(NSArray*)items;

-(void)removeSection:(NSInteger)section;
-(void)removeItemAtIndexPath:(NSIndexPath*)indexPath;
-(void)clearItemsInSection:(NSInteger)section;
-(void)clearItems;

@end
