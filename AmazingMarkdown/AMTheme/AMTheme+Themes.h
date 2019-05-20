//
//  AMTheme+Themes.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/9.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMTheme+Class.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMTheme (Themes)

@property (class, nonatomic, readonly) NSArray<AMTheme *> * themes;

@property (class, nonatomic, readonly) AMTheme * brightTheme;

@property (class, nonatomic, readonly) AMTheme * darkTheme;

@end

NS_ASSUME_NONNULL_END
