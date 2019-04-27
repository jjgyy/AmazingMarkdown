//
//  AMEdittingContentController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/26.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMEdittingContentController.h"
#import "AmazingMarkdown-Swift.h"

@interface AMEdittingContentController ()

@end

@implementation AMEdittingContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[AMPreviewController class]]) {
        AMPreviewController * destinationViewController = (AMPreviewController *)segue.destinationViewController;
        [destinationViewController loadWithMarkdown:@"# Hello"];
    }
}

@end
