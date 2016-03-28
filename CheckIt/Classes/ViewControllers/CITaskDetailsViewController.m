//
//  CITaskDetailsViewController.m
//  CheckIt
//
//  Created by DmitryKretsu on 18.03.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import "CITaskTableViewController.h"
#import "CITaskDetailsViewController.h"

@interface CITaskDetailsViewController ()

@property(nonatomic, assign) BOOL editingActive;
@property (nonatomic, retain) NSString *addTaskName;
@property (nonatomic, retain) NSString *addTaskInfo;

@end

@implementation CITaskDetailsViewController

@synthesize sendDataProtocolDelegate;

#pragma mark - load data

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    if (self.editingNewTask)
    {
        self.navigationItem.title = @"New Task";
        self.taskInfoTextView.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.0];
        self.taskInfoTextView.editable = YES;
        self.taskInfoTextView.delegate = self;
        self.taskNameTextField.enabled = YES;
        [self.taskNameTextField becomeFirstResponder];
    }
    else
    {
        NSLog(@"%@", [[self.detailItem valueForKey:@"taskName"] description]);
        self.navigationItem.title = @"Task";
        self.taskNameTextField.text = [[self.detailItem valueForKey:@"taskName"] description];
        self.taskInfoTextView.text = [[self.detailItem valueForKey:@"taskInfo"] description];
        self.taskNameTextField.enabled = NO;
    }
    
    [self updateControls];
}

#pragma mark - update buttons

- (void)updateControls
{
    if (self.editingNewTask)
    {
        self.navigationItem.rightBarButtonItem.title = @"Save";
        self.navigationItem.rightBarButtonItem.action = @selector(saveTask:);
        self.chekmark.image = [UIImage imageNamed:@"Unchecked"];
    }
    else
    {
        self.navigationItem.rightBarButtonItem.title = self.editingActive ? @"Save" : @"Edit";
        self.navigationItem.rightBarButtonItem.action = self.editingActive ? @selector(saveTask:) : @selector(editTask:);
        self.chekmark.image = [[self.detailItem valueForKey:@"taskComplete"] boolValue] ? [UIImage imageNamed:@"Checked"] : [UIImage imageNamed:@"Unchecked"];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(self.taskInfoTextView.tag == 0) {
        self.taskInfoTextView.text = @"";
        self.taskInfoTextView.textColor = [UIColor blackColor];
        self.taskInfoTextView.tag = 1;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([self.taskInfoTextView.text length] == 0)
    {
        [self defaultTaskDescriptionText];
        self.taskInfoTextView.tag = 0;
    }
}

- (void)defaultTaskDescriptionText
{
    self.taskInfoTextView.text = @"Task description";
    self.taskInfoTextView.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.0];
}

#pragma mark - edit button action

- (void)editTask:(id)sender
{
    self.editingActive = !self.editingActive;
    self.taskInfoTextView.editable = self.editingActive;
    [self.taskInfoTextView becomeFirstResponder];
    [self updateControls];
}

#pragma mark - save button action

- (void)saveTask:(id)sender
{
    if (self.editingNewTask && self.taskNameTextField.text.length != 0)
    {
        self.addTaskName = self.taskNameTextField.text;
        self.addTaskInfo = [self.taskInfoTextView.text isEqualToString:@"Task description"] ? @"" : self.taskInfoTextView.text;
        
        [sendDataProtocolDelegate sendNewTask:self.addTaskName info:self.addTaskInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (!self.editingNewTask)
    {
        [self.detailItem setValue:self.taskInfoTextView.text forKey:@"taskInfo"];
        self.editingActive = !self.editingActive;
        self.taskInfoTextView.editable = self.editingActive;
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Task name can't be blank." preferredStyle:UIAlertControllerStyleAlert];

        [self presentViewController:alert animated:YES completion:nil];
        [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:2.0];
        [self defaultTaskDescriptionText];
    }
    [self updateControls];
}

#pragma mark - dismiss alert "Empty task"

-(void)dismissAlert:(UIAlertController*)alert
{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

@end
