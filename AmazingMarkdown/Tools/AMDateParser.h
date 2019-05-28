//
//  AMDateParser.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMDateParser : NSObject

+ (NSString *)dateStringForFileTableCellWithDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
