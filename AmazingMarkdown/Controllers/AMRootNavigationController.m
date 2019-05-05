//
//  AMRootNavigationController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/6.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMRootNavigationController.h"
#import "AmazingMarkdown-Swift.h"

@interface AMRootNavigationController ()

@end

@implementation AMRootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PreviewMarkdownFileSegue"]) {
        AMPreviewController * destinationViewController = (AMPreviewController *)segue.destinationViewController;
        [destinationViewController loadWithMarkdown:(NSString *)sender];
    }
}

@end
