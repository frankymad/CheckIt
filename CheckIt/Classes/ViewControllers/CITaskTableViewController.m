//
//  CITaskTableViewController.m
//  CheckIt
//
//  Created by DmitryKretsu on 18.01.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import "CITask.h"
#import "CITaskTableViewController.h"
#import "CITaskDetailsViewController.h"
#import "CICustomCell.h"

@interface CITaskTableViewController () <UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *tasks;
@property (nonatomic, strong) UILongPressGestureRecognizer *lpgr;
@property (nonatomic, strong) UITapGestureRecognizer *stgr;

@end

@implementation CITaskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tasks = @[[[CITask alloc] initWithTitle:@"Task1" subtitle:@"Subtitle1" info:@"Long info руский текст... посмотрим как сработают переносы. Фактически переносы должны работать нормально, но тут увереным быть нельзя на 100%." completed:NO],
                   [[CITask alloc] initWithTitle:@"Task2" subtitle:@"Subtitle2" info:@"Info 2" completed:NO],
                   [[CITask alloc] initWithTitle:@"Task3" subtitle:@"Subtitle3" info:@"Info3" completed:YES],
                   [[CITask alloc] initWithTitle:@"Task4" subtitle:@"Subtitle4" info:@"Info4" completed:NO],
                   [[CITask alloc] initWithTitle:@"Task5" subtitle:@"Subtitle5" info:@"Info5" completed:YES],
                   [[CITask alloc] initWithTitle:@"Task6" subtitle:@"Subtitle6" info:@"Info6" completed:NO],
                   ].mutableCopy;
    
    self.navigationItem.title = @"Check it";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewTask:)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEditing:)];
    self.lpgr.minimumPressDuration = .5f;
    self.lpgr.allowableMovement = 100.0f;
    [self.view addGestureRecognizer:self.lpgr];
}

#pragma mark - editing

- (void)longPressEditing:(UILongPressGestureRecognizer *)sender {
    if ([sender isEqual:self.lpgr]) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            
            [self.tableView setEditing:!self.tableView.editing animated:NO];
            
        }
    }
    [self.tableView reloadData];
}

#pragma mark - addind new tasks

- (void)addNewTask:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add new task" message:@"Write new task name and description" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *taskNameField = alert.textFields[0];
        UITextField *taskDescriptionField = alert.textFields[1];
        NSString *taskName = taskNameField.text;
        NSString *taskDescription = taskDescriptionField.text;
        
        if (taskName.length != 0) {
            CITask *newTask = [[CITask alloc] initWithTitle:taskName subtitle:taskDescription info:@"None" completed:NO];
            [self.tasks addObject:newTask];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.tasks.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *taskNameField) {
        taskNameField.placeholder = @"Task name";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *taskDescriptionField) {
        taskDescriptionField.placeholder = @"Description";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Detail View
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CITask *task = self.tasks[(NSUInteger) indexPath.row];
        [[segue destinationViewController] setTask:task];
    }
}

#pragma mark - table datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CICustomCell";
    CICustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    CITask *task = self.tasks[(NSUInteger) indexPath.row];
    cell.taskLabel.text = task.title;
    cell.detailLabel.text = task.subtitle;
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    if (self.tableView.editing) {
        UIImage *image = [UIImage imageNamed:@"Delete"];
        [cell.checkMark setImage:image];
    }
    else {
        UIImage *image = (task.completed) ? [UIImage imageNamed:@"Checked"] : [UIImage imageNamed:@"Unchecked"];
        [cell.checkMark setImage:image];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    
    [cell.checkMark addGestureRecognizer:tap];
    [cell.checkMark setUserInteractionEnabled:YES];
    return cell;
}

#pragma mark - check/uncheck and delete task

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)imageTap:(UITapGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self.view];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    CITask *task = self.tasks[(NSUInteger) indexPath.row];
    if (self.tableView.editing) {
        [self.tasks removeObjectAtIndex:(NSUInteger) indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    else {
        BOOL completed = task.completed;
        task.completed = !completed;
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

@end
