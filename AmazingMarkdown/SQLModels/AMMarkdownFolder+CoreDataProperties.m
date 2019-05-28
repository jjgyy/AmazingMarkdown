//
//  AMMarkdownFolder+CoreDataProperties.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/26.
//  Copyright © 2019 Young. All rights reserved.
//
//

#import "AMMarkdownFolder+CoreDataProperties.h"

@implementation AMMarkdownFolder (CoreDataProperties)

+ (NSFetchRequest<AMMarkdownFolder *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"AMMarkdownFolder"];
}

@dynamic name;
@dynamic creationDate;
@dynamic modifiedDate;
@dynamic isRecycled;
@dynamic isHidden;
@dynamic isLocked;
@dynamic intro;
@dynamic fileNumber;

@end
