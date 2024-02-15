//
//  USReaderMenuDelegate.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <Foundation/Foundation.h>
#import "USReaderBGType.h"

NS_ASSUME_NONNULL_BEGIN

@class USReaderMenu, USReaderTopView;
@protocol USReaderMenuDelegate <NSObject>

/// 菜单将要显示
- (void)readMenuWillDisplay:(USReaderMenu *)readMenu;
/// 菜单完成显示
- (void)readMenuDidDisplay:(USReaderMenu *)readMenu;
/// 菜单将要隐藏
- (void)readMenuWillEndDisplay:(USReaderMenu *)readMenu;
/// 菜单完成隐藏
- (void)readMenuDidEndDisplay:(USReaderMenu *)readMenu;
/// 点击返回
- (void)readMenuClickBack:(USReaderMenu *)readMenu;
/// 点击更多
- (void)readMenuClickMore:(USReaderMenu *)readMenu;
/// 点击书签
- (void)readMenuClickMark:(USReaderMenu *)readMenu topView:(USReaderTopView *)topView markButton:(UIButton *)markButton;
/// 点击目录
- (void)readMenuClickCatalogue:(USReaderMenu *)readMenu ;
/// 点击切换日夜间
- (void)readMenuClickDayAndNight:(USReaderMenu *)readMenu;
/// 点击设置
- (void)readMenuClickSetting:(USReaderMenu *)readMenu;
/// 点击评论
- (void)readMenuClickComment:(USReaderMenu *)readMenu;
/// 点击上一章
- (void)readMenuClickPreviousChapter:(USReaderMenu *)readMenu;
/// 点击下一章
- (void)readMenuClickNextChapter:(USReaderMenu *)readMenu;
/// 拖拽章节进度(分页进度)
- (void)readMenuDraggingProgress:(USReaderMenu *)readMenu toPage:(NSInteger)toPage;
/// 拖拽章节进度(总文章进度,网络文章也可以使用)
- (void)readMenuDraggingProgress:(USReaderMenu *)readMenu toChapterID:(NSNumber *)toChapterID  toPage:(NSInteger)toPage;
/// 点击切换背景颜色
- (void)readMenuClickBGColor:(USReaderMenu *)readMenu bgType:(USReaderBGType *)bgType;
/// 点击切换字体
- (void)readMenuClickFont:(USReaderMenu *)readMenu;
/// 点击切换字体大小
- (void)readMenuClickFontSize:(USReaderMenu *)readMenu;
/// 点击切换字体大小
- (void)readMenuClickFontSizeAdd:(USReaderMenu *)readMenu;
/// 点击切换字体大小
- (void)readMenuClickFontSizePlus:(USReaderMenu *)readMenu;
/// 切换进度显示(分页 || 总进度)
- (void)readMenuClickDisplayProgress:(USReaderMenu *)readMenu;
/// 点击切换间距
- (void)readMenuClickSpacing:(USReaderMenu *)readMenu;
/// 点击切换翻页效果
- (void)readMenuClickEffect:(USReaderMenu *)readMenu;

/// 点击亮度减
- (void)readMenuClickPreviousLight:(USReaderMenu *)readMenu;
/// 点击亮度加
- (void)readMenuClickNextLight:(USReaderMenu *)readMenu;
/// 拖拽亮度
- (void)readMenuDraggingLight:(USReaderMenu *)readMenu light:(CGFloat)light;

@end

NS_ASSUME_NONNULL_END
