//
//  DYMarkdownTextView.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import "DYMarkdownTextView.h"

@implementation DYMarkdownTextView

- (BOOL)becomeFirstResponder {
    [NSNotificationCenter.defaultCenter postNotificationName:@"DYMarkdownTextView.becomeFirstResponder" object:nil];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [NSNotificationCenter.defaultCenter postNotificationName:@"DYMarkdownTextView.resignFirstResponder" object:nil];
    return [super resignFirstResponder];
}

@end
