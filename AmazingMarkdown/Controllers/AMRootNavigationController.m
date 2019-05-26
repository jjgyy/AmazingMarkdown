//
//  AMRootNavigationController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/6.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMRootNavigationController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "AmazingMarkdown-Swift.h"
#import "AMExternalMarkdownFile.h"
#import "Chameleon.h"
#import "AMEdittingContentController.h"
#import "AMTheme.h"
#import "AMThemeSettingTableController.h"

NSString * const AMRedirectToEdittingContentControllerNotificationName = @"AMRedirectToEdittingContentControllerNotificationName";
NSString * const AMRequestCreatingFileNotificationName = @"AMRequestCreatingFileNotificationName";

@interface AMRootNavigationController ()

@end

@implementation AMRootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTheme:AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]]];
    
    [NSNotificationCenter.defaultCenter addObserverForName:AMRedirectToEdittingContentControllerNotificationName object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [self popToRootViewControllerAnimated:NO];
        [self performSegueWithIdentifier:@"EditFileSegue" sender:note.userInfo[@"markdownFile"]];
    }];
    
    [NSNotificationCenter.defaultCenter addObserverForName:AMThemeDidChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [self setTheme:AMTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:AMThemeIndexUserDefaultsKey]]];
        [self popToRootViewControllerAnimated:YES];
    }];
    
    [NSNotificationCenter.defaultCenter addObserverForName:AMRequestCreatingFileNotificationName object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [self popToRootViewControllerAnimated:NO];
        [self performSegueWithIdentifier:@"CreateFileSegue" sender:nil];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PreviewMarkdownFileSegue"]) {
        AMPreviewController * destinationViewController = (AMPreviewController *)segue.destinationViewController;
        [destinationViewController loadExternalFileWithExternalFile:(AMExternalMarkdownFile *)sender];
    }
    else if ([segue.identifier isEqualToString:@"EditFileSegue"]) {
        AMEdittingContentController * destinationViewController = (AMEdittingContentController *)segue.destinationViewController;
        [destinationViewController loadFile:(AMMarkdownFile *)sender];
    }
    else if ([segue.identifier isEqualToString:@"CreateFileSegue"]) {
        AMEdittingContentController * destinationViewController = (AMEdittingContentController *)segue.destinationViewController;
        destinationViewController.isFirstResponderAfterAppearing = YES;
    }
}

- (void)setTheme:(AMTheme *)theme {
    self.navigationBar.tintColor = theme.navigationTintColor;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:theme.navigationTintColor}];
    self.navigationBar.barTintColor = theme.navigationBarColor;
}

@end
