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

- (void)setTheme:(AMTheme *)theme {
    self.backgroundColor = theme.cellColor;
    self->_summaryLabel.text = [self->_summaryLabel.text isEqualToString:@""] ? NSLocalizedString(@"no summary", nil) : self->_summaryLabel.text;
    if ([self.titleLabel.text isEqualToString:@""]) {
        self->_titleLabel.textColor = theme.cellTitleSpecialColor;
        self->_titleLabel.text = NSLocalizedString(@"untitled", nil);
    }
    else {
        self->_titleLabel.textColor = theme.cellTitleColor;
    }
    self->_typeLabel.textColor = UIColor.flatSkyBlueColor;
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = theme.cellSelectedColor;
}

@end
