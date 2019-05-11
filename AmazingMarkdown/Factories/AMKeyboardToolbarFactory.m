//
//  AMKeyboardToolbarFactory.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMKeyboardToolbarFactory.h"
#import "DYKeyboardToolbar.h"

NSString * const AMKeyboardToolbarShortcutStringsUserDefaultsKey = @"AMKeyboardToolbarHelpingStringsUserDefaultsKey";

@implementation AMKeyboardToolbarFactory

+ (NSArray<NSString *> *)defaultMarkdownShortcutStrings {
    NSArray<NSString *> * shortcutStrings = @[@"#", @"*", @"-", @"_", @"~", @"`", @">", @"|", @"[", @"]", @"(", @")"];
    [NSUserDefaults.standardUserDefaults setObject:shortcutStrings forKey:AMKeyboardToolbarShortcutStringsUserDefaultsKey];
    return shortcutStrings;
}

+ (void)addMarkdownInputToolbarFor:(UITextView *)textView withShortcutStrings:(NSArray<NSString *> * _Nullable)shortcutStrings {
    if (!shortcutStrings) {
        shortcutStrings = AMKeyboardToolbarFactory.defaultMarkdownShortcutStrings;
    }
    NSMutableArray<DYKeyboardToolbarButton *> * buttons = [NSMutableArray new];
    for (NSString * helpingString in shortcutStrings) {
        DYKeyboardToolbarButton * button = [DYKeyboardToolbarButton buttonWithTitle:helpingString eventHandler:^{
            [textView insertText:helpingString];
        }];
        [buttons addObject:button];
    }
    textView.inputAccessoryView = [DYKeyboardToolbar toolbarWithButtons:buttons];
}

@end
