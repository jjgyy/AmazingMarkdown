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
    DYKeyboardToolbarButton * hashButton = [DYKeyboardToolbarButton buttonWithTitle:@"#" eventHandler:^{
        [textView insertText:@"#"];
    }];
    
    DYKeyboardToolbarButton * asteriskButton = [DYKeyboardToolbarButton buttonWithTitle:@"*" eventHandler:^{
        [textView insertText:@"*"];
    }];
    
    DYKeyboardToolbarButton * hyphenButton = [DYKeyboardToolbarButton buttonWithTitle:@"-" eventHandler:^{
        [textView insertText:@"-"];
    }];
    
    DYKeyboardToolbarButton * underlineButton = [DYKeyboardToolbarButton buttonWithTitle:@"_" eventHandler:^{
        [textView insertText:@"_"];
    }];
    
    DYKeyboardToolbarButton * waveButton = [DYKeyboardToolbarButton buttonWithTitle:@"~" eventHandler:^{
        [textView insertText:@"~"];
    }];
    
    DYKeyboardToolbarButton * backquoteButton = [DYKeyboardToolbarButton buttonWithTitle:@"`" eventHandler:^{
        [textView insertText:@"`"];
    }];
    
    DYKeyboardToolbarButton * rightAngleButton = [DYKeyboardToolbarButton buttonWithTitle:@">" eventHandler:^{
        [textView insertText:@">"];
    }];
    
    DYKeyboardToolbarButton *orButton = [DYKeyboardToolbarButton buttonWithTitle:@"|" eventHandler:^{
        [textView insertText:@"|"];
    }];
    
    DYKeyboardToolbarButton * leftBracketButton = [DYKeyboardToolbarButton buttonWithTitle:@"[" eventHandler:^{
        [textView insertText:@"["];
    }];
    
    DYKeyboardToolbarButton * rightBracketButton = [DYKeyboardToolbarButton buttonWithTitle:@"]" eventHandler:^{
        [textView insertText:@"]"];
    }];
    
    DYKeyboardToolbarButton * leftParenthesesButton = [DYKeyboardToolbarButton buttonWithTitle:@"(" eventHandler:^{
        [textView insertText:@"("];
    }];
    
    DYKeyboardToolbarButton * rightParenthesesButton = [DYKeyboardToolbarButton buttonWithTitle:@")" eventHandler:^{
        [textView insertText:@")"];
    }];
    
    textView.inputAccessoryView = [DYKeyboardToolbar toolbarWithButtons:@[hashButton, asteriskButton, underlineButton, waveButton, hyphenButton, backquoteButton, rightAngleButton, orButton, leftBracketButton, rightBracketButton, leftParenthesesButton, rightParenthesesButton]];
}

@end
