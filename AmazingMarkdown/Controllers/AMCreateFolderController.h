//
//  AMCreateFolderController.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/26.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMThemeViewController.h"
#import "AMMarkdownFolder+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMCreateFolderController : AMThemeViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

- (void)loadMarkdownFolder:(AMMarkdownFolder *)markdownFolder;

@end

NS_ASSUME_NONNULL_END
