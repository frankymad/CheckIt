//
//  CITaskDetailsViewController.m
//  CheckIt
//
//  Created by DmitryKretsu on 18.03.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import "CITaskDetailsViewController.h"

@interface CITaskDetailsViewController ()

@end

@implementation CITaskDetailsViewController
@synthesize taskLabel;
@synthesize detailLabel;
@synthesize navbar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.taskLabel.text = self.titlecontents;
    self.detailLabel.text = self.subtitlecontents;
    self.navbar.title = self.titlecontents;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
