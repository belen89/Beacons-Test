//
//  BeaconDemoDetailViewController.h
//  BeaconDemo
//
//  Created by Trent Shumay on 3/3/2014.
//  Copyright (c) 2014 IoT Design Shop. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BeaconNotificationRegion;

@interface BeaconDemoDetailViewController : UIViewController <UITextFieldDelegate>

// If we are editing an existing item, pass it through to the object
// in this property.
@property (strong, nonatomic) BeaconNotificationRegion* detailItem;

@end
