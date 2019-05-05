//
//  DYKeyboardToolbar.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import "DYKeyboardToolbar.h"
#import <ChameleonFramework/Chameleon.h>

//rgb: 208 210 216
static NSString * const kNativeKeyboardColorHexString = @"#d0d2d8";
static const CGFloat kToolbarHeight = 40.0f;
static const CGFloat kToolbarContentHorizontalInset = 8.0f;
static const CGFloat kToolbarContentVerticalInset = 6.0f;
static const CGFloat kGapBetweenButtons = 6.0f;

@interface DYKeyboardToolbar ()

@property (nonatomic,strong) UIView *toolbarView;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation DYKeyboardToolbar

+ (instancetype)toolbarWithButtons:(NSArray *)buttons {
    return [[DYKeyboardToolbar alloc] initWithButtons:buttons];
}

- (id)initWithButtons:(NSArray *)buttons {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, self.window.rootViewController.view.bounds.size.width, kToolbarHeight)];
    if (self) {
        _buttons = [buttons copy];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:[self inputAccessoryView]];
        self->_scrollView.contentOffset = CGPointMake(-kToolbarContentHorizontalInset, 0.0f);
    }
    return self;
}

- (void)layoutSubviews {
    CGRect frame = _toolbarView.bounds;
    frame.size.height = 0.5f;
}

- (UIView *)inputAccessoryView {
    _toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, kToolbarHeight)];
    _toolbarView.backgroundColor = HexColor(kNativeKeyboardColorHexString);
    _toolbarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_toolbarView addSubview:[self fakeToolbar]];
    return _toolbarView;
}

- (UIScrollView *)fakeToolbar {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, kToolbarHeight)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentInset = UIEdgeInsetsMake(kToolbarContentVerticalInset, kToolbarContentHorizontalInset, kToolbarContentVerticalInset, kToolbarContentHorizontalInset);
    [self addButtons];
    return _scrollView;
}

- (void)addButtons {
    CGFloat originX = 0.0f;
    for (DYKeyboardToolbar * eachButton in _buttons) {
        eachButton.frame = CGRectMake(originX, 0.0f, eachButton.frame.size.width, eachButton.frame.size.height);
        [_scrollView addSubview:eachButton];
        originX += (eachButton.bounds.size.width + kGapBetweenButtons);
    }
    CGSize contentSize = CGSizeMake(originX - kGapBetweenButtons, _scrollView.contentSize.height);
    _scrollView.contentSize = contentSize;
}

- (void)setButtons:(NSArray *)buttons {
    [_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _buttons = [buttons copy];
    [self addButtons];
}

- (void)setButtons:(NSArray *)buttons animated:(BOOL)animated {
    if (!animated) {
        self.buttons = buttons;
        return;
    }
    
    NSMutableSet *removedButtons = [NSMutableSet setWithArray:_buttons];
    [removedButtons minusSet:[NSSet setWithArray:buttons]];
    NSMutableSet *addedButtons = [NSMutableSet setWithArray:buttons];
    [addedButtons minusSet:[NSSet setWithArray:_buttons]];
    _buttons = [buttons copy];
    
    CGFloat originX = 0.0f;
    NSMutableArray * buttonFrames = [NSMutableArray arrayWithCapacity:_buttons.count];
    
    for (DYKeyboardToolbar * eachButton in _buttons) {
        CGRect frame = CGRectMake(originX, 0.0f, eachButton.frame.size.width, eachButton.frame.size.height);
        [buttonFrames addObject:[NSValue valueWithCGRect:frame]];
        originX += (eachButton.bounds.size.width + kGapBetweenButtons);
    }
    
    CGSize contentSize = _scrollView.contentSize;
    contentSize.width = originX - kGapBetweenButtons;
    if (contentSize.width > _scrollView.contentSize.width) {
        _scrollView.contentSize = contentSize;
    }
    
    // make added buttons appear from the right
    [addedButtons enumerateObjectsUsingBlock:^(DYKeyboardToolbar * button, BOOL * stop) {
        button.frame = CGRectMake(originX, 0.0f, button.frame.size.width, button.frame.size.height);
        [self->_scrollView addSubview:button];
    }];
    
    // animate
    [UIView animateWithDuration:0.2 animations:^{
        [removedButtons enumerateObjectsUsingBlock:^(DYKeyboardToolbar *button, BOOL *stop) {
            button.alpha = 0;
        }];
        
        [self->_buttons enumerateObjectsUsingBlock:^(DYKeyboardToolbar *button, NSUInteger idx, BOOL *stop) {
            button.frame = [buttonFrames[idx] CGRectValue];
        }];
        
        self->_scrollView.contentSize = contentSize;
    } completion:^(BOOL finished) {
        [removedButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

@end
