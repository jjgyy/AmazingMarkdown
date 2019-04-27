//
//  DYKeyboardToolbar.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AvailabilityMacros.h>
#import "DYKeyboardToolbarButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYKeyboardToolbar : UIView

@property (nonatomic, strong) NSArray *buttons;

+ (instancetype)toolbarWithButtons:(NSArray *)buttons;

- (void)setButtons:(NSArray *)buttons animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
