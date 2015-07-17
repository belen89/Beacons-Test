//
//  BeaconDemoDetailViewController.m
//  BeaconDemo
//
//  Created by Trent Shumay on 3/3/2014.
//  Copyright (c) 2014 IoT Design Shop. All rights reserved.
//

#import "BeaconDemoDetailViewController.h"
#import "BeaconNotificationRegion.h"
#import "BeaconDemoAppDelegate.h"

@interface BeaconDemoDetailViewController ()

// The UI is very simple - we have UITextField's for all of the editable parameters
@property (strong, nonatomic) IBOutlet UITextField* beaconUUID;
@property (strong, nonatomic) IBOutlet UITextField* beaconMajor;
@property (strong, nonatomic) IBOutlet UITextField* beaconMinor;
@property (strong, nonatomic) IBOutlet UITextField* helloMessage;
@property (strong, nonatomic) IBOutlet UITextField* goodbyeMessage;

- (void)configureView;

@end

@implementation BeaconDemoDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    // Update the field values if the item has changed
    if (_detailItem != newDetailItem) {
        
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // If an existing item was passed into the view, we init the fields
    // with the values from the item
    if (_detailItem)
    {
        // Init Beacon UUID
        _beaconUUID.text = _detailItem.beaconUUID;
        
        // Init Beacon Major (if one is specified)
        if (_detailItem.beaconMajor)
        {
            _beaconMajor.text = [_detailItem.beaconMajor stringValue];
        }
        
        // Init Beacon Minor (if one is specified)
        if (_detailItem.beaconMinor)
        {
            _beaconMinor.text = [_detailItem.beaconMinor stringValue];
        }
        
        // Messages
        _helloMessage.text = _detailItem.helloMessage;
        _goodbyeMessage.text = _detailItem.goodbyeMessage;
    }
    else
    {
        // Default values - this is the IoT Design Shop Default Beacon UUID
        _beaconUUID.text = @"2173E519-9155-4862-AB64-7953AB146156";
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // We don't do that much validation, but it's easy to make a mistake
    // entering a UUID, so we check the UUID field to make sure it's a valid
    // UUID.
    if (textField == _beaconUUID)
    {
        if (textField.text.length)
        {
            NSUUID* valid = [[NSUUID alloc] initWithUUIDString:textField.text];
            
            if (!valid)
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid UUID" message:@"The UUID you entered does not appear to be valid. Please double check it." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
    
    // To keep it simple, we have return just dismiss the keyboard
    [textField resignFirstResponder];
    
    return YES;
}

// Called when user clicks the "Register Notification" button
-(IBAction)registerNotification:(id)sender
{
    BeaconNotificationRegion* region = [[BeaconNotificationRegion alloc] init];
    
    // Copy our UI values into the new region object
    region.beaconUUID = _beaconUUID.text;
    
    if (_beaconMajor.text.length)
    {
        region.beaconMajor = [NSNumber numberWithInteger:[_beaconMajor.text integerValue]];
    }
    
    if (_beaconMinor.text.length)
    {
        region.beaconMinor = [NSNumber numberWithInteger:[_beaconMinor.text integerValue]];
    }
    
    region.helloMessage = _helloMessage.text;
    region.goodbyeMessage = _goodbyeMessage.text;
    
        

    BeaconDemoAppDelegate* delegate = (BeaconDemoAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // If this is an update, we unregister the old region first
    if (_detailItem)
    {
        // Remove the old region
        [delegate removeNotificationRegion:_detailItem];
    }
    
    // Register the region
    [delegate addNotificationRegion:region];
         
    
    
    // Back to the master view
    [self.navigationController popViewControllerAnimated:YES];
}



@end
