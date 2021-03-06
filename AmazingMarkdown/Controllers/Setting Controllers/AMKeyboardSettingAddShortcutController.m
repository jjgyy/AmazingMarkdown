//
//  AMKeyboardSettingAddShortcutController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/11.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMKeyboardSettingAddShortcutController.h"
#import "AMKeyboardToolbarFactory.h"
#import "AMThemeSettingTableController.h"

@interface AMKeyboardSettingAddShortcutController ()

@property (weak, nonatomic) IBOutlet UITextField *shortcutContentTextField;

- (IBAction)clickDoneButtonHandler:(id)sender;

@end

@implementation AMKeyboardSettingAddShortcutController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)clickDoneButtonHandler:(id)sender {
    if (![self->_shortcutContentTextField.text isEqualToString:@""]) {
        NSArray<NSString *> * shortcutStrings = [[NSUserDefaults.standardUserDefaults objectForKey:AMKeyboardSettingShortcutStringsUserDefaultsKey] arrayByAddingObject:self->_shortcutContentTextField.text];
        [NSUserDefaults.standardUserDefaults setObject:shortcutStrings forKey:AMKeyboardSettingShortcutStringsUserDefaultsKey];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTheme:(AMTheme *)theme {
    [super setTheme:theme];
    NSAttributedString * attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"enter shortcut content", nil) attributes:@{NSForegroundColorAttributeName:theme.placeholderColor}];
    self->_shortcutContentTextField.attributedPlaceholder = attributedPlaceholder;
    self->_shortcutContentTextField.font = [UIFont systemFontOfSize:16.0f];
    self->_shortcutContentTextField.text = @"";
    self->_shortcutContentTextField.textColor = theme.textColor;
}

@end
