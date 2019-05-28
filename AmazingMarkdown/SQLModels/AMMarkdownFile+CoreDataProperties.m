//
//  AMMarkdownFile+CoreDataProperties.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/8.
//  Copyright © 2019 Young. All rights reserved.
//
//

#import "AMMarkdownFile+CoreDataProperties.h"

@implementation AMMarkdownFile (CoreDataProperties)

+ (NSFetchRequest<AMMarkdownFile *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"AMMarkdownFile"];
}

@dynamic folder;
@dynamic content;
@dynamic creationDate;
@dynamic isHidden;
@dynamic isLocked;
@dynamic isRecycled;
@dynamic tag;
@dynamic title;
@dynamic modifiedDate;
@dynamic summary;
@dynamic viewingDate;

@end
