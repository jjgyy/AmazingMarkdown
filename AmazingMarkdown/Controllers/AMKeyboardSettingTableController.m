//
//  AMKeyboardSettingTableController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/11.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMKeyboardSettingTableController.h"
#import "AMKeyboardToolbarFactory.h"

@interface AMKeyboardSettingTableController ()

@end

@implementation AMKeyboardSettingTableController {
    UIBarButtonItem * _editButton;
    UIBarButtonItem * _doneButton;
    NSArray<NSString *> * _originShortcutStrings;
    NSMutableArray<NSString *> * _shortcutStrings;
    BOOL _isModified;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self->_originShortcutStrings = (NSArray<NSString *> *)[NSUserDefaults.standardUserDefaults objectForKey:AMKeyboardToolbarShortcutStringsUserDefaultsKey];
    self->_shortcutStrings = [self->_originShortcutStrings mutableCopy];
    if (!self->_shortcutStrings) {
        self->_shortcutStrings = [AMKeyboardToolbarFactory.defaultMarkdownShortcutStrings mutableCopy];
    }
    self->_isModified = NO;
    
    self->_editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(clickEditButtonHandler)];
    self->_doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickDoneButtonHandler)];
    
    self.navigationItem.rightBarButtonItems = @[self->_editButton];
}

- (void)viewWillAppear:(BOOL)animated {
    self->_shortcutStrings = [(NSArray<NSString *> *)[NSUserDefaults.standardUserDefaults objectForKey:AMKeyboardToolbarShortcutStringsUserDefaultsKey] mutableCopy];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.editing) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.editing) {
            return self->_shortcutStrings.count;
        }
        return self->_shortcutStrings.count + 1;
    }
    else if (section == 1) {
        if (self->_isModified) {
            return 2;
        }
        else {
            return 1;
        }
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"shortcut list", nil);
    }
    else if (section == 1) {
        return NSLocalizedString(@"other", nil);
    }
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicTableCell" forIndexPath:indexPath];
        if (indexPath.row == self->_shortcutStrings.count) {
            cell.textLabel.text = NSLocalizedString(@"add shortcut", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        cell.textLabel.text = self->_shortcutStrings[indexPath.row];
        return cell;
    }
    else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicTableCell" forIndexPath:indexPath];
        if (self->_isModified) {
            if (indexPath.row == 0) {
                cell.textLabel.text = NSLocalizedString(@"restore", nil);
            }
            else if (indexPath.row == 1) {
                cell.textLabel.text = NSLocalizedString(@"restore defaults", nil);
            }
        }
        else {
            if (indexPath.row == 0) {
                cell.textLabel.text = NSLocalizedString(@"restore defaults", nil);
            }
        }
        return cell;
    }
    return [tableView dequeueReusableCellWithIdentifier:@"BasicTableCell" forIndexPath:indexPath];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row < self->_shortcutStrings.count) {
        return YES;
    }
    return NO;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self->_shortcutStrings removeObjectAtIndex:indexPath.row];
        [NSUserDefaults.standardUserDefaults setObject:(NSArray *)self->_shortcutStrings forKey:AMKeyboardToolbarShortcutStringsUserDefaultsKey];
        self->_isModified = YES;
        [self.tableView reloadData];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == self->_shortcutStrings.count) {
            [self performSegueWithIdentifier:@"AddShortcutSegue" sender:nil];
        }
    }
    else if (indexPath.section == 1) {
        if (self->_isModified) {
            if (indexPath.row == 0) {
                self->_shortcutStrings = [self->_originShortcutStrings mutableCopy];
                [NSUserDefaults.standardUserDefaults setObject:(NSArray *)self->_shortcutStrings forKey:AMKeyboardToolbarShortcutStringsUserDefaultsKey];
                self->_isModified = NO;
                [self.tableView reloadData];
            }
            else if (indexPath.row == 1) {
                self->_shortcutStrings = [AMKeyboardToolbarFactory.defaultMarkdownShortcutStrings mutableCopy];
                [NSUserDefaults.standardUserDefaults setObject:(NSArray *)self->_shortcutStrings forKey:AMKeyboardToolbarShortcutStringsUserDefaultsKey];
                self->_isModified = YES;
                [self.tableView reloadData];
            }
        }
        else {
            if (indexPath.row == 0) {
                self->_shortcutStrings = [AMKeyboardToolbarFactory.defaultMarkdownShortcutStrings mutableCopy];
                [NSUserDefaults.standardUserDefaults setObject:(NSArray *)self->_shortcutStrings forKey:AMKeyboardToolbarShortcutStringsUserDefaultsKey];
                self->_isModified = YES;
                [self.tableView reloadData];
            }
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)
sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSUInteger fromRow = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];
    NSString * shortcutString = self->_shortcutStrings[fromRow];
    [self->_shortcutStrings removeObjectAtIndex:fromRow];
    [self->_shortcutStrings insertObject:shortcutString atIndex:toRow];
    [NSUserDefaults.standardUserDefaults setObject:(NSArray *)self->_shortcutStrings forKey:AMKeyboardToolbarShortcutStringsUserDefaultsKey];
    self->_isModified = YES;
}


- (void)clickEditButtonHandler {
    self.navigationItem.rightBarButtonItems = @[self->_doneButton];
    [self setEditing:NO animated:NO];
    [self setEditing:YES animated:YES];
    [self.tableView reloadData];
}

- (void)clickDoneButtonHandler {
    self.navigationItem.rightBarButtonItems = @[self->_editButton];
    [self setEditing:NO animated:YES];
    [self.tableView reloadData];
}

@end
