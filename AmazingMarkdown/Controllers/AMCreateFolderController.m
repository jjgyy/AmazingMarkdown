//
//  AMCreateFolderController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/26.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMCreateFolderController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "AMMarkdownFile+CoreDataClass.h"
#import "AMMarkdownFileTableCell.h"
#import "AMTheme.h"
#import "AMThemeSettingTableController.h"

NS_ENUM(NSInteger, AMCreateFolderControllerActionType) {
    AMCreateFolderControllerActionTypeCreation,
    AMCreateFolderControllerActionTypeModification
};

@interface AMCreateFolderController ()

@property (weak, nonatomic) IBOutlet UIView * folderNameView;
@property (weak, nonatomic) IBOutlet UITextField * folderNameTextField;
@property (weak, nonatomic) IBOutlet UITableView * includedFilesTableView;

@property (nonatomic, assign) enum AMCreateFolderControllerActionType actionType;

- (IBAction)clickDoneButton:(id)sender;

@end

@implementation AMCreateFolderController {
    NSArray<AMMarkdownFile *> * _nonFoldedFileArray;
    NSArray<AMMarkdownFile *> * _foldedFileArray;
    AMTheme * _theme;
    NSMutableSet<AMMarkdownFile *> * _selectedFileSet;
    AMMarkdownFolder * _modifiedFolder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self->_includedFilesTableView.delegate = self;
    self->_includedFilesTableView.dataSource = self;
    self->_nonFoldedFileArray = [AMMarkdownFile MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"folder == %@", nil]];
    self->_theme = AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]];
    
    if (self->_actionType == AMCreateFolderControllerActionTypeCreation) {
        self->_foldedFileArray = [NSArray new];
        self->_selectedFileSet = [NSMutableSet new];
        self->_folderNameTextField.text = @"";
    }
    else if (self->_actionType == AMCreateFolderControllerActionTypeModification) {
        self->_folderNameTextField.text = self->_modifiedFolder.name;
        self->_foldedFileArray = [AMMarkdownFile MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"folder == %@", self->_modifiedFolder.name]];
        self->_selectedFileSet = [NSMutableSet setWithArray:self->_foldedFileArray];
    }
    
    self->_folderNameTextField.returnKeyType = UIReturnKeyNext;
    self->_folderNameTextField.delegate = self;
    
    // 配置tableView, 空白处无分隔线
    self->_includedFilesTableView.tableFooterView = [UIView new];
    
    self->_includedFilesTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self->_folderNameTextField resignFirstResponder];
    return YES;
}

- (void)setTheme:(AMTheme *)theme {
    [super setTheme:theme];
    self->_folderNameView.backgroundColor = theme.cellColor;
    NSAttributedString * attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"folder name", nil) attributes:@{NSForegroundColorAttributeName:theme.placeholderColor}];
    self->_folderNameTextField.attributedPlaceholder = attributedPlaceholder;
    self->_folderNameTextField.font = [UIFont systemFontOfSize:16.0f];
    self->_folderNameTextField.textColor = theme.textColor;
    self->_includedFilesTableView.backgroundColor = theme.backgroundColor;
}

- (IBAction)clickDoneButton:(id)sender {
    if ([self->_folderNameTextField.text isEqualToString:@""]) {
        return;
    }
    
    if (self->_actionType == AMCreateFolderControllerActionTypeCreation) {
        AMMarkdownFolder * newMarkdownFolder = [AMMarkdownFolder MR_createEntity];
        newMarkdownFolder.name = self->_folderNameTextField.text;
        newMarkdownFolder.creationDate = [NSDate new];
        newMarkdownFolder.modifiedDate = newMarkdownFolder.creationDate;
        newMarkdownFolder.fileNumber = self->_selectedFileSet.count;
        [self->_selectedFileSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            ((AMMarkdownFile *)obj).folder = self->_folderNameTextField.text;
        }];
    }
    else if (self->_actionType == AMCreateFolderControllerActionTypeModification) {
        NSMutableSet * foldedFileSet = [NSMutableSet setWithArray:self->_foldedFileArray];
        
        [foldedFileSet minusSet:self->_selectedFileSet];
        [foldedFileSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            ((AMMarkdownFile *)obj).folder = nil;
        }];
        
        [self->_selectedFileSet enumerateObjectsUsingBlock:^(AMMarkdownFile * _Nonnull obj, BOOL * _Nonnull stop) {
            ((AMMarkdownFile *)obj).folder = self->_folderNameTextField.text;
        }];
        
        self->_modifiedFolder.name = self->_folderNameTextField.text;
    }
    
    [NSManagedObjectContext.MR_defaultContext MR_saveToPersistentStoreAndWait];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->_foldedFileArray.count + self->_nonFoldedFileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AMMarkdownFileTableCell * cell = [self->_includedFilesTableView dequeueReusableCellWithIdentifier:@"FileTableCell"];
    
    if (indexPath.row < self->_foldedFileArray.count) {
        AMMarkdownFile * file = self->_foldedFileArray[indexPath.row];
        cell.titleLabel.text = file.title;
        cell.summaryLabel.text = file.summary;
    }
    else {
        AMMarkdownFile * file = self->_nonFoldedFileArray[indexPath.row - self->_foldedFileArray.count];
        cell.titleLabel.text = file.title;
        cell.summaryLabel.text = file.summary;
    }
    [cell setTheme:self->_theme];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (indexPath.row < self->_foldedFileArray.count) {
            if ([self->_selectedFileSet containsObject:self->_foldedFileArray[indexPath.row]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                });
            }
        } else {
            if ([self->_selectedFileSet containsObject:self->_nonFoldedFileArray[indexPath.row - self->_foldedFileArray.count]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                });
            }
        }
    });
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self->_includedFilesTableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if (indexPath.row < self->_foldedFileArray.count) {
            [self->_selectedFileSet addObject:self->_foldedFileArray[indexPath.row]];
        } else {
            [self->_selectedFileSet addObject:self->_nonFoldedFileArray[indexPath.row - self->_foldedFileArray.count]];
        }
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row < self->_foldedFileArray.count) {
            [self->_selectedFileSet removeObject:self->_foldedFileArray[indexPath.row]];
        } else {
            [self->_selectedFileSet removeObject:self->_nonFoldedFileArray[indexPath.row - self->_foldedFileArray.count]];
        }
    }
    [self->_includedFilesTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)loadMarkdownFolder:(AMMarkdownFolder *)markdownFolder {
    self->_actionType = AMCreateFolderControllerActionTypeModification;
    self->_modifiedFolder = markdownFolder;
}

@end
