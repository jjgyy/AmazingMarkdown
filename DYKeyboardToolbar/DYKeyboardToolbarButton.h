//
//  DYKeyboardToolbarButton.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^eventHandlerBlock)(void);

@interface DYKeyboardToolbarButton : UIButton

+ (instancetype)button;

+ (instancetype)buttonWithTitle:(NSString *)title;

+ (instancetype)buttonWithTitle:(NSString *)title eventHandler:(eventHandlerBlock _Nullable)eventHandler;

+ (instancetype)buttonWithTitle:(NSString *)title eventHandler:(eventHandlerBlock _Nullable)eventHandler forControlEvents:(UIControlEvents)controlEvents;

- (instancetype)initWithTitle:(NSString *)title;

- (instancetype)initWithTitle:(NSString *)title eventHandler:(eventHandlerBlock _Nullable)eventHandler;

- (instancetype)initWithTitle:(NSString *)title eventHandler:(eventHandlerBlock _Nullable)eventHandler forControlEvents:(UIControlEvents)controlEvent;

- (void)setEventHandler:(eventHandlerBlock)eventHandler forControlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END
