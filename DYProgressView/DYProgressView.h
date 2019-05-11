//
//  DYProgressView.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/11.
//  Copyright © 2019 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYProgressView : UIProgressView

- (instancetype)initWithFrame:(CGRect)frame observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)object;

+ (instancetype)progressViewWithFrame:(CGRect)frame observeValueForKeyPath:(NSString *)keyPath ofObject:(NSObject *)object;

@end

NS_ASSUME_NONNULL_END
