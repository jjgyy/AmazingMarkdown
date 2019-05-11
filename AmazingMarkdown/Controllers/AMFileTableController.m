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
#import "DYTheme.h"

@interface AMFileTableController ()

@property(nonatomic, strong) NSMutableArray<AMMarkdownFile *> * fileArray;

@end

@implementation AMFileTableController {
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
    
    // 观察Theme设置改变
    [NSNotificationCenter.defaultCenter addObserverForName:DYThemeDidChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [self setTheme:DYTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:DYThemeIndexUserDefaultsKey]]];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self->_fileArray = [[AMMarkdownFile MR_findAllSortedBy:@"creationDate" ascending:NO] mutableCopy];
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
    cell.titleLabel.text = [file.title isEqualToString:@""] ? NSLocalizedString(@"untitled", nil) : file.title;
    cell.titleLabel.textColor = [file.title isEqualToString:@""] ? UIColor.flatBlueColor : UIColor.blackColor;
    cell.outlineLabel.text = [file.summary isEqualToString:@""] ? NSLocalizedString(@"no summary", nil) : file.summary;
    cell.dateLabel.text = [self dateStringFromDate:file.creationDate];
    [cell setTheme:DYTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:DYThemeIndexUserDefaultsKey]]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0f;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPreviewSegue"]) {
        AMPreviewController * destinationViewController = (AMPreviewController *)segue.destinationViewController;
        [destinationViewController loadFileWithMarkdownFile:self->_fileArray[self.tableView.indexPathForSelectedRow.row]];
    }
    else if ([segue.identifier isEqualToString:@"CreateFileSegue"]) {
        AMMarkdownFile * newMarkdownFile = [AMMarkdownFile MR_createEntity];
        newMarkdownFile.creationDate = [NSDate new];
        newMarkdownFile.modifiedDate = newMarkdownFile.creationDate;
        AMEdittingContentController * destinationViewController = (AMEdittingContentController *)segue.destinationViewController;
        [destinationViewController loadFile:newMarkdownFile];
    }
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

@end
