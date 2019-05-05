//
//  AMEdittingContentController.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/26.
//  Copyright © 2019 Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMMarkdownFile+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMEdittingContentController : UIViewController

- (void)loadFile:(AMMarkdownFile *)file;

@end

NS_ASSUME_NONNULL_END
