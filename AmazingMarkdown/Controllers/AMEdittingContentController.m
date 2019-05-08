//
//  AMEdittingContentController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/26.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMEdittingContentController.h"
#import "AmazingMarkdown-Swift.h"
#import "AMKeyboardToolbarFactory.h"
#import <MagicalRecord/MagicalRecord.h>
#import "AMCenterPlaceholderTextField.h"
#import "MBProgressHUD.h"
#import "DYMarkdownTextView.h"

static const CGFloat kMainTextViewInitialFontSize = 17.0f;
static const CGFloat kMainTextViewInitialFontWeight = 0.01f;

@interface AMEdittingContentController ()

@property (strong, nonatomic) IBOutlet DYMarkdownTextView * mainTextView;
- (IBAction)rightEdgePanGesHandler:(UIScreenEdgePanGestureRecognizer *)sender;

@property (nonatomic, strong) UIBarButtonItem * doneButton;
@property (nonatomic, strong) AMCenterPlaceholderTextField * titleTextField;
@property (nonatomic, strong) AMMarkdownFile * currentFile;

@end

@implementation AMEdittingContentController {
    BOOL _isGoingToPreview;
}

- (IBAction)rightEdgePanGesHandler:(UIScreenEdgePanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self performSegueWithIdentifier:@"PreviewMarkdownSegue" sender:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置_mainTextView
    [self->_mainTextView setFont:[UIFont systemFontOfSize:kMainTextViewInitialFontSize weight:kMainTextViewInitialFontWeight]];
    [AMKeyboardToolbarFactory addMarkdownInputToolbarFor:(UITextView *)self->_mainTextView];
    
    // 配置_doneButton
    self->_doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickDoneButtonHandler)];
    
    // 配置_currentFile
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self->_currentFile) {
            NSString * content = self->_currentFile.content;
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_mainTextView.text = content;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        } else {
            // 防止_currentFile为空
            self->_currentFile = [AMMarkdownFile MR_createEntity];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
    });
    
    // 配置_titleTextField, 依赖_currentFile
    self->_titleTextField = [[AMCenterPlaceholderTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 35) placeholder:NSLocalizedString(@"title placeholder", nil)];
    if (![self->_currentFile.title isEqualToString:@""]) {
        self->_titleTextField.text = self->_currentFile.title;
    }
    self.navigationItem.titleView = self->_titleTextField;
    
    // 配置_isGoingToPreview, 用于控制切换页面时空文件是否删除
    self->_isGoingToPreview = NO;
}


- (void)viewWillAppear:(BOOL)animated {
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
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (!self->_isGoingToPreview && [self->_titleTextField.text isEqualToString:@""] && [self->_mainTextView.text isEqualToString:@""]) {
        [NSManagedObjectContext.MR_defaultContext deleteObject:self->_currentFile];
        [NSManagedObjectContext.MR_defaultContext MR_saveToPersistentStoreAndWait];
    }
    self->_isGoingToPreview = NO;
    
    // 保存到数据库
    self->_currentFile.title = [self->_titleTextField.text copy];
    self->_currentFile.content = [self->_mainTextView.text copy];
    self->_currentFile.summary = (self->_mainTextView.text.length > 40) ? [self->_mainTextView.text substringToIndex:40] : self->_mainTextView.text;
    self->_currentFile.modifiedDate = [NSDate new];
    [NSManagedObjectContext.MR_defaultContext MR_saveToPersistentStoreAndWait];
    
    // 移除键盘观察
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self resignFirstResponderForSubviews];
    
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PreviewMarkdownSegue"]) {
        self->_isGoingToPreview = YES;
        AMPreviewController * destinationViewController = (AMPreviewController *)segue.destinationViewController;
        [destinationViewController loadWithMarkdown:self.mainTextView.text];
    }
}

- (void)showDoneButton {
    if (![self.navigationItem.rightBarButtonItems containsObject:self->_doneButton]) {
        self.navigationItem.rightBarButtonItems = [@[self->_doneButton] arrayByAddingObjectsFromArray:self.navigationItem.rightBarButtonItems];
    }
}

- (void)hideDoneButton {
    NSMutableArray<UIBarButtonItem *> * mutableRightBarButtonItems = [self.navigationItem.rightBarButtonItems mutableCopy];
    [mutableRightBarButtonItems removeObject:self->_doneButton];
    self.navigationItem.rightBarButtonItems = (NSArray<UIBarButtonItem *> *)mutableRightBarButtonItems;
}

- (void)loadFile:(AMMarkdownFile *)file {
    self->_currentFile = file;
}

- (void)clickDoneButtonHandler {
    [self resignFirstResponderForSubviews];
}

- (void)resignFirstResponderForSubviews {
    if ([self->_mainTextView isFirstResponder]) {
        [self->_mainTextView resignFirstResponder];
    }
    if ([self->_titleTextField isFirstResponder]) {
        [self->_titleTextField resignFirstResponder];
    }
}

- (void)dealloc {
    NSLog(@"释放了!!!!!!!!!!!!!!!!!!!!!!");
}

@end
