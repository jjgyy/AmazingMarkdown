//
//  UITableViewController+DYTheme.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/9.
//  Copyright © 2019 Young. All rights reserved.
//

#import "UITableViewController+DYTheme.h"
#import "DYTheme.h"

@implementation UITableViewController (DYTheme)

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTheme:DYTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:DYThemeIndexUserDefaultsKey]]];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    ((UITableViewHeaderFooterView *)view).textLabel.textColor = DYTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:DYThemeIndexUserDefaultsKey]].sectionTitleColor;
}

- (void)setTheme:(DYTheme *)theme {
    [super setTheme:theme];
    self.tableView.backgroundColor = theme.backgroundColor;
    self.tableView.separatorColor = theme.separatorColor;
}

@end
