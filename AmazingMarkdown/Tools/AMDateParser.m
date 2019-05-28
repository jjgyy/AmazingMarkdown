//
//  AMDateParser.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/27.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMDateParser.h"

@implementation AMDateParser

static NSDateFormatter * _yearMonthDayFormatter;
static NSDateFormatter * _24HoursFormatter;

+ (void)initialize {
    _yearMonthDayFormatter = [NSDateFormatter new];
    [_yearMonthDayFormatter setDateFormat:@"yyyy/M/d"];
    _24HoursFormatter = [NSDateFormatter new];
    [_24HoursFormatter setDateFormat:@"H:mm"];
}

+ (NSString *)dateStringForFileTableCellWithDate:(NSDate *)date {
    NSString * today = [_yearMonthDayFormatter stringFromDate:[NSDate new]];
    NSString * oneday = [_yearMonthDayFormatter stringFromDate:date];
    if ([today isEqualToString:oneday]) {
        return [_24HoursFormatter stringFromDate:date];
    } else {
        return oneday;
    }
}

@end
