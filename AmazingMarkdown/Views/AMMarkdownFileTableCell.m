//
//  AMMarkdownFileTableCell.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/8.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMMarkdownFileTableCell.h"

@interface AMMarkdownFileTableCell()


@end

@implementation AMMarkdownFileTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTheme:(DYTheme *)theme {
    self.backgroundColor = theme.cellColor;
    self.titleLabel.textColor = theme.cellTitleColor;
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = theme.cellSelectedColor;
}

@end
