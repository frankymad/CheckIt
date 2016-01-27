//
//  CITask.h
//  CheckIt
//
//  Created by DmitryKretsu on 18.01.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CITask : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *specification;
@property(nonatomic, assign) BOOL completed;

@end
