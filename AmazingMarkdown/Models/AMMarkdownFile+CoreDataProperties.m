//
//  AMMarkdownFile+CoreDataProperties.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/5.
//  Copyright © 2019 Young. All rights reserved.
//
//

#import "AMMarkdownFile+CoreDataProperties.h"

@implementation AMMarkdownFile (CoreDataProperties)

+ (NSFetchRequest<AMMarkdownFile *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"AMMarkdownFile"];
}

@dynamic title;
@dynamic content;
@dynamic date;
@dynamic category;
@dynamic tag;
@dynamic isHidden;
@dynamic isRecycled;
@dynamic isLocked;

@end
