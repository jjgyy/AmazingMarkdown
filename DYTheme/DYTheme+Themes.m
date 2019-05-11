//
//  DYTheme+Themes.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/9.
//  Copyright © 2019 Young. All rights reserved.
//

#import "DYTheme+Themes.h"

@implementation DYTheme (Themes)

static NSArray<DYTheme *> * _themes;
+ (NSArray *)themes {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _themes = @[DYTheme.brightTheme, DYTheme.darkTheme];
    });
    return _themes;
}

static DYTheme * _brightTheme;
+ (DYTheme *)brightTheme {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _brightTheme = [DYTheme new];
        _brightTheme.themeName = NSLocalizedString(@"bright theme", nil);
        _brightTheme.navigationBarColor = HexColor(@"#f8f8f8");
        _brightTheme.navigationTintColor = UIColor.flatBlackColor;
        _brightTheme.placeholderColor = UIColor.flatGrayColor;
        _brightTheme.backgroundColor = UIColor.groupTableViewBackgroundColor;
        _brightTheme.separatorColor = UIColor.flatGrayColor;
        _brightTheme.sectionTitleColor = UIColor.grayColor;
        _brightTheme.cellColor = UIColor.whiteColor;
        _brightTheme.cellTitleColor = UIColor.blackColor;
        _brightTheme.cellSelectedColor = HexColor(@"#dddddd");
        _brightTheme.cssStyleString = @"";
        _brightTheme.textColor = UIColor.blackColor;
        _brightTheme.textBackgroundColor = UIColor.groupTableViewBackgroundColor;
    });
    return _brightTheme;
}

static DYTheme * _darkTheme;
+ (DYTheme *)darkTheme {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _darkTheme = [DYTheme new];
        _darkTheme.themeName = NSLocalizedString(@"dark theme", nil);
        _darkTheme.navigationBarColor = HexColor(@"#303030");
        _darkTheme.navigationTintColor = UIColor.whiteColor;
        _darkTheme.placeholderColor = UIColor.flatWhiteColorDark;
        _darkTheme.backgroundColor = HexColor(@"#333333");
        _darkTheme.separatorColor = HexColor(@"#666666");
        _darkTheme.sectionTitleColor = UIColor.flatWhiteColorDark;
        _darkTheme.cellColor = HexColor(@"#3c3c3c");
        _darkTheme.cellTitleColor = UIColor.whiteColor;
        _darkTheme.cellSelectedColor = UIColor.flatBlackColorDark;
        _darkTheme.cssStyleString = @"<style>body{background-color:#3c3c3c;color:#ffffff;}</style>";
        _darkTheme.textColor = UIColor.whiteColor;
        _darkTheme.textBackgroundColor = HexColor(@"#3c3c3c");
    });
    return _darkTheme;
}

@end
