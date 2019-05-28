//
//  AMMarkdownFolder+CoreDataProperties.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/26.
//  Copyright © 2019 Young. All rights reserved.
//
//

#import "AMMarkdownFolder+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AMMarkdownFolder (CoreDataProperties)

+ (NSFetchRequest<AMMarkdownFolder *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *creationDate;
@property (nullable, nonatomic, copy) NSDate *modifiedDate;
@property (nonatomic) BOOL isRecycled;
@property (nonatomic) BOOL isHidden;
@property (nonatomic) BOOL isLocked;
@property (nullable, nonatomic, copy) NSString *intro;
@property (nonatomic) int16_t fileNumber;

@end

NS_ASSUME_NONNULL_END
