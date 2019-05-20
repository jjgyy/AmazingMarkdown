//
//  AMThemeTableViewController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/20.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMThemeTableViewController.h"
#import "AMThemeSettingTableController.h"

@interface AMThemeTableViewController ()

@end

@implementation AMThemeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTheme:AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]]];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    ((UITableViewHeaderFooterView *)view).textLabel.textColor = AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]].sectionTitleColor;
}

- (void)setTheme:(AMTheme *)theme {
    self.tableView.backgroundColor = theme.backgroundColor;
    self.tableView.separatorColor = theme.separatorColor;
}

@end
