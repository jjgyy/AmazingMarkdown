//
//  DYMarkdownTextView.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import "DYMarkdownTextView.h"

@implementation DYMarkdownTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAttributedText) name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAttributedText) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

@end
