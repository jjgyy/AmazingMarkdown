//
//  AMEdittingContentController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/26.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMEdittingContentController.h"
#import "AmazingMarkdown-Swift.h"
#import <YYText/YYText.h>
#import "AMKeyboardToolbarFactory.h"
#import "AMYYMarkdownParser.h"
#import <MagicalRecord/MagicalRecord.h>

static const CGFloat kMainTextViewInitialFontSize = 17.0f;
static const CGFloat kMainTextViewInitialFontWeight = 0.01f;

@interface AMEdittingContentController ()

@property (weak, nonatomic) IBOutlet UINavigationItem * navigationItem;
@property (strong, nonatomic) IBOutlet YYTextView * mainTextView;
- (IBAction)rightEdgePanGesHandler:(UIScreenEdgePanGestureRecognizer *)sender;

@property (nonatomic, strong) UIBarButtonItem * doneButton;
@property (nonatomic, strong) AMMarkdownFile * currentFile;

@end

@implementation AMEdittingContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置_mainTextView
    [self->_mainTextView setFont:[UIFont systemFontOfSize:kMainTextViewInitialFontSize weight:kMainTextViewInitialFontWeight]];
    [self->_mainTextView setTextParser:[AMYYMarkdownParser new]];
    [AMKeyboardToolbarFactory addMarkdownInputToolbarFor:(UITextView *)self->_mainTextView];
    
    // 配置_doneButton
    self->_doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self->_mainTextView action:@selector(resignFirstResponder)];
    
    // 配置_currentFile
    if (!self->_currentFile) {
        // 创建新文件
        self->_currentFile = [AMMarkdownFile MR_createEntity];
        self->_currentFile.title = @"untitled";
    } else {
        self->_mainTextView.text = self->_currentFile.content;
    }
    
    // 观察键盘弹出
    [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardWillShowNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        CGFloat keyboardHeight = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        CGRect rect = self.mainTextView.frame;
        rect.size.height = UIScreen.mainScreen.bounds.size.height - self.view.safeAreaInsets.top - keyboardHeight;
        self->_mainTextView.frame = rect;
        [self showDoneButton];
    }];
    
    // 观察键盘收起
    [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardWillHideNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        CGRect rect = self.mainTextView.frame;
        rect.size.height = UIScreen.mainScreen.bounds.size.height - self.view.safeAreaInsets.top;
        self->_mainTextView.frame = rect;
        [self hideDoneButton];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PreviewMarkdownSegue"]) {
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

- (void)loadFile:(AMMarkdownFile *)file {
    self->_currentFile = file;
}

- (void)viewWillDisappear:(BOOL)animated {
    self->_currentFile.content = [self->_mainTextView.text copy];
    [NSManagedObjectContext.MR_defaultContext MR_saveToPersistentStoreAndWait];
    [super viewWillDisappear:animated];
}

- (IBAction)rightEdgePanGesHandler:(UIScreenEdgePanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self performSegueWithIdentifier:@"PreviewMarkdownSegue" sender:self];
    }
}
@end
