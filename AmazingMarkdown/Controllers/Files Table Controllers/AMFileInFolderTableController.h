//
//  AMFileInFolderTableController.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMThemeTableViewController.h"
#import "AMMarkdownFolder+CoreDataClass.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMFileInFolderTableController : AMThemeTableViewController <UIViewControllerPreviewingDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (void)loadFolder:(AMMarkdownFolder *)folder;

@end

NS_ASSUME_NONNULL_END
