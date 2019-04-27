//
//  AMEdittingContentController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/26.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMEdittingContentController.h"
#import "AmazingMarkdown-Swift.h"
#import "DYMarkdownTextView.h"
#import "AMKeyboardToolbarFactory.h"
#import "NSAttributedStringMarkdownParser.h"

static const CGFloat kMainTextViewInitialFontSize = 17.0f;
static const CGFloat kMainTextViewInitialFontWeight = 0.01f;

@interface AMEdittingContentController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (strong, nonatomic) IBOutlet DYMarkdownTextView * mainTextView;

@property (nonatomic, strong) UIBarButtonItem * doneButton;

@end

@implementation AMEdittingContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self->_mainTextView setFont:[UIFont systemFontOfSize:kMainTextViewInitialFontSize weight:kMainTextViewInitialFontWeight]];
    [AMKeyboardToolbarFactory addMarkdownInputToolbarFor:(UITextView *)self->_mainTextView];
    
    self->_doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self->_mainTextView action:@selector(resignFirstResponder)];
    
    
    [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardWillShowNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        CGFloat keyboardHeight = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        CGRect rect = UIScreen.mainScreen.bounds;
        rect.size.height -= keyboardHeight;
        self->_mainTextView.frame = rect;
        [self showDoneButton];
    }];
    
    [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardWillHideNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        self->_mainTextView.frame = UIScreen.mainScreen.bounds;
        [self hideDoneButton];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[AMPreviewController class]]) {
        AMPreviewController * destinationViewController = (AMPreviewController *)segue.destinationViewController;
        [destinationViewController loadWithMarkdown:self.mainTextView.text];
    }
}

- (void)showDoneButton {
    if (![self->_navigationItem.rightBarButtonItems containsObject:self->_doneButton]) {
        self->_navigationItem.rightBarButtonItems = [@[self->_doneButton] arrayByAddingObjectsFromArray:self->_navigationItem.rightBarButtonItems];
    }
}

- (void)hideDoneButton {
    NSMutableArray<UIBarButtonItem *> * mutableRightBarButtonItems = [self->_navigationItem.rightBarButtonItems mutableCopy];
    [mutableRightBarButtonItems removeObject:self->_doneButton];
    self->_navigationItem.rightBarButtonItems = (NSArray<UIBarButtonItem *> *)mutableRightBarButtonItems;
}

@end
