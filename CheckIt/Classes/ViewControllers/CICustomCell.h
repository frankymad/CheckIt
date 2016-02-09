//
//  CICustomCell.h
//  CheckIt
//
//  Created by DmitryKretsu on 08.02.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CICustomCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *taskLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;
@property (nonatomic, weak) IBOutlet UIImageView *checkMark;

@end
