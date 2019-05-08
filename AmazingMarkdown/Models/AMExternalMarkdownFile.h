//
//  AMExternalMarkdownFile.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/6.
//  Copyright © 2019 Young. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMExternalMarkdownFile : NSObject

@property (nonatomic, strong) NSString * fileName;
@property (nonatomic, strong) NSData * fileData;

- (instancetype)initWithFileName:(NSString *)name fileData:(NSData *)data;

+ (instancetype)fileWithFileName:(NSString *)name fileData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
