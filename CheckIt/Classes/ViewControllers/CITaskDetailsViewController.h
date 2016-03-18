//
//  CITaskDetailsViewController.h
//  CheckIt
//
//  Created by DmitryKretsu on 18.03.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CITaskDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *navbar;
@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) NSString *titlecontents;
@property (weak, nonatomic) NSString *subtitlecontents;

@end
