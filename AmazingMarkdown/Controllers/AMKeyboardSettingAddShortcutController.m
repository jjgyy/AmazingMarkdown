//
//  AMKeyboardSettingAddShortcutController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/11.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMKeyboardSettingAddShortcutController.h"
#import "AMKeyboardToolbarFactory.h"
#import "DYTheme.h"

@interface AMKeyboardSettingAddShortcutController ()

@property (weak, nonatomic) IBOutlet UIView *shortcutContentTableCellView;

- (IBAction)clickDoneButtonHandler:(id)sender;

@end

@implementation AMKeyboardSettingAddShortcutController {
    UITextField * _shortcutContentTextField;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = self->_shortcutContentTableCellView.bounds;
    rect.origin.x = 20.0f;
    self->_shortcutContentTextField = [[UITextField alloc] initWithFrame:rect];
    NSAttributedString * attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"enter shortcut content", nil) attributes:@{NSForegroundColorAttributeName:DYTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:DYThemeIndexUserDefaultsKey]].placeholderColor}];
    self->_shortcutContentTextField.attributedPlaceholder = attributedPlaceholder;
    self->_shortcutContentTextField.font = [UIFont systemFontOfSize:16.0f];
    [self.shortcutContentTableCellView addSubview:self->_shortcutContentTextField];
    self->_shortcutContentTextField.text = @"";
    self->_shortcutContentTextField.textColor = DYTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:DYThemeIndexUserDefaultsKey]].textColor;
}

- (IBAction)clickDoneButtonHandler:(id)sender {
    if (![self->_shortcutContentTextField.text isEqualToString:@""]) {
        NSArray<NSString *> * shortcutStrings = [[NSUserDefaults.standardUserDefaults objectForKey:AMKeyboardToolbarShortcutStringsUserDefaultsKey] arrayByAddingObject:self->_shortcutContentTextField.text];
        [NSUserDefaults.standardUserDefaults setObject:shortcutStrings forKey:AMKeyboardToolbarShortcutStringsUserDefaultsKey];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
