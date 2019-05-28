//
//  AMFileTableController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/5.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMFileTableController.h"
#import "AmazingMarkdown-Swift.h"
#import "AMEdittingContentController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "AMMarkdownFile+CoreDataClass.h"
#import "AMMarkdownFolder+CoreDataClass.h"
#import "AMMarkdownFileTableCell.h"
#import "Chameleon.h"
#import "AMThemeSettingTableController.h"
#import "AMCollationSettingTableController.h"
#import "AMDateParser.h"
#import "AMFileInFolderTableController.h"

@interface AMFileTableController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem * addButton;

- (IBAction)clickAddButton:(id)sender;

@end

@implementation AMFileTableController {
    NSMutableArray<AMMarkdownFolder *> * _folderArray;
    NSMutableArray<AMMarkdownFile *> * _fileArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置tableView, 空白处无分隔线
    self.tableView.tableFooterView = [UIView new];
    
    // 注册3D Touch Preview
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    // 观察Theme设置改变
    [NSNotificationCenter.defaultCenter addObserverForName:AMThemeDidChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [self setTheme:AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]]];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString * collationKey = AMCollationSettingTableController.collationKeys[[NSUserDefaults.standardUserDefaults integerForKey:AMCollationSettingCollationKeyIndexUserDefaultsKey]];
    BOOL isAscendingOrder = [NSUserDefaults.standardUserDefaults boolForKey:AMCollationSettingIsAscendingOrderUserDefaultsKey];
    
    self->_folderArray = [AMMarkdownFolder MR_findAllSortedBy:collationKey ascending:isAscendingOrder].mutableCopy;
    self->_fileArray = [AMMarkdownFile MR_findAllSortedBy:collationKey ascending:isAscendingOrder withPredicate:[NSPredicate predicateWithFormat:@"folder == %@", nil]].mutableCopy;
    
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self->_folderArray.count + self->_fileArray.count);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self->_folderArray.count) {
        AMMarkdownFileTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FolderTableCell"];
        AMMarkdownFolder * folder = self->_folderArray[indexPath.row];
        cell.titleLabel.text = folder.name;
        cell.summaryLabel.text = folder.intro;
        cell.dateLabel.text = [AMDateParser dateStringForFileTableCellWithDate:folder.creationDate];
        cell.typeLabel.text = @"";
        [cell setTheme:AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]]];
        return cell;
    }
    else {
        AMMarkdownFileTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FileTableCell" forIndexPath:indexPath];
        AMMarkdownFile * file = self->_fileArray[indexPath.row - self->_folderArray.count];
        cell.titleLabel.text = file.title;
        cell.summaryLabel.text = file.summary;
        cell.dateLabel.text = [AMDateParser dateStringForFileTableCellWithDate:file.creationDate];
        cell.typeLabel.text = @"MD";
        [cell setTheme:AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]]];
        return cell;
    }
    return nil;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row < self->_folderArray.count) {
            [NSManagedObjectContext.MR_defaultContext deleteObject:self->_folderArray[indexPath.row]];
            [self->_folderArray removeObjectAtIndex:indexPath.row];
        }
        else {
            [NSManagedObjectContext.MR_defaultContext deleteObject:self->_fileArray[indexPath.row - self->_folderArray.count]];
            [self->_fileArray removeObjectAtIndex:indexPath.row - self->_folderArray.count];
        }
        [NSManagedObjectContext.MR_defaultContext MR_saveToPersistentStoreAndWait];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0f;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPreviewSegue"]) {
        AMPreviewController * destinationViewController = (AMPreviewController *)segue.destinationViewController;
        [destinationViewController loadWithMarkdownFile:self->_fileArray[self.tableView.indexPathForSelectedRow.row - self->_folderArray.count]];
        return;
    }
    if ([segue.identifier isEqualToString:@"OpenFolderSegue"]) {
        AMFileInFolderTableController * destinationViewController = (AMFileInFolderTableController *)segue.destinationViewController;
        [destinationViewController loadFolder:self->_folderArray[self.tableView.indexPathForSelectedRow.row]];
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
        if (indexPath.row < self->_folderArray.count) {
            AMFileInFolderTableController * previewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AMFileInFolderTableController"];
            [previewController loadFolder:self->_folderArray[indexPath.row]];
            return previewController;
        }
        else {
            AMPreviewController * previewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AMPreviewController"];
            [previewController loadWithMarkdownFile:self->_fileArray[indexPath.row - self->_folderArray.count]];
            return previewController;
        }
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (IBAction)clickAddButton:(id)sender {
    UIViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AMNewFileMenuTableController"];
    controller.preferredContentSize = CGSizeMake(160, (10 + 3*38 + 10));
    controller.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController * popoverPresentationController = [controller popoverPresentationController];
    popoverPresentationController.delegate = self;
    popoverPresentationController.barButtonItem = self.addButton;
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
