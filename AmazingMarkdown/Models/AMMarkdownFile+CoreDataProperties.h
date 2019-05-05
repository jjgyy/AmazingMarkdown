//
//  AMMarkdownFile+CoreDataProperties.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/5.
//  Copyright © 2019 Young. All rights reserved.
//
//

#import "AMMarkdownFile+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AMMarkdownFile (CoreDataProperties)

+ (NSFetchRequest<AMMarkdownFile *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *category;
@property (nullable, nonatomic, copy) NSString *tag;
@property (nonatomic) BOOL isHidden;
@property (nonatomic) BOOL isRecycled;
@property (nonatomic) BOOL isLocked;

@end

NS_ASSUME_NONNULL_END
