//
//  Task.h
//  CheckIt
//
//  Created by DmitryKretsu on 28.03.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSManagedObject

@property (nullable, nonatomic, retain) NSNumber *complete;
@property (nullable, nonatomic, retain) NSString *info;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *timeStamp;

@end

NS_ASSUME_NONNULL_END

