//
//  DYMarkdownTextView.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import "DYMarkdownTextView.h"
#import "DYMarkdownParser.h"

@implementation DYMarkdownTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAttributedText) name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAttributedText) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)updateAttributedText {
    if (self.attributedText) {
        NSRange range = NSMakeRange(0, self.attributedText.length);
        NSMutableAttributedString * mutableAttributed = [self.attributedText mutableCopy];
        [DYMarkdownParser.sharedParser parseText:mutableAttributed selectedRange:&range];
        self.attributedText = mutableAttributed;
    }
}

@end
