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
    if ([self.titleLabel.text isEqualToString:@""]) {
        self.titleLabel.textColor = theme.cellTitleSpecialColor;
        self.titleLabel.text = NSLocalizedString(@"untitled", nil);
    }
    else {
        self.titleLabel.textColor = theme.cellTitleColor;
    }
    self.typeLabel.textColor = UIColor.flatRedColorDark;
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = theme.cellSelectedColor;
}

@end
