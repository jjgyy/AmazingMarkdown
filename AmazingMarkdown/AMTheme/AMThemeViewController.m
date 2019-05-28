//
//  AMThemeViewController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/26.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMThemeViewController.h"
#import "AMThemeSettingTableController.h"

@interface AMThemeViewController ()

@end

@implementation AMThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTheme:AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]]];
}

- (void)setTheme:(AMTheme *)theme {
    self.view.backgroundColor = theme.backgroundColor;
}

@end
