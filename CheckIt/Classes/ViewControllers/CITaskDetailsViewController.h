//
//  CITaskDetailsViewController.h
//  CheckIt
//
//  Created by DmitryKretsu on 18.03.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

@protocol senddataProtocol <NSObject>

-(void)sendNewTask:(NSString *)name info:(NSString *)info;

@end

#import <UIKit/UIKit.h>

@interface CITaskDetailsViewController : UIViewController <UITextViewDelegate>

@property(nonatomic,assign)id delegate;

@property (weak, nonatomic) IBOutlet UIImageView *chekmark;
@property (weak, nonatomic) IBOutlet UITextField *taskLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoLabel;
@property (strong, nonatomic) CITask *task;
@property (assign, nonatomic) BOOL newTaskBoolean;

@end