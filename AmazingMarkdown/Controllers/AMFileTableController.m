//
//  AMFileTableController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/5.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMFileTableController.h"
#import "AMEdittingContentController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "AMMarkdownFile+CoreDataClass.h"

@interface AMFileTableController ()

@property(nonatomic, strong) NSMutableArray * fileArray;

@end

@implementation AMFileTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self->_fileArray = [[AMMarkdownFile MR_findAll] mutableCopy];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->_fileArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileTableCell" forIndexPath:indexPath];
    AMMarkdownFile * file = (AMMarkdownFile *)(self->_fileArray[indexPath.row]);
    cell.textLabel.text = file.title;
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [NSManagedObjectContext.MR_defaultContext deleteObject:self->_fileArray[indexPath.row]];
        [NSManagedObjectContext.MR_defaultContext MR_saveToPersistentStoreAndWait];
        [self->_fileArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditFileSegue"]) {
        AMEdittingContentController * destinationViewController = (AMEdittingContentController *)segue.destinationViewController;
        [destinationViewController loadFile:self->_fileArray[self.tableView.indexPathForSelectedRow.row]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self->_fileArray = [[AMMarkdownFile MR_findAll] mutableCopy];
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

@end
