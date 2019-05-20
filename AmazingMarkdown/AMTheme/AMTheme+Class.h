//
//  AMTheme+Class.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/9.
//  Copyright © 2019 Young. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Chameleon.h"

NS_ASSUME_NONNULL_BEGIN

@interface AMTheme : NSObject

@property (nonatomic, copy) NSString * themeName;

@property (nonatomic, strong) UIColor * navigationBarColor;
@property (nonatomic, strong) UIColor * navigationTintColor;

@property (nonatomic, strong) UIColor * backgroundColor;

@property (nonatomic, strong) UIColor * sectionTitleColor;
@property (nonatomic, strong) UIColor * separatorColor;
@property (nonatomic, strong) UIColor * cellColor;
@property (nonatomic, strong) UIColor * cellSelectedColor;
@property (nonatomic, strong) UIColor * cellTitleColor;
@property (nonatomic, strong) UIColor * cellTitleSpecialColor;

@property (nonatomic, strong) UIColor * textColor;
@property (nonatomic, strong) UIColor * textBackgroundColor;
@property (nonatomic, strong) UIColor * placeholderColor;

@property (nonatomic, copy) NSString * cssStyleString;

@end

NS_ASSUME_NONNULL_END
