//
//  CITaskTableViewController.m
//  CheckIt
//
//  Created by DmitryKretsu on 18.01.16.
//  Copyright © 2016 Weezlabs. All rights reserved.
//

#import "AppDelegate.h"
#import "CITaskTableViewController.h"
#import "CITaskDetailsViewController.h"
#import "CICustomCell.h"
#import "Task.h"

@interface CITaskTableViewController () <UIAlertViewDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray *tasks;
@property (nonatomic, strong) UILongPressGestureRecognizer *longTapRecognizer;

@end

@implementation CITaskTableViewController

#pragma mark - load data 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Check it";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(enterNewTask:)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.longTapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEditing:)];
    self.longTapRecognizer.minimumPressDuration = .5;
    self.longTapRecognizer.allowableMovement = 100.0;
    [self.view addGestureRecognizer:self.longTapRecognizer];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
}

#pragma mark - update view table

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - long tap gesture recognizer

- (void)longPressEditing:(UILongPressGestureRecognizer *)sender
{
    if (sender == self.longTapRecognizer) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            [self.tableView setEditing:!self.tableView.editing animated:YES];
        }
    }
    self.navigationItem.rightBarButtonItem = (self.tableView.editing) ? [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneButton:)] : [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(enterNewTask:)];
    [self.tableView reloadData];
}

#pragma mark - "done" button action

- (void)doneButton:(UIBarButtonItem *)sender
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(enterNewTask:)];
    [self.tableView setEditing:NO];
    [self.tableView reloadData];
}

#pragma mark - "+" button action

- (void)enterNewTask:(id)sender
{
    CITaskDetailsViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"CITaskDetailsViewController"];
    detailView.editingNewTask = YES;
    detailView.sendDataProtocolDelegate = self;
    [self.navigationController pushViewController:detailView animated:YES];
}

#pragma mark - get data from detailView and add new task

- (void)sendNewTask:(NSString *)name info:(NSString *)info
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    Task *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
    //AppDelegate *appDelegate = [[AppDelegate alloc] init];
    
    newManagedObject.name = name;
    newManagedObject.info = info;
    newManagedObject.complete = NO;
    newManagedObject.timeStamp = [NSDate date];
    
    [self saveContext];
}

#pragma mark - detailView

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CITaskDetailsViewController *viewController = (CITaskDetailsViewController *)segue.destinationViewController;
        NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        viewController.detailItem = selectedObject;
    }
}

#pragma mark - table data

- (CICustomCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier =  NSStringFromClass([CICustomCell class]);
    CICustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(CICustomCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Task *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.taskNameLabel.text = object.name;
    cell.taskInfoLabel.text = object.info;

    if (self.tableView.editing) {
        UIImage *image = [UIImage imageNamed:@"Delete"];
        [cell.checkMark setImage:image];
    }
    else {
        UIImage *image = [object.complete boolValue] ? [UIImage imageNamed:@"Checked"] : [UIImage imageNamed:@"Unchecked"];
        [cell.checkMark setImage:image];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    [cell.checkMark addGestureRecognizer:tap];
    [cell.checkMark setUserInteractionEnabled:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
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

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];

    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    _fetchedResultsController.delegate = self;

    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //AppDelegate *appDelegate = [[AppDelegate alloc] init];
    [self saveContext];
    [self.tableView endUpdates];
}

#pragma mark - image tap action

- (void)imageTap:(UITapGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (self.tableView.editing)
    {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
    else {
        Task *selectedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        BOOL number = [selectedObject.complete boolValue];
        selectedObject.complete = [NSNumber numberWithBool:!number];
        //AppDelegate *appDelegate = [[AppDelegate alloc] init];
        [self saveContext];
    }
}

- (void)saveContext
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSError *error = nil;
    [context save:&error];
}
 
@end
