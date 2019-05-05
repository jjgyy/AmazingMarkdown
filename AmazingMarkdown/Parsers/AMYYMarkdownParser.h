//
//  AMYYMarkdownParser.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/28.
//  Copyright © 2019 Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYText/YYText.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMYYMarkdownParser : NSObject <YYTextParser>

typedef NS_ENUM(NSUInteger, DYMarkdownTheme) {
    DYMarkdownThemeDefault,
    DYMarkdownThemeDark
};

@property (nonatomic, assign) DYMarkdownTheme theme;

@property (nonatomic) CGFloat fontSize;         ///< default is 14
@property (nonatomic) CGFloat headerFontSize;   ///< default is 20

@property (nullable, nonatomic, strong) UIColor *textColor;
@property (nullable, nonatomic, strong) UIColor *controlTextColor;
@property (nullable, nonatomic, strong) UIColor *headerTextColor;
@property (nullable, nonatomic, strong) UIColor *inlineTextColor;
@property (nullable, nonatomic, strong) UIColor *codeTextColor;
@property (nullable, nonatomic, strong) UIColor *linkTextColor;

@end

NS_ASSUME_NONNULL_END
