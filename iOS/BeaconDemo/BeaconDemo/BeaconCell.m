//
//  BeaconCell.m
//  BeaconDemo
//
//  Created by Trent Shumay on 2014-03-07.
//  Copyright (c) 2014 IoT Design Shop. All rights reserved.
//

#import "BeaconCell.h"

@implementation BeaconCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
