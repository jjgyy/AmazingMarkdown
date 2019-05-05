//
//  DYMarkdownParser.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/28.
//  Copyright © 2019 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DYTextParser <NSObject>

@required
- (BOOL)parseText:(nullable NSMutableAttributedString *)text selectedRange:(nullable NSRangePointer)selectedRange;

@end


@interface DYMarkdownParser : NSObject<DYTextParser>

typedef NS_ENUM(NSUInteger, DYMarkdownTheme) {
    DYMarkdownThemeDefault,
    DYMarkdownThemeDark
};

@property (class, nonatomic, readonly) DYMarkdownParser * sharedParser;

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) DYMarkdownTheme theme;

@property (nullable, nonatomic, strong) UIColor *textColor;
@property (nullable, nonatomic, strong) UIColor *controlTextColor;
@property (nullable, nonatomic, strong) UIColor *headerTextColor;
@property (nullable, nonatomic, strong) UIColor *inlineTextColor;
@property (nullable, nonatomic, strong) UIColor *codeTextColor;
@property (nullable, nonatomic, strong) UIColor *linkTextColor;

@end

NS_ASSUME_NONNULL_END
