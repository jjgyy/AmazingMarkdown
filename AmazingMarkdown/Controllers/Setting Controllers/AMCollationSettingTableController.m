//
//  AMCollationSettingTableController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/13.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMCollationSettingTableController.h"

NSString * const AMCollationSettingCollationKeyIndexUserDefaultsKey = @"AMCollationSettingCollationKeyUserDefaultsKey";
NSString * const AMCollationSettingIsAscendingOrderUserDefaultsKey = @"AMCollationSettingIsAscendingOrderUserDefaultsKey";

NSString * const AMCollationSettingDidChangeNotificationName = @"AMCollationSettingDidChangeNotificationName";


@interface AMCollationSettingTableController ()

@end

@implementation AMCollationSettingTableController {
    NSInteger _collationKeyIndex;
    BOOL _isAscendingOrder;
}

+ (NSArray<NSString *> *)collationKeys {
    return @[@"creationDate", @"modifiedDate", @"title"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self->_collationKeyIndex = [NSUserDefaults.standardUserDefaults integerForKey:AMCollationSettingCollationKeyIndexUserDefaultsKey];
    self->_isAscendingOrder = [NSUserDefaults.standardUserDefaults boolForKey:AMCollationSettingIsAscendingOrderUserDefaultsKey];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    else if (section == 1) {
        return 2;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"according to", nil);
    }
    else if (section == 1) {
        return NSLocalizedString(@"with order", nil);
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"BasicTableCell"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"creation time", nil);
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"modification time", nil);
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"file name", nil);
        }
        
        if (self->_collationKeyIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"descending order", nil);
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"ascending order", nil);
        }
        
        if ((NSInteger)self->_isAscendingOrder == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self->_collationKeyIndex == indexPath.row) {
            return;
        }
        [NSUserDefaults.standardUserDefaults setInteger:indexPath.row forKey:AMCollationSettingCollationKeyIndexUserDefaultsKey];
        [NSNotificationCenter.defaultCenter postNotificationName:AMCollationSettingDidChangeNotificationName object:nil];
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self->_collationKeyIndex inSection:0]].accessoryType = UITableViewCellAccessoryNone;
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        self->_collationKeyIndex = indexPath.row;
    }
    else if (indexPath.section == 1) {
        if ((NSInteger)self->_isAscendingOrder == indexPath.row) {
            return;
        }
        [NSUserDefaults.standardUserDefaults setBool:(BOOL)indexPath.row forKey:AMCollationSettingIsAscendingOrderUserDefaultsKey];
        [NSNotificationCenter.defaultCenter postNotificationName:AMCollationSettingDidChangeNotificationName object:nil];
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(NSInteger)self->_isAscendingOrder inSection:1]].accessoryType = UITableViewCellAccessoryNone;
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        self->_isAscendingOrder = (BOOL)indexPath.row;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
