//
//  Task+CoreDataProperties.h
//  CheckIt
//
//  Created by DmitryKretsu on 28.03.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *complete;
@property (nullable, nonatomic, retain) NSString *info;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *timeStamp;

@end

NS_ASSUME_NONNULL_END
