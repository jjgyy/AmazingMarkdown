//
//  AMKeyboardToolbarFactory.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const AMKeyboardSettingShortcutStringsUserDefaultsKey;

@interface AMKeyboardToolbarFactory : NSObject

@property (class, nonatomic, readonly) NSArray<NSString *> * defaultMarkdownShortcutStrings;

+ (void)addMarkdownInputToolbarFor:(UITextView *)textView withShortcutStrings: (NSArray<NSString *> * _Nullable) shortcutStrings;

@end

NS_ASSUME_NONNULL_END
