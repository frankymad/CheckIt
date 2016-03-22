//
//  CITaskDetailsViewController.m
//  CheckIt
//
//  Created by DmitryKretsu on 18.03.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import "CITask.h"
#import "CITaskTableViewController.h"
#import "CITaskDetailsViewController.h"

@interface CITaskDetailsViewController ()

@property(nonatomic, assign) BOOL taskEdit;
@property (nonatomic, retain) NSString *addTaskName;
@property (nonatomic, retain) NSString *addTaskInfo;

@end

@implementation CITaskDetailsViewController

@synthesize addTaskInfo, addTaskName, delegate;

#pragma mark - Формирование и настройка текстовых полей.

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateView];
}

- (void)updateView
{
    if (self.newTaskBoolean)
    {
        self.navigationItem.title = @"New Task";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:nil action:@selector(saveTask:)];
        [self.infoLabel setDelegate:self];
        [self.infoLabel setEditable:YES];
        self.infoLabel.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.0];
        [self.taskLabel setEnabled:YES];
        [self.taskLabel becomeFirstResponder];
        self.chekmark.image = [UIImage imageNamed:@"Unchecked"];
    }
    else
    {
        self.navigationItem.title = @"Task";
        self.navigationItem.rightBarButtonItem = (self.taskEdit) ? [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:nil action:@selector(saveTask:)] : [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:nil action:@selector(editTask:)];
        self.taskLabel.text = self.task.title;
        self.infoLabel.text = self.task.info;
        [self.taskLabel setEnabled:NO];
        [self.infoLabel becomeFirstResponder];
        self.chekmark.image = (self.task.completed) ? [UIImage imageNamed:@"Checked"] : [UIImage imageNamed:@"Unchecked"];
    }
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if(self.infoLabel.tag == 0) {
        self.infoLabel.text = @"";
        self.infoLabel.textColor = [UIColor blackColor];
        self.infoLabel.tag = 1;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([self.infoLabel.text length] == 0)
    {
        self.infoLabel.text = @"Task description";
        self.infoLabel.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.0];
        self.infoLabel.tag = 0;
    }
}

#pragma mark - Обработка нажатия кнопки "Edit" и редактирование записи.

- (void)editTask:(UIBarButtonItem *)sender
{
    self.taskEdit = !self.taskEdit;
    [self.infoLabel setEditable:self.taskEdit];
    [self updateView];
}

#pragma mark - Обработка нажатия кнопки "Save".

- (void)saveTask:(UIBarButtonItem *)sender
{
    if (self.newTaskBoolean && self.taskLabel.text.length != 0)
    {
        addTaskName = self.taskLabel.text;
        addTaskInfo = ([self.infoLabel.text isEqualToString:@"Task description"]) ? @"" : self.infoLabel.text;
        [delegate sendNewTask:addTaskName info:addTaskInfo];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (!self.newTaskBoolean)
    {
        self.task.title = self.taskLabel.text;
        self.task.info = self.infoLabel.text;
        self.taskEdit = !self.taskEdit;
        [self.infoLabel setEditable:self.taskEdit];
        [self updateView];
    }
    else
    {
        self.infoLabel.text = @"Task description";
        [self updateView];
    }
}

@end
