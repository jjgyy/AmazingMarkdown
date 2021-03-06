//
//  AMMarkdownFileTableCell.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/8.
//  Copyright © 2019 Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMMarkdownFileTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

- (void)setTheme:(AMTheme *)theme;

@end

NS_ASSUME_NONNULL_END
