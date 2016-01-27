//
//  CITaskTableViewController.m
//  CheckIt
//
//  Created by DmitryKretsu on 18.01.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import "CITask.h"
#import "CITaskTableViewController.h"

@interface CITaskTableViewController () <UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *tasks;
@property (nonatomic, strong) UILongPressGestureRecognizer *lpgr;

@end

@implementation CITaskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tasks = @[[[CITask alloc] initWithTitle:@"Work hard!" subtitle:@"You must work harder" completed:NO],
                   [[CITask alloc] initWithTitle:@"Learn delegates!" subtitle:@"You need them" completed:NO],
                   [[CITask alloc] initWithTitle:@"Learn protocols!" subtitle:@"You need them to!" completed:NO],
                   ].mutableCopy;
    
    self.navigationItem.title = @"Check it";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewTask:)];
    
    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEditing:)];
    self.lpgr.minimumPressDuration = .5f;
    self.lpgr.allowableMovement = 100.0f;
    
    [self.view addGestureRecognizer:self.lpgr];
}

#pragma mark - editing

- (void)longPressEditing:(UILongPressGestureRecognizer *)sender {
    if ([sender isEqual:self.lpgr]) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            [self.tableView setEditing:!self.tableView.editing animated:YES];
        }
    }
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
            CITask *newTask = [[CITask alloc] initWithTitle:taskName subtitle:taskDescription completed:NO];
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

#pragma mark - table datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TasksItemRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    CITask *task = self.tasks[(NSUInteger) indexPath.row];
    cell.textLabel.text = task.title;
    cell.detailTextLabel.text = task.subtitle;
    if (task.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - check and uncheck row

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CITask *task = self.tasks[(NSUInteger) indexPath.row];
    BOOL completed = task.completed;
    task.completed = !completed;
    self.tasks[(NSUInteger) indexPath.row] = task;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = (task.completed) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.textLabel.textColor = (task.completed) ? [UIColor lightGrayColor] : [UIColor blackColor];
    cell.detailTextLabel.textColor = (task.completed) ? [UIColor lightGrayColor] : [UIColor blackColor];
    NSLog(@"Check");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
 
#pragma mark - delete task

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tasks removeObjectAtIndex:(NSUInteger) indexPath.row];
        [tableView reloadData];
    }
}

@end
