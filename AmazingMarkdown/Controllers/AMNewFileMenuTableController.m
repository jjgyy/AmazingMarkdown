//
//  AMNewFileMenuTableController.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/25.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMNewFileMenuTableController.h"
#import "AMRootNavigationController.h"

@interface AMNewFileMenuTableController ()

@end

@implementation AMNewFileMenuTableController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [NSNotificationCenter.defaultCenter postNotificationName:AMRequestCreatingFileNotificationName object:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
    if (indexPath.row == 2) {
        // TODO: Templated
    }
    if (indexPath.row == 3) {
        [NSNotificationCenter.defaultCenter postNotificationName:AMRequestCreatingFolderNotificationName object:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
}

@end
