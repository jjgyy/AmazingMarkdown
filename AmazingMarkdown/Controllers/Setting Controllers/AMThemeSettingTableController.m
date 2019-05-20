//
//  AMThemeSettingTableController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/9.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMThemeSettingTableController.h"

NSString * const AMThemeIndexUserDefaultsKey = @"AMThemeIndexUserDefaultsKey";
NSString * const AMThemeDidChangeNotification = @"AMThemeDidChangeNotification";

@interface AMThemeSettingTableController ()

@end

@implementation AMThemeSettingTableController {
    NSInteger _checkmarkedRow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self->_checkmarkedRow = [NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey];
    if (self->_checkmarkedRow < 0 || self->_checkmarkedRow >= AMTheme.themes.count) {
        self->_checkmarkedRow = 0;
        [NSUserDefaults.standardUserDefaults setInteger:0 forKey:AMThemeIndexUserDefaultsKey];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return AMTheme.themes.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"theme setting", nil);
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BasicTableCell"];
    cell.textLabel.text = AMTheme.themes[indexPath.row].themeName;
    if (indexPath.row == self->_checkmarkedRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self->_checkmarkedRow) {
        [NSUserDefaults.standardUserDefaults setInteger:indexPath.row forKey:AMThemeIndexUserDefaultsKey];
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self->_checkmarkedRow inSection:0]].accessoryType = UITableViewCellAccessoryNone;
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        self->_checkmarkedRow = indexPath.row;
        [NSNotificationCenter.defaultCenter postNotificationName:AMThemeDidChangeNotification object:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
