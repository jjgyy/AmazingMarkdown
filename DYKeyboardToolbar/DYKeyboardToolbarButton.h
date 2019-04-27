//
//  DYKeyboardToolbarButton.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern const CGFloat DYKeyboardToolbarButtonTitleFontSize;

typedef void (^eventHandlerBlock)(void);

@interface DYKeyboardToolbarButton : UIButton

+ (instancetype)buttonWithTitle:(NSString *)title;

+ (instancetype)buttonWithTitle:(NSString *)title andEventHandler:(eventHandlerBlock)eventHandler forControlEvents:(UIControlEvents)controlEvent;

- (void)addEventHandler:(eventHandlerBlock)eventHandler forControlEvents:(UIControlEvents)controlEvent;

@end

NS_ASSUME_NONNULL_END
