//
//  UIViewController+DYTheme.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/10.
//  Copyright © 2019 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DYTheme;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (DYTheme)

- (void)setTheme:(DYTheme *)theme;

@end

NS_ASSUME_NONNULL_END
