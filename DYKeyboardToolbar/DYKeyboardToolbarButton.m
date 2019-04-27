//
//  DYKeyboardToolbarButton.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import "DYKeyboardToolbarButton.h"

const CGFloat DYKeyboardToolbarButtonTitleFontSize = 14.0f;
static const CGFloat kButtonCornerRadius = 3.0f;
static const CGFloat kButtonContentHorizontalInset = 18.0f;
static const CGFloat kButtonContentVerticalInset = 14.0f;
static const CGFloat kButtonTitleFontSize = 14.0f;

@interface DYKeyboardToolbarButton ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) eventHandlerBlock buttonPressBlock;

@end

@implementation DYKeyboardToolbarButton

+ (instancetype)buttonWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

+ (instancetype)buttonWithTitle:(NSString *)title andEventHandler:(eventHandlerBlock)eventHandler forControlEvents:(UIControlEvents)controlEvent {
    DYKeyboardToolbarButton *newButton = [DYKeyboardToolbarButton buttonWithTitle:title];
    [newButton addEventHandler:eventHandler forControlEvents:controlEvent];
    
    return newButton;
}

- (id)initWithTitle:(NSString *)title {
    _title = title;
    return [self init];
}

- (id)init {
    CGSize sizeOfText = [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:DYKeyboardToolbarButtonTitleFontSize]}];
    if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, sizeOfText.width + kButtonContentHorizontalInset, sizeOfText.height + kButtonContentVerticalInset)]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = kButtonCornerRadius;
        [self setTitle:self.title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:kButtonTitleFontSize];
    }
    return self;
}

- (void)addEventHandler:(eventHandlerBlock)eventHandler forControlEvents:(UIControlEvents)controlEvent {
    self.buttonPressBlock = eventHandler;
    [self addTarget:self action:@selector(buttonPressed) forControlEvents:controlEvent];
}

- (void)buttonPressed {
    self.buttonPressBlock();
}

@end
