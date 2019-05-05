//
//  DYMarkdownParser.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/28.
//  Copyright © 2019 Young. All rights reserved.
//

#import "DYMarkdownParser.h"

static const CGFloat kDefaultFontSize = 17.0f;

@implementation DYMarkdownParser {
    UIFont *_font;
    NSArray *_headerFonts; ///< h1~h6
    UIFont *_boldFont;
    UIFont *_italicFont;
    UIFont *_boldItalicFont;
    UIFont *_monospaceFont;
    
    NSRegularExpression *_regexEscape;          ///< escape
    NSRegularExpression *_regexHeader;          ///< #header
    NSRegularExpression *_regexH1;              ///< header\n====
    NSRegularExpression *_regexH2;              ///< header\n----
    NSRegularExpression *_regexBreakline;       ///< ******
    NSRegularExpression *_regexEmphasis;        ///< *text*  _text_
    NSRegularExpression *_regexStrong;          ///< **text**
    NSRegularExpression *_regexStrongEmphasis;  ///< ***text*** ___text___
    NSRegularExpression *_regexUnderline;       ///< __text__
    NSRegularExpression *_regexStrikethrough;   ///< ~~text~~
    NSRegularExpression *_regexInlineCode;      ///< `text`
    NSRegularExpression *_regexLink;            ///< [name](link)
    NSRegularExpression *_regexLinkRefer;       ///< [ref]:
    NSRegularExpression *_regexList;            ///< 1.text 2.text 3.text
    NSRegularExpression *_regexBlockQuote;      ///< > quote
    NSRegularExpression *_regexCodeBlock;       ///< \tcode \tcode
    NSRegularExpression *_regexNotEmptyLine;
}

static DYMarkdownParser * _sharedParser;
+ (DYMarkdownParser *)sharedParser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedParser = [[DYMarkdownParser alloc] init];
    });
    return _sharedParser;
}

- (void)initRegex {
#define regexp(reg, option) [NSRegularExpression regularExpressionWithPattern : @reg options : option error : NULL]
    _regexEscape = regexp("(\\\\\\\\|\\\\\\`|\\\\\\*|\\\\\\_|\\\\\\(|\\\\\\)|\\\\\\[|\\\\\\]|\\\\#|\\\\\\+|\\\\\\-|\\\\\\!)", 0);
    _regexHeader = regexp("^((\\#{1,6}[^#].*)|(\\#{6}.+))$", NSRegularExpressionAnchorsMatchLines);
    _regexH1 = regexp("^[^=\\n][^\\n]*\\n=+$", NSRegularExpressionAnchorsMatchLines);
    _regexH2 = regexp("^[^-\\n][^\\n]*\\n-+$", NSRegularExpressionAnchorsMatchLines);
    _regexBreakline = regexp("^[ \\t]*([*-])[ \\t]*((\\1)[ \\t]*){2,}[ \\t]*$", NSRegularExpressionAnchorsMatchLines);
    _regexEmphasis = regexp("((?<!\\*)\\*(?=[^ \\t*])(.+?)(?<=[^ \\t*])\\*(?!\\*)|(?<!_)_(?=[^ \\t_])(.+?)(?<=[^ \\t_])_(?!_))", 0);
    _regexStrong = regexp("(?<!\\*)\\*{2}(?=[^ \\t*])(.+?)(?<=[^ \\t*])\\*{2}(?!\\*)", 0);
    _regexStrongEmphasis =  regexp("((?<!\\*)\\*{3}(?=[^ \\t*])(.+?)(?<=[^ \\t*])\\*{3}(?!\\*)|(?<!_)_{3}(?=[^ \\t_])(.+?)(?<=[^ \\t_])_{3}(?!_))", 0);
    _regexUnderline = regexp("(?<!_)__(?=[^ \\t_])(.+?)(?<=[^ \\t_])\\__(?!_)", 0);
    _regexStrikethrough = regexp("(?<!~)~~(?=[^ \\t~])(.+?)(?<=[^ \\t~])\\~~(?!~)", 0);
    _regexInlineCode = regexp("(?<!`)(`{1,3})([^`\n]+?)\\1(?!`)", 0);
    _regexLink = regexp("!?\\[([^\\[\\]]+)\\](\\(([^\\(\\)]+)\\)|\\[([^\\[\\]]+)\\])", 0);
    _regexLinkRefer = regexp("^[ \\t]*\\[[^\\[\\]]\\]:", NSRegularExpressionAnchorsMatchLines);
    _regexList = regexp("^[ \\t]*([*+-]|\\d+[.])[ \\t]+", NSRegularExpressionAnchorsMatchLines);
    _regexBlockQuote = regexp("^[ \\t]*>[ \\t>]*", NSRegularExpressionAnchorsMatchLines);
    _regexCodeBlock = regexp("(^\\s*$\\n)((( {4}|\\t).*(\\n|\\z))|(^\\s*$\\n))+", NSRegularExpressionAnchorsMatchLines);
    _regexNotEmptyLine = regexp("^[ \\t]*[^ \\t]+[ \\t]*$", NSRegularExpressionAnchorsMatchLines);
#undef regexp
}

- (instancetype)parser {
    return [[DYMarkdownParser alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setFontSize:kDefaultFontSize];
        [self setTheme:DYMarkdownThemeDefault];
        [self initRegex];
    }
    return self;
}

- (void)setFontSize:(CGFloat)fontSize {
    self->_fontSize = fontSize;
    self->_font = [UIFont systemFontOfSize:fontSize];
    
    NSMutableArray<UIFont *> * mutableHeaderFonts = [NSMutableArray arrayWithCapacity:6];
    for (int i=6; i>=1; --i) {
        [mutableHeaderFonts addObject:[UIFont boldSystemFontOfSize:fontSize+i]];
    }
    self->_headerFonts = mutableHeaderFonts;
    
    self->_boldFont = [UIFont fontWithDescriptor:[self->_font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:fontSize];
    self->_italicFont = [UIFont fontWithDescriptor:[self->_font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:fontSize];
    self->_boldItalicFont = [UIFont fontWithDescriptor:[self->_font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic] size:fontSize];
    // Since iOS 7
    self->_monospaceFont = [UIFont fontWithName:@"Menlo" size:_fontSize];
    // Since iOS 3
    if (!self->_monospaceFont) {
        self->_monospaceFont = [UIFont fontWithName:@"Courier" size:_fontSize];
    }
}

- (void)setTheme:(DYMarkdownTheme)theme {
    if (theme == DYMarkdownThemeDefault) {
        
    }
    else if (theme == DYMarkdownThemeDark) {
        
    }
    _textColor = UIColor.blackColor;
    _controlTextColor = UIColor.darkGrayColor;
    _headerTextColor = UIColor.blackColor;
    _inlineTextColor = UIColor.purpleColor;
    _codeTextColor = UIColor.brownColor;
    _linkTextColor = UIColor.blueColor;
}

- (NSUInteger)lenghOfBeginWhiteInString:(NSString *)str withRange:(NSRange)range{
    for (NSUInteger i = 0; i < range.length; i++) {
        unichar c = [str characterAtIndex:i + range.location];
        if (c != ' ' && c != '\t' && c != '\n') return i;
    }
    return str.length;
}

- (NSUInteger)lenghOfEndWhiteInString:(NSString *)str withRange:(NSRange)range{
    for (NSInteger i = range.length - 1; i >= 0; i--) {
        unichar c = [str characterAtIndex:i + range.location];
        if (c != ' ' && c != '\t' && c != '\n') return range.length - i;
    }
    return str.length;
}

- (NSUInteger)lenghOfBeginChar:(unichar)c inString:(NSString *)str withRange:(NSRange)range{
    for (NSUInteger i = 0; i < range.length; i++) {
        if ([str characterAtIndex:i + range.location] != c) return i;
    }
    return str.length;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)range {
    if (text.length == 0) return NO;
    // remove attributes
    [text setAttributes:nil range:NSMakeRange(0, text.length)];
    [text setAttributes:@{
                          NSFontAttributeName: self->_font,
                          NSForegroundColorAttributeName: self->_textColor
                          } range:NSMakeRange(0, text.length)];
    
    NSMutableString *str = [text.string mutableCopy];
    [_regexEscape replaceMatchesInString:str options:kNilOptions range:NSMakeRange(0, str.length) withTemplate:@"@@"];
    
    [_regexHeader enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        NSUInteger whiteLen = [self lenghOfBeginWhiteInString:str withRange:r];
        NSUInteger sharpLen = [self lenghOfBeginChar:'#' inString:str withRange:NSMakeRange(r.location+whiteLen, r.length-whiteLen)];
        if (sharpLen > 6) sharpLen = 6;
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:NSMakeRange(r.location, whiteLen+sharpLen)];
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_headerTextColor
                              } range:NSMakeRange(r.location+whiteLen+sharpLen, r.length-whiteLen-sharpLen)];
        [text setAttributes:@{
                              NSFontAttributeName: self->_headerFonts[sharpLen-1]
                              } range:result.range];
    }];
    
    [_regexH1 enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        NSRange linebreak = [str rangeOfString:@"\n" options:0 range:result.range locale:nil];
        if (linebreak.location != NSNotFound) {
            [text setAttributes:@{
                                  NSForegroundColorAttributeName: self->_headerTextColor
                                  } range:NSMakeRange(r.location, linebreak.location-r.location)];
            [text setAttributes:@{
                                  NSFontAttributeName: self->_headerFonts[0]
                                  } range:NSMakeRange(r.location, linebreak.location-r.location+1)];
            [text setAttributes:@{
                                  NSForegroundColorAttributeName: self->_controlTextColor
                                  } range:NSMakeRange(linebreak.location+linebreak.length, r.location+r.length-linebreak.location-linebreak.length)];
        }
    }];
    
    [_regexH2 enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        NSRange linebreak = [str rangeOfString:@"\n" options:0 range:result.range locale:nil];
        if (linebreak.location != NSNotFound) {
            [text setAttributes:@{
                                  NSForegroundColorAttributeName: self->_headerTextColor
                                  } range:NSMakeRange(r.location, linebreak.location-r.location)];
            [text setAttributes:@{
                                  NSFontAttributeName: self->_headerFonts[1]
                                  } range:NSMakeRange(r.location, linebreak.location-r.location+1)];
            [text setAttributes:@{
                                  NSForegroundColorAttributeName: self->_controlTextColor
                                  } range:NSMakeRange(linebreak.location+linebreak.length, r.location+r.length-linebreak.location-linebreak.length)];
        }
    }];
    
    [_regexBreakline enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:result.range];
    }];
    
    [_regexEmphasis enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:NSMakeRange(r.location, 1)];
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:NSMakeRange(r.location+r.length-1, 1)];
        [text setAttributes:@{
                              NSFontAttributeName: self->_italicFont
                              } range:NSMakeRange(r.location+1, r.length-2)];
    }];
    
    [_regexStrong enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:NSMakeRange(r.location, 2)];
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:NSMakeRange(r.location+r.length-2, 2)];
        [text setAttributes:@{
                              NSFontAttributeName: self->_boldFont
                              } range:NSMakeRange(r.location+2, r.length-4)];
    }];
    
    [_regexStrongEmphasis enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:NSMakeRange(r.location, 3)];
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:NSMakeRange(r.location + r.length - 3, 3)];
        [text setAttributes:@{
                              NSFontAttributeName: self->_boldItalicFont
                              } range:NSMakeRange(r.location + 3, r.length - 6)];
    }];
    
    [_regexUnderline enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:NSMakeRange(r.location, 2)];
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:NSMakeRange(r.location + r.length - 2, 2)];
        [text setAttributes:@{
                              NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                              } range:NSMakeRange(r.location + 2, r.length - 4)];
    }];
    
    [_regexStrikethrough enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:NSMakeRange(r.location, 2)];
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:NSMakeRange(r.location + r.length - 2, 2)];
        [text setAttributes:@{
                              NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
                              NSBaselineOffsetAttributeName: @(0)
                              } range:NSMakeRange(r.location + 2, r.length - 4)];
    }];
    
    [_regexInlineCode enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        NSUInteger len = [self lenghOfBeginChar:'`' inString:str withRange:r];
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:NSMakeRange(r.location, len)];
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:NSMakeRange(r.location + r.length - len, len)];
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_inlineTextColor
                              } range:NSMakeRange(r.location + len, r.length - 2 * len)];
        [text setAttributes:@{
                              NSFontAttributeName: self->_monospaceFont
                              } range:r];
    }];
    
    [_regexLink enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_linkTextColor
                              } range:r];
    }];
    
    [_regexLinkRefer enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:r];
    }];
    
    [_regexList enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:r];
    }];
    
    [_regexBlockQuote enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_controlTextColor
                              } range:r];
    }];
    
    [_regexCodeBlock enumerateMatchesInString:str options:0 range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange r = result.range;
        NSRange firstLineRange = [self->_regexNotEmptyLine rangeOfFirstMatchInString:str options:kNilOptions range:r];
        NSUInteger lenStart = (firstLineRange.location != NSNotFound) ? firstLineRange.location - r.location : 0;
        NSUInteger lenEnd = [self lenghOfEndWhiteInString:str withRange:r];
        if (lenStart + lenEnd < r.length) {
            NSRange codeR = NSMakeRange(r.location + lenStart, r.length - lenStart - lenEnd);
            [text setAttributes:@{
                              NSForegroundColorAttributeName: self->_codeTextColor
                              } range:codeR];
            [text setAttributes:@{
                              NSFontAttributeName: self->_monospaceFont
                              } range:codeR];
        }
    }];
    
    return YES;
}

@end
