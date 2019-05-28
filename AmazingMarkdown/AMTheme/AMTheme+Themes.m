//
//  AMTheme+Themes.m
//  AmazingMarkdown
//
//  Created by Apple on 2019/5/9.
//  Copyright © 2019 Young. All rights reserved.
//

#import "AMTheme+Themes.h"

@implementation AMTheme (Themes)

static NSArray<AMTheme *> * _themes;
+ (NSArray *)themes {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _themes = @[AMTheme.brightTheme, AMTheme.darkTheme];
    });
    return _themes;
}

static AMTheme * _brightTheme;
+ (AMTheme *)brightTheme {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _brightTheme = [AMTheme new];
        _brightTheme.themeName = NSLocalizedString(@"bright theme", nil);
        
        _brightTheme.navigationBarColor = HexColor(@"#f8f8f8");
        _brightTheme.navigationTintColor = UIColor.flatBlackColor;
        
        _brightTheme.backgroundColor = UIColor.groupTableViewBackgroundColor;
        _brightTheme.backgroundNoticeColor = HexColor(@"#d0d0d0");
        
        _brightTheme.sectionTitleColor = UIColor.grayColor;
        _brightTheme.separatorColor = UIColor.flatGrayColor;
        _brightTheme.cellColor = UIColor.whiteColor;
        _brightTheme.cellSelectedColor = HexColor(@"#dddddd");
        _brightTheme.cellTitleColor = UIColor.blackColor;
        _brightTheme.cellTitleSpecialColor = UIColor.flatBlueColor;
        
        _brightTheme.placeholderColor = UIColor.flatGrayColor;
        _brightTheme.textColor = UIColor.blackColor;
        _brightTheme.textBackgroundColor = UIColor.groupTableViewBackgroundColor;
        
        _brightTheme.cssStyleString = @"";
    });
    return _brightTheme;
}

static AMTheme * _darkTheme;
+ (AMTheme *)darkTheme {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _darkTheme = [AMTheme new];
        _darkTheme.themeName = NSLocalizedString(@"dark theme", nil);
        
        _darkTheme.navigationBarColor = HexColor(@"#303030");
        _darkTheme.navigationTintColor = UIColor.whiteColor;
        
        _darkTheme.backgroundColor = HexColor(@"#333333");
        _darkTheme.backgroundNoticeColor = UIColor.darkGrayColor;
        
        _darkTheme.sectionTitleColor = UIColor.flatWhiteColorDark;
        _darkTheme.separatorColor = HexColor(@"#666666");
        _darkTheme.cellColor = HexColor(@"#3c3c3c");
        _darkTheme.cellTitleColor = UIColor.whiteColor;
        _darkTheme.cellSelectedColor = UIColor.flatBlackColorDark;
        _darkTheme.cellTitleSpecialColor = UIColor.flatPowderBlueColor;
        
        _darkTheme.placeholderColor = UIColor.flatWhiteColorDark;
        _darkTheme.textColor = UIColor.whiteColor;
        _darkTheme.textBackgroundColor = HexColor(@"#3c3c3c");
        
        _darkTheme.cssStyleString = @"<style>body{background-color:#3c3c3c;color:#ffffff;}</style>";
    });
    return _darkTheme;
}

@end
