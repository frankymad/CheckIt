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

@property (nonatomic, strong, readwrite) NSMutableArray *tasks;
@property (nonatomic, strong) UILongPressGestureRecognizer *longTap;

@end

@implementation CITaskTableViewController

#pragma mark - Подгружаем массив из объектор CITask, задаем заголовок и элементы навигации. Добавляем обработчик длинного тапа.

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tasks = @[[[CITask alloc] initWithTitle:@"Task1" info:@"Long info руский текст... посмотрим как сработают переносы. Фактически переносы должны работать нормально, но тут увереным быть нельзя на 100%." completed:NO],
                   [[CITask alloc] initWithTitle:@"Task2" info:@"Info2" completed:NO],
                   [[CITask alloc] initWithTitle:@"Task3" info:@"Info3" completed:YES],
                   [[CITask alloc] initWithTitle:@"Task4" info:@"Info4" completed:NO],
                   [[CITask alloc] initWithTitle:@"Task5" info:@"Info5" completed:YES],
                   [[CITask alloc] initWithTitle:@"Task6" info:@"Info6" completed:NO],
                   ].mutableCopy;
    
    self.navigationItem.title = @"Check it";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(enterNewTask:)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEditing:)];
    self.longTap.minimumPressDuration = .5;
    self.longTap.allowableMovement = 100.0;
    [self.view addGestureRecognizer:self.longTap];
}

#pragma mark - Обновляем таблицу при появлении view.

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - Обрабатываем длинный тап и переключаем режим редактирования tableView.

- (void)longPressEditing:(UILongPressGestureRecognizer *)sender
{
    if (sender == self.longTap) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            [self.tableView setEditing:!self.tableView.editing animated:YES];
        }
    }
    self.navigationItem.rightBarButtonItem = (self.tableView.editing) ? [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButton:)] : [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(enterNewTask:)];
    [self.tableView reloadData];
}

#pragma mark - Обработка нажатия кнопки "Done" в активном режиме редактирования tableView.

- (void)doneButton:(UIBarButtonItem *)sender
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(enterNewTask:)];
    [self.tableView setEditing:NO];
    [self.tableView reloadData];
}

#pragma mark - Обработка нажатия кнопки "+" - добавление нового таска.

- (void)enterNewTask:(id)sender
{
    CITaskDetailsViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"CITaskDetailsViewController"];
    detailView.newTaskBoolean = YES;
    detailView.delegate = self;
    [self.navigationController pushViewController:detailView animated:YES];
}

#pragma mark - Получение данных из CITaskDetailViewController, добавление объекта в массив и обновление tableView.

- (void)sendNewTask:(NSString *)name info:(NSString *)info
{
    CITask *newTask = [[CITask alloc] initWithTitle:name info:info completed:NO];
    [self.tasks addObject:newTask];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.tasks.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Обработка нажатия на ячейку tableView и передача данных в CITaskDetailsViewController.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CITask *task = self.tasks[(NSUInteger) indexPath.row];
        BOOL newTask = NO;
        [[segue destinationViewController] setNewTaskBoolean:newTask];
        [[segue destinationViewController] setTask:task];
    }
}

#pragma mark - Формирование и настройка tableView.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CICustomCell";
    CICustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    CITask *task = self.tasks[(NSUInteger) indexPath.row];
    cell.taskLabel.text = task.title;
    cell.detailLabel.text = task.info;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tasks.count;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Обработка нажатия на изображение, удаление записи или снятие/отметки completed.

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
