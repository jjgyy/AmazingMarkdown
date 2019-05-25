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
#import "AMNavigationTitleTextField.h"
#import "MBProgressHUD.h"
#import "DYMarkdownTextView.h"
#import "AMTheme.h"
#import "AMThemeSettingTableController.h"
#import "AMKeyboardSettingTableController.h"

static const CGFloat kMainTextViewInitialFontSize = 17.0f;
static const CGFloat kMainTextViewInitialFontWeight = 0.01f;

@interface AMEdittingContentController ()

@property (strong, nonatomic) IBOutlet DYMarkdownTextView * mainTextView;
- (IBAction)rightEdgePanGesHandler:(UIScreenEdgePanGestureRecognizer *)sender;

@property (nonatomic, strong) UIBarButtonItem * doneButton;
@property (nonatomic, strong) AMNavigationTitleTextField * titleTextField;
@property (nonatomic, strong) AMMarkdownFile * currentFile;

@end

@implementation AMEdittingContentController {
    NSObject * _keyboardShowObserver;
    NSObject * _keyboardHideObserver;
    BOOL _isReadyToQuit;
}

- (IBAction)rightEdgePanGesHandler:(UIScreenEdgePanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self performSegueWithIdentifier:@"PreviewMarkdownSegue" sender:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置_mainTextView
    [self->_mainTextView setFont:[UIFont systemFontOfSize:kMainTextViewInitialFontSize weight:kMainTextViewInitialFontWeight]];
    
    // 为_mainTextView添加键盘工具栏
    NSArray<NSString *> * shortcutStrings = [NSUserDefaults.standardUserDefaults objectForKey:AMKeyboardSettingShortcutStringsUserDefaultsKey];
    if (!shortcutStrings) {
        shortcutStrings = [AMKeyboardToolbarFactory.defaultMarkdownShortcutStrings mutableCopy];
        [NSUserDefaults.standardUserDefaults setObject:shortcutStrings forKey:AMKeyboardSettingShortcutStringsUserDefaultsKey];
    }
    [AMKeyboardToolbarFactory addMarkdownInputToolbarFor:(UITextView *)self->_mainTextView withShortcutStrings:shortcutStrings];
    
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
    self->_titleTextField = [[AMNavigationTitleTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 35) placeholder:NSLocalizedString(@"title placeholder", nil) fontSize:UIFont.labelFontSize];
    if (![self->_currentFile.title isEqualToString:@""]) {
        self->_titleTextField.text = self->_currentFile.title;
    }
    self.navigationItem.titleView = self->_titleTextField;
    
    // 配置_isReadyToQuit
    self->_isReadyToQuit = YES;
    
    [self setTheme:AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]]];
}


- (void)viewDidAppear:(BOOL)animated {
    // 观察键盘弹出
    self->_keyboardShowObserver = [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardWillShowNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        CGFloat keyboardHeight = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        CGRect rect = self->_mainTextView.frame;
        rect.size.height = self.view.bounds.size.height - keyboardHeight;
        self->_mainTextView.frame = rect;
        [self showDoneButton];
    }];
    // 观察键盘收起
    self->_keyboardHideObserver = [NSNotificationCenter.defaultCenter addObserverForName:UIKeyboardWillHideNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        CGRect rect = self->_mainTextView.frame;
        rect.size.height = self.view.bounds.size.height;
        self->_mainTextView.frame = rect;
        [self hideDoneButton];
    }];
    
    // 页面出现后_mainTextView获得焦点
    if (self->_isFirstResponderAfterAppearing) {
        [self->_mainTextView becomeFirstResponder];
        self->_isFirstResponderAfterAppearing = NO;
    }
    
    [super viewDidAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 将_mainTextView大小复原，隐藏_doneButton
    CGRect rect = self->_mainTextView.frame;
    rect.size.height = self.view.bounds.size.height;
    self->_mainTextView.frame = rect;
    [self hideDoneButton];
    
    if (self->_isReadyToQuit && [self->_titleTextField.text isEqualToString:@""] && [self->_mainTextView.text isEqualToString:@""]) {
        // 如果没有内容, 则从数据库删除
        [NSManagedObjectContext.MR_defaultContext deleteObject:self->_currentFile];
    } else {
        // 保存到数据库
        self->_currentFile.title = [self->_titleTextField.text copy];
        self->_currentFile.content = [self->_mainTextView.text copy];
        NSMutableString * tempSummary = (self->_mainTextView.text.length > 40) ? [self->_mainTextView.text substringToIndex:40].mutableCopy : self->_mainTextView.text.mutableCopy;
        for (NSUInteger index = 0; index < tempSummary.length; ++index) {
            if ([tempSummary characterAtIndex:index] == '\n') {
                [tempSummary replaceCharactersInRange:NSMakeRange(index, 1) withString:@" "];
            }
        }
        self->_currentFile.summary = tempSummary;
        self->_currentFile.modifiedDate = [NSDate new];
    }
    [NSManagedObjectContext.MR_defaultContext MR_saveToPersistentStoreAndWait];
    self->_isReadyToQuit = YES;
    
    // 移除键盘观察
    [NSNotificationCenter.defaultCenter removeObserver:self->_keyboardShowObserver];
    self->_keyboardShowObserver = nil;
    [NSNotificationCenter.defaultCenter removeObserver:self->_keyboardHideObserver];
    self->_keyboardHideObserver = nil;
    
    //[self resignFirstResponderForSubviews];
    
    [super viewWillDisappear:animated];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue触发view disappear, 防止触发删除空文件, 导致返回原页面后编辑空文件不被保存
    self->_isReadyToQuit = NO;
    if ([segue.identifier isEqualToString:@"PreviewMarkdownSegue"]) {
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

- (void)setTheme:(AMTheme *)theme {
    self->_titleTextField.textColor = theme.navigationTintColor;
    self->_mainTextView.backgroundColor = theme.textBackgroundColor;
    self->_mainTextView.textColor = theme.textColor;
}

@end
