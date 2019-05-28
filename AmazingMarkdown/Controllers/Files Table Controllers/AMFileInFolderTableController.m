//
//  AMFileInFolderTableController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMFileInFolderTableController.h"
#import "AmazingMarkdown-Swift.h"
#import <MagicalRecord/MagicalRecord.h>
#import "AMMarkdownFile+CoreDataClass.h"
#import "AMCollationSettingTableController.h"
#import "AMMarkdownFileTableCell.h"
#import "AMDateParser.h"
#import "AMTheme.h"
#import "AMThemeSettingTableController.h"
#import "AMCreateFolderController.h"


@interface AMFileInFolderTableController ()

@end

@implementation AMFileInFolderTableController {
    NSMutableArray<AMMarkdownFile *> * _fileArray;
    AMMarkdownFolder * _folder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置tableView, 空白处无分隔线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
    
    // 注册3D Touch Preview
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    // 注册DZNE
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}


- (void)viewWillAppear:(BOOL)animated {
    // 配置_folderName
    self.title = self->_folder.name;
    
    NSString * collationKey = AMCollationSettingTableController.collationKeys[[NSUserDefaults.standardUserDefaults integerForKey:AMCollationSettingCollationKeyIndexUserDefaultsKey]];
    BOOL isAscendingOrder = [NSUserDefaults.standardUserDefaults boolForKey:AMCollationSettingIsAscendingOrderUserDefaultsKey];
    self->_fileArray = [AMMarkdownFile MR_findAllSortedBy:collationKey ascending:isAscendingOrder withPredicate:[NSPredicate predicateWithFormat:@"folder == %@", self->_folder.name]].mutableCopy;
    
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"transparentMarkdownFolder"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString * title = NSLocalizedString(@"empty folder", nil);
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f], NSForegroundColorAttributeName:AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]].backgroundNoticeColor};
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -70.0f;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->_fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMMarkdownFileTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FileTableCell" forIndexPath:indexPath];
    AMMarkdownFile * file = self->_fileArray[indexPath.row];
    cell.titleLabel.text = file.title;
    cell.summaryLabel.text = file.summary;
    cell.dateLabel.text = [AMDateParser dateStringForFileTableCellWithDate:file.creationDate];
    cell.typeLabel.text = @"MD";
    [cell setTheme:AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]]];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [NSManagedObjectContext.MR_defaultContext deleteObject:self->_fileArray[indexPath.row]];
        [self->_fileArray removeObjectAtIndex:indexPath.row];
        [NSManagedObjectContext.MR_defaultContext MR_saveToPersistentStoreAndWait];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadEmptyDataSet];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0f;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPreviewSegue"]) {
        AMPreviewController * destinationViewController = (AMPreviewController *)segue.destinationViewController;
        [destinationViewController loadWithMarkdownFile:self->_fileArray[self.tableView.indexPathForSelectedRow.row]];
        return;
    }
    if ([segue.identifier isEqualToString:@"ModifyFolderSegue"]) {
        AMCreateFolderController * destinationViewController = (AMCreateFolderController *)segue.destinationViewController;
        [destinationViewController loadMarkdownFolder:self->_folder];
        return;
    }
}

#pragma mark -  previewing Delegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    CGPoint point = [self.tableView convertPoint:location fromView:self.view];
    if (CGRectContainsPoint(self.tableView.bounds, point)) {
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (!indexPath) {
            return nil;
        }
        AMPreviewController * previewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AMPreviewController"];
        [previewController loadWithMarkdownFile:self->_fileArray[indexPath.row]];
        return previewController;
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (void)loadFolder:(AMMarkdownFolder *)folder {
    self->_folder = folder;
}

@end
