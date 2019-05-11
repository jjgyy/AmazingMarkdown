//
//  DYProgressView.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/11.
//  Copyright © 2019 Young. All rights reserved.
//

#import "DYProgressView.h"

@implementation DYProgressView {
    NSObject * _observed;
    NSString * _keyPath;
}

- (instancetype)initWithFrame:(CGRect)frame observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)object {
    if (self = [super initWithFrame:frame]) {
        self->_observed = object;
        self->_keyPath = keyPath;
        [object addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

+ (instancetype)progressViewWithFrame:(CGRect)frame observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)object {
    return [[DYProgressView alloc] initWithFrame:frame observeValueForKeyPath:keyPath ofObject:object];
}

- (void)dealloc {
    [self->_observed removeObserver:self forKeyPath:self->_keyPath context:nil];
    self->_observed = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self->_observed && [keyPath isEqualToString:self->_keyPath]) {
        float progress = ((NSNumber *)[self->_observed valueForKeyPath:keyPath]).floatValue;
        [self setProgress:progress animated:YES];
        if (progress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self setProgress:0.0f animated:NO];
            }];
        }
    }
}

@end
