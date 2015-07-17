//
//  BeaconDemoMasterViewController.m
//  BeaconDemo
//
//  Created by Trent Shumay on 3/3/2014.
//  Copyright (c) 2014 IoT Design Shop. All rights reserved.
//

#import "BeaconDemoMasterViewController.h"
#import "BeaconDemoDetailViewController.h"
#import "BeaconNotificationRegion.h"
#import "BeaconDemoAppDelegate.h"
#import "BeaconCell.h"

@interface BeaconDemoMasterViewController ()
@property (strong, nonatomic) NSTimer* updateTimer;
@end

@implementation BeaconDemoMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    // This is boilerplate code provided by Xcode when you set up a master-detail project
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewNotification:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

-(void)viewWillAppear:(BOOL)animated
{
    // Reload the data in our table in case records were added or changed
    [self.tableView reloadData];
    
    // We start a timer to update the cells in the view every second
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTable:) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    // Stop our update timer while the view is not in the foreground
    [_updateTimer invalidate];
    _updateTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewNotification:(id)sender
{
    // This handler is called when the "Add" button is pressed - we
    // create a new notification region in the detail view
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

#pragma mark - Table View

-(void)updateTable:(NSTimer*)timer
{
    // This is a timer callback that gets hit every 1s to
    // refresh the cells in the table for new ranging and
    // state information.
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Our app delegate owns all of the notification regions,
    // so we retrieve the count from the delegate
    BeaconDemoAppDelegate* delegate = (BeaconDemoAppDelegate*)[[UIApplication sharedApplication] delegate];
    return [delegate notificationRegionCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeaconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    // Our app delegate owns all of the notification regions, so we retrieve the record from it
    BeaconDemoAppDelegate* delegate = (BeaconDemoAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    BeaconNotificationRegion* region = [delegate notificationRegionAtIndex:indexPath.row];
    
    // Convert beacon proximity to an English description
    if (region.lastState == CLRegionStateInside)
    {
        // We're in the region, so use proximity values from the last ranging
        // operation to update the view
        NSArray* proximityDescriptions = @[ @"Unknown", @"Immediate", @"Near", @"Far"];
        cell.beaconProximity.text = proximityDescriptions[region.lastProximity];
        cell.beaconRange.text = [NSString stringWithFormat:@"%.2fm", region.lastAccuracy];
        cell.beaconRSSI.text = [NSString stringWithFormat:@"%lddB", region.lastRSSI];
    }
    else
    {
        // We're outside the region, let the user know
        cell.beaconProximity.text = @"Not In Range";
        cell.beaconRange.text = @"0.0m";
        cell.beaconRSSI.text = @"0dB";
    }
    
    // ID labels so we can pick out which cell is which
    cell.beaconUUID.text = region.beaconUUID;
    cell.beaconID.text = [NSString stringWithFormat:@"Major: %@ Minor: %@", region.beaconMajor?[region.beaconMajor stringValue]:@"All", region.beaconMinor?[region.beaconMinor stringValue]:@"All"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // All of our rows are editable
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Our app delegate owns all of the notification regions, so we tell it to
        // remove the corresponding one to the user's selection
        BeaconDemoAppDelegate* delegate = (BeaconDemoAppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate removeNotificationRegionAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath)
        {
            // Our app delegate owns all of the notification regions, so we pull the value from there
            BeaconDemoAppDelegate* delegate = (BeaconDemoAppDelegate*)[[UIApplication sharedApplication] delegate];
            
            // Tell the destination controller that we're editing an existing item by passing
            // that item through. 
            [[segue destinationViewController] setDetailItem:[delegate notificationRegionAtIndex:indexPath.row]];
        }
        
    }
}

@end
