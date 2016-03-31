//
//  CITask.m
//  CheckIt
//
//  Created by DmitryKretsu on 18.01.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import "CITask.h"

@implementation CITask

- (instancetype)initWithTitle:(NSString *)title info:(NSString *)info completed:(BOOL)completed {
        self = [super init];
        if (self) {
            self.title = title;
            self.info = info;
            self.completed = completed;
        }
        return self;
    }

@end