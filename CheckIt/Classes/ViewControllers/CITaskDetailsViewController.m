//
//  CITaskDetailsViewController.m
//  CheckIt
//
//  Created by DmitryKretsu on 18.03.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import "CITask.h"
#import "CITaskTableViewController.h"
#import "CITaskDetailsViewController.h"

@interface CITaskDetailsViewController ()

@end

@implementation CITaskDetailsViewController
//@synthesize navbar;
@synthesize task;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.taskLabel.text = task.title;
    self.detailLabel.text = task.subtitle;
    self.infoLabel.text = task.info;
    self.navbar.title = task.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
