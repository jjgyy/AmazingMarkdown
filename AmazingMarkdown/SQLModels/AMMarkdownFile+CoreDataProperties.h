//
//  AMMarkdownFile+CoreDataProperties.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/8.
//  Copyright © 2019 Young. All rights reserved.
//
//

#import "AMMarkdownFile+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AMMarkdownFile (CoreDataProperties)

+ (NSFetchRequest<AMMarkdownFile *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *category;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *creationDate;
@property (nonatomic) BOOL isHidden;
@property (nonatomic) BOOL isLocked;
@property (nonatomic) BOOL isRecycled;
@property (nullable, nonatomic, copy) NSString *tag;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSDate *modifiedDate;
@property (nullable, nonatomic, copy) NSString *summary;
@property (nullable, nonatomic, copy) NSDate *viewingDate;

@end

NS_ASSUME_NONNULL_END
