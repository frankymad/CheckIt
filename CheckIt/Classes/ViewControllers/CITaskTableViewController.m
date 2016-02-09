//
//  CITaskTableViewController.m
//  CheckIt
//
//  Created by DmitryKretsu on 18.01.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import "CITask.h"
#import "CITaskTableViewController.h"
#import "CICustomCell.h"

@interface CITaskTableViewController () <UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *tasks;
@property (nonatomic, strong) UILongPressGestureRecognizer *lpgr;
@property (nonatomic, strong) UITapGestureRecognizer *stgr;

@end

@implementation CITaskTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tasks = @[[[CITask alloc] initWithTitle:@"Work hard!" subtitle:@"You must work harder" completed:NO],
                   [[CITask alloc] initWithTitle:@"Learn delegates!" subtitle:@"You need them" completed:NO],
                   [[CITask alloc] initWithTitle:@"Learn protocols!" subtitle:@"You need them to!" completed:YES],
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
            
            [self.tableView setEditing:!self.tableView.editing animated:NO];
            
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
    static NSString *CellIdentifier = @"CICustomCell";
    CICustomCell *cell = (CICustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CICustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    CITask *task = self.tasks[(NSUInteger) indexPath.row];
    cell.taskLabel.text = task.title;
    cell.detailLabel.text = task.subtitle;
    UIImage *image = (task.completed) ? [UIImage imageNamed:@"check.png"] : [UIImage imageNamed:@"uncheck.png"];
    [cell.checkMark setImage:image];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    
    [cell.checkMark addGestureRecognizer:tap];
    [cell.checkMark setUserInteractionEnabled:YES];
    return cell;
}

#pragma mark - check and uncheck row

- (void)imageTap:(UITapGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self.view];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    CITask *task = self.tasks[(NSUInteger) indexPath.row];
    BOOL completed = task.completed;
    task.completed = !completed;
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}
#pragma mark - delete task

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
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
