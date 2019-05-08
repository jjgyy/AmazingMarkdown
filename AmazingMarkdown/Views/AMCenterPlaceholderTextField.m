//
//  AMCenterPlaceholderTextField.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/6.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMCenterPlaceholderTextField.h"

static const CGFloat kDefaultFontSize = 18.0f;

@implementation AMCenterPlaceholderTextField

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder {
    if (self = [super initWithFrame:frame]) {
        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        NSAttributedString * attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSParagraphStyleAttributeName:style}];
        self.attributedPlaceholder = attributedPlaceholder;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont boldSystemFontOfSize:kDefaultFontSize];
    }
    return self;
}

@end
