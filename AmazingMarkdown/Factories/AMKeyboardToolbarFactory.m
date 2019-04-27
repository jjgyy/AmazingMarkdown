//
//  AMKeyboardToolbarFactory.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMKeyboardToolbarFactory.h"
#import "DYKeyboardToolbar.h"

@implementation AMKeyboardToolbarFactory

+ (void)addMarkdownInputToolbarFor:(UITextView *)textView {
    DYKeyboardToolbarButton * hashButton = [DYKeyboardToolbarButton buttonWithTitle:@"#"];
    [hashButton addEventHandler:^{
        [textView insertText:@"#"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    DYKeyboardToolbarButton * asteriskButton = [DYKeyboardToolbarButton buttonWithTitle:@"*"];
    [asteriskButton addEventHandler:^{
        [textView insertText:@"*"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    DYKeyboardToolbarButton * hyphenButton = [DYKeyboardToolbarButton buttonWithTitle:@"-"];
    [hyphenButton addEventHandler:^{
        [textView insertText:@"-"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    DYKeyboardToolbarButton * underlineButton = [DYKeyboardToolbarButton buttonWithTitle:@"_"];
    [underlineButton addEventHandler:^{
        [textView insertText:@"_"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    DYKeyboardToolbarButton * waveButton = [DYKeyboardToolbarButton buttonWithTitle:@"~"];
    [waveButton addEventHandler:^{
        [textView insertText:@"~"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    DYKeyboardToolbarButton * backquoteButton = [DYKeyboardToolbarButton buttonWithTitle:@"`"];
    [backquoteButton addEventHandler:^{
        [textView insertText:@"`"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    DYKeyboardToolbarButton * rightAngleButton = [DYKeyboardToolbarButton buttonWithTitle:@">"];
    [rightAngleButton addEventHandler:^{
        [textView insertText:@">"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    DYKeyboardToolbarButton *orButton = [DYKeyboardToolbarButton buttonWithTitle:@"|"];
    [orButton addEventHandler:^{
        [textView insertText:@"|"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    DYKeyboardToolbarButton * leftBracketButton = [DYKeyboardToolbarButton buttonWithTitle:@"["];
    [leftBracketButton addEventHandler:^{
        [textView insertText:@"["];
    } forControlEvents:UIControlEventTouchUpInside];
    
    DYKeyboardToolbarButton * rightBracketButton = [DYKeyboardToolbarButton buttonWithTitle:@"]"];
    [rightBracketButton addEventHandler:^{
        [textView insertText:@"]"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    DYKeyboardToolbarButton * leftParenthesesButton = [DYKeyboardToolbarButton buttonWithTitle:@"("];
    [leftParenthesesButton addEventHandler:^{
        [textView insertText:@"("];
    } forControlEvents:UIControlEventTouchUpInside];
    
    DYKeyboardToolbarButton * rightParenthesesButton = [DYKeyboardToolbarButton buttonWithTitle:@")"];
    [rightParenthesesButton addEventHandler:^{
        [textView insertText:@")"];
    } forControlEvents:UIControlEventTouchUpInside];
    
    textView.inputAccessoryView = [DYKeyboardToolbar toolbarWithButtons:@[hashButton, asteriskButton, underlineButton, waveButton, hyphenButton, backquoteButton, rightAngleButton, orButton, leftBracketButton, rightBracketButton, leftParenthesesButton, rightParenthesesButton]];
}

@end
