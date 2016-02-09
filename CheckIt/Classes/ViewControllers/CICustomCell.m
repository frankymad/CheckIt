//
//  CICustomCell.m
//  CheckIt
//
//  Created by DmitryKretsu on 08.02.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import "CICustomCell.h"

@implementation CICustomCell

@synthesize taskLabel = _taskLabel;
@synthesize detailLabel = _detailLabel;
@synthesize checkMark = _checkMark;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
