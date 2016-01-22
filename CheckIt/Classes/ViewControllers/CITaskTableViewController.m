//
//  CITaskTableViewController.m
//  CheckIt
//
//  Created by DmitryKretsu on 18.01.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import "CITaskTableViewController.h"

@interface CITaskTableViewController () <UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *tasks;

@end

@implementation CITaskTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tasks = @[@{@"task" : @"Work hard!", @"description" : @"You must work harded)"},
                   @{@"task" : @"Learn delegates!", @"description" : @"You need them)"},
                   @{@"task" : @"Learn protocols!", @"description" : @"You need them to!)"
                     }].mutableCopy;
    self.navigationItem.title = @"Check it";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewTask:)];
}



#pragma mark - addind new tasks

-(void)addNewTask:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add new task" message:@"Inter new task and description" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *taskNameField = [alert.textFields objectAtIndex:0];
        UITextField *taskDescriptionField = [alert.textFields objectAtIndex:1];
        NSString *taskName = taskNameField.text;
        NSString *taskDescription = taskDescriptionField.text;
        NSDictionary *newTask = @{@"task" : taskName, @"description" : taskDescription};
        [self.tasks addObject:newTask];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.tasks.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *taskNameField) {
        taskNameField.placeholder = @"Task name";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *taskDescriptionField) {
        taskDescriptionField.placeholder = @"Description";
    }];
    [self presentViewController:alert animated:YES completion:nil];}
 
#pragma mark - datasource

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
    NSDictionary *tasks = self.tasks[indexPath.row];
    cell.textLabel.text = tasks[@"task"];
    cell.detailTextLabel.text = tasks[@"description"];
    
    if ([tasks[@"completed"] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - check and uncheck row

-(void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSMutableDictionary *task = [self.tasks[indexPath.row] mutableCopy];
    BOOL completed = [task[@"completed"] boolValue];
    task[@"completed"] = @(!completed);
    self.tasks[indexPath.row] = task;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = ([task[@"completed"] boolValue]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
