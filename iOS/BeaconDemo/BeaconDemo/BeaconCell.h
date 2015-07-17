//
//  BeaconCell.h
//  BeaconDemo
//
//  Created by Trent Shumay on 2014-03-07.
//  Copyright (c) 2014 IoT Design Shop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* beaconUUID;
@property (strong, nonatomic) IBOutlet UILabel* beaconID;
@property (strong, nonatomic) IBOutlet UILabel* beaconProximity;
@property (strong, nonatomic) IBOutlet UILabel* beaconRange;
@property (strong, nonatomic) IBOutlet UILabel* beaconRSSI;
@end
