//
//  CITaskTableViewController.h
//  CheckIt
//
//  Created by DmitryKretsu on 18.01.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CITaskTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) NSMutableArray* tasks;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end