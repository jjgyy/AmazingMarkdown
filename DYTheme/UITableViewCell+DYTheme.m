//
//  UITableViewCell+DYTheme.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/10.
//  Copyright © 2019 Young. All rights reserved.
//

#import "UITableViewCell+DYTheme.h"
#import "DYTheme.h"

@implementation UITableViewCell (DYTheme)

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setTheme:DYTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:DYThemeIndexUserDefaultsKey]]];
}

- (void)setTheme:(DYTheme *)theme {
    [super setTheme:theme];
    self.backgroundColor = theme.cellColor;
    self.textLabel.textColor = theme.cellTitleColor;
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = theme.cellSelectedColor;
}

@end
