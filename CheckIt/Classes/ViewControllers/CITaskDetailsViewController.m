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

@property (nonatomic, assign) BOOL datePickerActive;
@property (nonatomic, retain) NSString *addTaskName;
@property (nonatomic, retain) NSString *addTaskInfo;
@property (nonatomic, retain) NSDate *addTaskDate;


@end

@implementation CITaskDetailsViewController

#pragma mark - load data

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButton:)];
    self.taskNameTextField.enabled = YES;
    self.taskInfoTextView.delegate = self;
    
    if (self.editingNewTask)
    {
        self.navigationItem.title = @"New Task";
        self.checkMark.image = [UIImage imageNamed:@"Unchecked"];
    }
    else
    {
        self.navigationItem.title = @"Task";
        self.taskNameTextField.text = self.detailItem.name;
        self.taskInfoTextView.text = self.detailItem.info;
        self.taskInfoPlaceholderField.placeholder = (self.detailItem.info.length == 0) ? @"Task Description" : @"";
        self.checkMark.image = [self.detailItem.complete boolValue] ? [UIImage imageNamed:@"Checked"] : [UIImage imageNamed:@"Unchecked"];
        
        if (self.detailItem.date != NULL)
        {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            NSDate *eventDate = self.detailItem.date;
            [dateFormat setDateFormat:@"dd/MM/yy EE"];
            NSString *dateString = [dateFormat stringFromDate:eventDate];
            NSDate *today = [NSDate date];
            NSTimeInterval secondsBetween = [self.detailItem.date timeIntervalSinceDate:today];
            float floatOfDays = secondsBetween / 86400;
            NSString *stringOfDays;
            floatOfDays = ceilf(floatOfDays);

            if (floatOfDays == 0)
            {
                self.taskDateField.text = [NSString stringWithFormat:@"%@ - today",dateString];
            }
            else if (floatOfDays > 1)
            {
                stringOfDays = @" days left";
                self.taskDateField.text = [NSString stringWithFormat:@"%@ - %.f%@",dateString, floatOfDays, stringOfDays];
            }
            else if (floatOfDays == -1)
            {
                self.taskDateField.text = [NSString stringWithFormat:@"%@ - yesterday",dateString];
            }
            else if (floatOfDays == 1)
            {
                self.taskDateField.text = [NSString stringWithFormat:@"%@ - tomorrow",dateString];
            }
            else
            {
                floatOfDays = fabsf(floatOfDays);
                stringOfDays = @" days missed";
                self.taskDateField.text = [NSString stringWithFormat:@"%@ - %.f%@",dateString, floatOfDays, stringOfDays];
            }
        }
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    [self.checkMark addGestureRecognizer:tap];
    [self.checkMark setUserInteractionEnabled:YES];

    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.date = (self.editingNewTask) ? [NSDate date] : ((self.detailItem.date != NULL) ? self.detailItem.date : [NSDate date]);
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.taskDateField setInputView:datePicker];
    
    CGRect frame;
    frame = self.taskInfoTextView.frame;
    frame.size.height = [self.taskInfoTextView contentSize].height;
    self.taskInfoTextView.frame = frame;
}

- (void)imageTap:(UITapGestureRecognizer *)sender
{
    BOOL number = [self.detailItem.complete boolValue];
    self.detailItem.complete = [NSNumber numberWithBool:!number];
    self.checkMark.image = [self.detailItem.complete boolValue] ? [UIImage imageNamed:@"Checked"] : [UIImage imageNamed:@"Unchecked"];
}

-(void) dateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.taskDateField.inputView;
    picker.minimumDate = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    self.detailItem.date = picker.date;
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    self.taskDateField.text = [NSString stringWithFormat:@"%@",dateString];
}

- (void) textViewDidBeginEditing:(UITextView *) textView
{
    self.taskInfoPlaceholderField.placeholder = @"";
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([self.taskInfoTextView.text length] == 0)
    {
        self.taskInfoPlaceholderField.placeholder = @"Task Description";
    }
}

- (void)defaultTaskDescriptionText
{
    self.taskInfoTextView.text = @"Task description";
    self.taskInfoTextView.textColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.0];
}


- (NSDate* )stringToDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yy"];
    NSDate *date = [dateFormat dateFromString:self.taskDateField.text];
    return date;
}

- (IBAction)deleteDateButton:(UIButton *)sender
{
    self.taskDateField.text = @"";
    self.detailItem.date = NULL;
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}


- (void)backButton:(id)sender
{
    if (self.taskNameTextField.text.length == 0 && self.taskInfoTextView.text.length == 0 && self.taskDateField.text.length == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else if (self.taskNameTextField.text.length == 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Task should have a title." message:@"Do you want to continue editing task?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        
        UIAlertAction *cancelar = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                   {
                                       
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
        [alert addAction:cancelar];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        if (self.editingNewTask && self.taskNameTextField.text.length != 0)
            {
                self.addTaskName = self.taskNameTextField.text;
                self.addTaskInfo = [self.taskInfoTextView.text isEqualToString:@"Task description"] ? @"" : self.taskInfoTextView.text;
                self.addTaskDate = self.stringToDate;
        
                [_sendDataProtocolDelegate sendNewTask:self.addTaskName info:self.addTaskInfo date:self.addTaskDate];
                
                [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            self.detailItem.name = self.taskNameTextField.text;
            self.detailItem.info = self.taskInfoTextView.text;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
