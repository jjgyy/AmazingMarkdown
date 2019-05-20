//
//  AMCenterPlaceholderTextField.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/6.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMNavigationTitleTextField.h"
#import "AMTheme.h"
#import "AMThemeSettingTableController.h"

@implementation AMNavigationTitleTextField

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder fontSize:(CGFloat)fontSize {
    if (self = [super initWithFrame:frame]) {
        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        NSAttributedString * attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]].placeholderColor}];
        self.attributedPlaceholder = attributedPlaceholder;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont boldSystemFontOfSize:fontSize];
    }
    return self;
}

@end
