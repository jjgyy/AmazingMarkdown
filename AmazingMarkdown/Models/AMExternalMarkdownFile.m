//
//  AMExternalMarkdownFile.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/6.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMExternalMarkdownFile.h"

@implementation AMExternalMarkdownFile

@synthesize fileName = _fileName;
@synthesize fileData = _fileData;

- (instancetype)initWithFileName:(NSString *)name fileData:(NSData *)data {
    if (self = [super init]) {
        for (NSUInteger index = name.length - 1; index >= 0; --index) {
            if ([name characterAtIndex:index] == '.') {
                name = [name substringToIndex:index];
                break;
            }
        }
        self->_fileName = name;
        self->_fileData = data;
    }
    return self;
}

+ (instancetype)fileWithFileName:(NSString *)name fileData:(NSData *)data {
    return [[AMExternalMarkdownFile alloc] initWithFileName:name fileData:data];
}

@end
