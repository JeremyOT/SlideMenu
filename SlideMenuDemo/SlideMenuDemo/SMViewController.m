//
//  MIT License
//
//  Created by Jeremy Olmsted-Thompson on 2/8/12.
//  Copyright (c) 2012 JOT. All rights reserved.
//

#import "SMViewController.h"
#import "SlideMenu.h"
#import "SlideMenuItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation SMViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    SlideMenu *menu = [SlideMenu sharedMenu];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [menu setUIInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown supported:NO];
        [menu setUIInterfaceOrientation:UIInterfaceOrientationLandscapeLeft supported:NO];
        [menu setUIInterfaceOrientation:UIInterfaceOrientationLandscapeRight supported:NO];
    }
    BOOL (^block)(SlideMenuItem *item) = ^(SlideMenuItem *item) {
        NSLog(@"Clicked: %@", item.title);
        return YES;
    };
    [menu clearItems];
    NSArray *items = [NSArray arrayWithObjects:
                      [[[SlideMenuItem alloc] initWithTitle:@"Item 1" block:block accessoryType:UITableViewCellAccessoryDisclosureIndicator] autorelease],
                      [[[SlideMenuItem alloc] initWithTitle:@"Item 2" block:block] autorelease],
                      [[[SlideMenuItem alloc] initWithTitle:@"Item 3" block:block] autorelease],
                      nil];
    [menu addSectionWithName:@"Header 1" items:items];
    UIView *accView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] autorelease];
    accView.layer.cornerRadius = 10;
    accView.backgroundColor = [UIColor whiteColor];
    NSArray *moreItems = [NSArray arrayWithObjects:
                          [[[SlideMenuItem alloc] initWithTitle:@"Item 4" block:block accessoryView:accView] autorelease],
                          [[[SlideMenuItem alloc] initWithTitle:@"Item 5" block:block accessoryType:UITableViewCellAccessoryNone icon:nil textColor:[UIColor lightGrayColor] backgroundColor:nil] autorelease],
                          [[[SlideMenuItem alloc] initWithTitle:@"Item 6" block:block accessoryType:UITableViewCellAccessoryNone icon:nil textColor:nil backgroundColor:[UIColor darkGrayColor]] autorelease],
                          nil];
    [menu addSectionWithName:@"Header 2" items:moreItems];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

-(void)showMenu:(id)sender {
    SlideMenu *menu = [SlideMenu sharedMenu];
    if (!menu.displayed) {
        [menu showInWindow:self.view.window];
    } else {
        [menu hide];
    }
}

@end
