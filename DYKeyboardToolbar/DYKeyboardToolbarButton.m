//
//  DYKeyboardToolbarButton.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import "DYKeyboardToolbarButton.h"

static const CGFloat kButtonCornerRadius = 5.0f;
static const CGFloat kButtonContentHorizontalInset = 22.0f;
static const CGFloat kButtonContentVerticalInset = 10.0f;
static const CGFloat kButtonTitleFontSize = 20.0f;

@interface DYKeyboardToolbarButton ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) eventHandlerBlock eventHandler;

@end


@implementation DYKeyboardToolbarButton

+ (instancetype)button {
    return [[DYKeyboardToolbarButton alloc] init];
}

+ (instancetype)buttonWithTitle:(NSString *)title {
    return [[DYKeyboardToolbarButton alloc] initWithTitle:title];
}

+ (instancetype)buttonWithTitle:(NSString *)title eventHandler:(eventHandlerBlock _Nullable)eventHandler {
    return [[DYKeyboardToolbarButton alloc] initWithTitle:title eventHandler:eventHandler];
}

+ (instancetype)buttonWithTitle:(NSString *)title eventHandler:(eventHandlerBlock _Nullable)eventHandler forControlEvents:(UIControlEvents)controlEvents {
    return [[DYKeyboardToolbarButton alloc] initWithTitle:title eventHandler:eventHandler forControlEvents:controlEvents];
}

- (instancetype)init {
    return [self initWithTitle:@"" eventHandler:nil forControlEvents:0];
}

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title eventHandler:nil forControlEvents:0];
}

- (instancetype)initWithTitle:(NSString *)title eventHandler:(eventHandlerBlock)eventHandler {
    return [self initWithTitle:title eventHandler:eventHandler forControlEvents:UIControlEventTouchUpInside];
}

- (instancetype)initWithTitle:(NSString *)title eventHandler:(eventHandlerBlock _Nullable)eventHandler forControlEvents:(UIControlEvents)controlEvent {
    CGSize sizeOfText = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:kButtonTitleFontSize]}];
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, sizeOfText.width + kButtonContentHorizontalInset, sizeOfText.height + kButtonContentVerticalInset)]) {
        self->_title = title;
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = kButtonCornerRadius;
        [self setTitle:self.title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
        if (eventHandler) {
            [self setEventHandler:eventHandler forControlEvents:controlEvent];
        }
    }
    return self;
}

- (void)setEventHandler:(eventHandlerBlock)eventHandler {
    [self setEventHandler:eventHandler forControlEvents:UIControlEventTouchUpInside];
}

- (void)setEventHandler:(eventHandlerBlock)eventHandler forControlEvents:(UIControlEvents)controlEvents {
    self->_eventHandler = eventHandler;
    [self addTarget:self action:@selector(triggerEventHandler) forControlEvents:controlEvents];
}

- (void)triggerEventHandler {
    self.eventHandler();
}

@end
