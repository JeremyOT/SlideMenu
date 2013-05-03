//
//  MIT License
//
//  Created by Jeremy Olmsted-Thompson on 2/8/12.
//  Copyright (c) 2012 JOT. All rights reserved.
//

#import "SlideMenu.h"
#import <QuartzCore/QuartzCore.h>

@interface SlideMenu ()

@property (nonatomic, retain) NSMutableArray *headers;
@property (nonatomic, retain) NSMutableArray *sections;

@end

@implementation SlideMenu

@synthesize tableView = _tableView;
@synthesize headers = _headers;
@synthesize sections = _sections;

#pragma mark - Singleton

+(SlideMenu*)sharedMenu {
    static SlideMenu *sharedMenu = nil;
    if (!sharedMenu) {
        sharedMenu = [[SlideMenu alloc] initWithDefaultFrame];
    }
    return sharedMenu;
}

+(SlideMenu*)sharedMenuRight {
    static SlideMenu *sharedMenuRight = nil;
    if (!sharedMenuRight) {
        sharedMenuRight = [[SlideMenu alloc] initWithDefaultFrame];
        sharedMenuRight.trayPosition = TrayPositionRight;
    }
    return sharedMenuRight;
}

#pragma mark - Lifecycle

-(id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _headers = [[NSMutableArray alloc] init];
        _sections = [[NSMutableArray alloc] init];
        [self addSubview:_tableView];
    }
    return self;
}

-(void)dealloc {
    [_tableView release];
    [_headers release];
    [_sections release];
    [super dealloc];
}

#pragma mark - Retrieving Items

-(UIView *)headerForSection:(NSInteger)section {
    return [_headers objectAtIndex:section];
}

-(SlideMenuItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

-(NSInteger)sectionCount {
    return [_sections count];
}

#pragma mark - Adding Items

-(UIView*)defaultHeaderForSectionName:(NSString*)name color:(UIColor*)color {
    UIView *header = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 32)] autorelease];
    header.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] CGColor],
                            (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] CGColor],
                            (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] CGColor],
                            nil];
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0],
                               [NSNumber numberWithFloat:0.5],
                               [NSNumber numberWithFloat:1.0],
                               nil];
    gradientLayer.frame = header.bounds;
    [header.layer insertSublayer:gradientLayer atIndex:0];
    UILabel *headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20, 32)] autorelease];
    headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    headerLabel.textColor = color;
    headerLabel.text = name;
    headerLabel.backgroundColor = [UIColor clearColor];
    [header addSubview:headerLabel];
    return header;
}

-(void)addSectionWithName:(NSString *)name items:(NSArray *)items {
    return [self addSectionWithName:name items:items headerColor:[UIColor whiteColor] atIndex:[_sections count]];
}

-(void)addSectionWithName:(NSString *)name items:(NSArray *)items atIndex:(NSInteger)index {
    [self addSectionWithName:name items:items headerColor:[UIColor whiteColor] atIndex:index];
}

-(void)addSectionWithName:(NSString *)name items:(NSArray *)items headerColor:(UIColor *)color {
    [self addSectionWithHeader:[self defaultHeaderForSectionName:name color:color] items:items];
}

-(void)addSectionWithName:(NSString *)name items:(NSArray *)items headerColor:(UIColor *)color atIndex:(NSInteger)index{
    [self addSectionWithHeader:[self defaultHeaderForSectionName:name color:color] items:items atIndex:index];
}

-(void)addSectionWithHeader:(UIView *)header items:(NSArray *)items {
    [self addSectionWithHeader:header items:items atIndex:[_sections count]];
}

-(void)addSectionWithHeader:(UIView *)header items:(NSArray *)items atIndex:(NSInteger)index {
    [_headers insertObject:header ? header : [NSNull null] atIndex:index];
    [_sections insertObject:[NSMutableArray arrayWithArray:items] atIndex:index];
    [self.tableView reloadData];
}

-(void)addItem:(SlideMenuItem *)item inSection:(NSInteger)section {
    [[_sections objectAtIndex:section] addObject:item];
    [self.tableView reloadData];
}

#pragma mark - Replacing Items

-(void)replaceItemsInSection:(NSInteger)section withItems:(NSArray *)items {
    [_sections replaceObjectAtIndex:section withObject:[NSMutableArray arrayWithArray:items]];
    [self.tableView reloadData];
}

#pragma mark - Removing Items

-(void)removeSection:(NSInteger)section {
    [_headers removeObjectAtIndex:section];
    [_sections removeObjectAtIndex:section];
    [self.tableView reloadData];
}

-(void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    [[_sections objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

-(void)clearItemsInSection:(NSInteger)section {
  [[_sections objectAtIndex:section] removeAllObjects];
  [self.tableView reloadData];
}

-(void)clearItems {
    [_headers removeAllObjects];
    [_sections removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sections count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id header = [_headers objectAtIndex:section];
    if ([header isKindOfClass:[NSNull class]]) {
        return 0;
    }
    return [header bounds].size.height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_sections objectAtIndex:section] count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id header = [_headers objectAtIndex:section];
    return [header isKindOfClass:[NSNull class]] ? nil : header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SlideMenuItem *item = [self itemAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.cellReuseIdentifier];
    if (!cell) {
        cell = [item generatedCell];
    }
    [item configureTableViewCell:cell];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self itemAtIndexPath:indexPath] cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SlideMenuItem *item = [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    BOOL closeMenu = [item runBlock];
    if (closeMenu) {
        [self hide];
    }
}

@end
