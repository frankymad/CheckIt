//
//  CITaskTableViewController.h
//  CheckIt
//
//  Created by DmitryKretsu on 18.01.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CITaskTableViewController : UITableViewController

@property (nonatomic, strong, readonly) NSMutableArray* tasks;

@end