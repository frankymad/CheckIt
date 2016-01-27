//
//  CITask.m
//  CheckIt
//
//  Created by DmitryKretsu on 18.01.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import "CITask.h"

@implementation CITask

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle completed:(BOOL)completed {
        self = [super init];
        if (self) {
            self.title = title;
            self.subtitle = subtitle;
            self.completed = completed;
        }
        return self;
    }


@end