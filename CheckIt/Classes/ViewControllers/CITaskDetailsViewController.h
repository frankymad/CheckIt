//
//  CITaskDetailsViewController.h
//  CheckIt
//
//  Created by DmitryKretsu on 18.03.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

@protocol SendDataProtocol <NSObject>

-(void)sendNewTask:(NSString *)name info:(NSString *)info date:(NSDate *)date;

@end

#import <UIKit/UIKit.h>
#import "Task.h"

@interface CITaskDetailsViewController : UIViewController <UITextViewDelegate>

@property(nonatomic,assign)id sendDataProtocolDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *checkMark;
@property (weak, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *taskInfoPlaceholderField;
@property (weak, nonatomic) IBOutlet UITextView *taskInfoTextView;
@property (weak, nonatomic) IBOutlet UIButton *deleteDate;
@property (weak, nonatomic) IBOutlet UITextField *taskDateField;
@property (assign, nonatomic) BOOL editingNewTask;
@property (strong, nonatomic) Task *detailItem;

- (IBAction)deleteDateButton:(UIButton *)sender;

@end