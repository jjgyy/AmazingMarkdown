//
//  AMCollationSettingTableController.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/13.
//  Copyright © 2019 Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMThemeTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const AMCollationSettingCollationKeyIndexUserDefaultsKey;
extern NSString * const AMCollationSettingIsAscendingOrderUserDefaultsKey;

extern NSString * const AMCollationSettingDidChangeNotificationName;

@interface AMCollationSettingTableController : AMThemeTableViewController

@property (class, nonatomic, readonly) NSArray<NSString *> * collationKeys;

@end

NS_ASSUME_NONNULL_END
