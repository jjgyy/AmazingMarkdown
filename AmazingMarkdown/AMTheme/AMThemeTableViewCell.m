//
//  AMThemeTableViewCell.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/20.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMThemeTableViewCell.h"
#import "AMThemeSettingTableController.h"

@implementation AMThemeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setTheme:AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]]];
}

- (void)setTheme:(AMTheme *)theme {
    self.backgroundColor = theme.cellColor;
    self.textLabel.textColor = theme.cellTitleColor;
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = theme.cellSelectedColor;
}

@end
