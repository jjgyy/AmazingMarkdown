//
//  AppDelegate.h
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/26.
//  Copyright © 2019 Young. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

