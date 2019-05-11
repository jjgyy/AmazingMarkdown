//
//  DYTheme+Themes.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/9.
//  Copyright © 2019 Young. All rights reserved.
//

#import "DYTheme+Class.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYTheme (Themes)

@property (class, nonatomic, readonly) NSArray<DYTheme *> * themes;

@property (class, nonatomic, readonly) DYTheme * brightTheme;

@property (class, nonatomic, readonly) DYTheme * darkTheme;

@end

NS_ASSUME_NONNULL_END
