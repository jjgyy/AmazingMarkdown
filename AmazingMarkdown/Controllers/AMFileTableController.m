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
#import "AMMarkdownFileTableCell.h"
#import "Chameleon.h"
#import "AMThemeSettingTableController.h"
#import "AMCollationSettingTableController.h"

@interface AMFileTableController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem * addButton;

- (IBAction)clickAddButton:(id)sender;

@end

@implementation AMFileTableController {
    NSMutableArray<AMMarkdownFile *> * _fileArray;
    NSDateFormatter * _yearMonthDayFormatter;
    NSDateFormatter * _todayFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置_yearMonthDayFormatter
    self->_yearMonthDayFormatter = [NSDateFormatter new];
    [self->_yearMonthDayFormatter setDateFormat:@"yyyy/M/d"];
    // 配置_todayFormatter
    self->_todayFormatter = [NSDateFormatter new];
    [self->_todayFormatter setDateFormat:@"H:mm"];
    
    // 配置tableView, 空白处无分隔线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
    
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
    self->_fileArray = [[AMMarkdownFile MR_findAllSortedBy:collationKey ascending:isAscendingOrder] mutableCopy];
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->_fileArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMMarkdownFileTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileTableCell" forIndexPath:indexPath];
    AMMarkdownFile * file = (AMMarkdownFile *)(self->_fileArray[indexPath.row]);
    cell.titleLabel.text = file.title;
    cell.summaryLabel.text = [file.summary isEqualToString:@""] ? NSLocalizedString(@"no summary", nil) : file.summary;
    cell.dateLabel.text = [self dateStringFromDate:file.creationDate];
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
        [NSManagedObjectContext.MR_defaultContext MR_saveToPersistentStoreAndWait];
        [self->_fileArray removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0f;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPreviewSegue"]) {
        AMPreviewController * destinationViewController = (AMPreviewController *)segue.destinationViewController;
        [destinationViewController loadFileWithMarkdownFile:self->_fileArray[self.tableView.indexPathForSelectedRow.row]];
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
        [previewController loadFileWithMarkdownFile:self->_fileArray[indexPath.row]];
        return previewController;
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (NSString *)dateStringFromDate:(NSDate *)date {
    NSString * today = [self->_yearMonthDayFormatter stringFromDate:[NSDate new]];
    NSString * oneday = [self->_yearMonthDayFormatter stringFromDate:date];
    if ([today isEqualToString:oneday]) {
        return [self->_todayFormatter stringFromDate:date];
    } else {
        return oneday;
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (IBAction)clickAddButton:(id)sender {
    UIViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AMNewFileMenuTableController"];
    controller.preferredContentSize = CGSizeMake(160, (10 + 2*38 + 10));
    controller.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController * popoverPresentationController = [controller popoverPresentationController];
    popoverPresentationController.delegate = self;
    popoverPresentationController.barButtonItem = self.addButton;
    
    [self presentViewController:controller animated:YES completion:nil];
}

@end
