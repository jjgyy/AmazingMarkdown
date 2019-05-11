//
//  AMRootNavigationController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/6.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMRootNavigationController.h"
#import "AmazingMarkdown-Swift.h"
#import "AMExternalMarkdownFile.h"
#import "Chameleon.h"
#import "AMEdittingContentController.h"
#import "DYTheme.h"

@interface AMRootNavigationController ()

@end

@implementation AMRootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTheme:DYTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:DYThemeIndexUserDefaultsKey]]];
    
    [NSNotificationCenter.defaultCenter addObserverForName:RedirectToEdittingContentControllerNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [self popToRootViewControllerAnimated:NO];
        [self performSegueWithIdentifier:@"EditFileSegue" sender:note.userInfo[@"markdownFile"]];
    }];
    
    [NSNotificationCenter.defaultCenter addObserverForName:DYThemeDidChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [self setTheme:DYTheme.themes[[NSUserDefaults.standardUserDefaults integerForKey:DYThemeIndexUserDefaultsKey]]];
        [self popToRootViewControllerAnimated:YES];
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
}

- (void)setTheme:(DYTheme *)theme {
    self.navigationBar.tintColor = theme.navigationTintColor;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:theme.navigationTintColor}];
    self.navigationBar.barTintColor = theme.navigationBarColor;
}

@end
