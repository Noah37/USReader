//
//  USReaderController+ReaderMenu.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderController+ReaderMenu.h"
#import "USReaderCatalogViewController.h"
#import "USReaderAnimationStyleViewController.h"
#import "USReaderConfigure.h"
#import "USReaderAudioPlayer.h"

@implementation USReaderController (ReaderMenu)

/// 菜单将要显示
- (void)readMenuWillDisplay:(USReaderMenu *)readMenu {
    
}
 
/// 菜单完成显示
- (void)readMenuDidDisplay:(USReaderMenu *)readMenu {
    
}

/// 菜单将要隐藏
- (void)readMenuWillEndDisplay:(USReaderMenu *)readMenu {
    
}

/// 菜单完成隐藏
- (void)readMenuDidEndDisplay:(USReaderMenu *)readMenu {
    
}

/// 点击返回
- (void)readMenuClickBack:(USReaderMenu *)readMenu {
    // 弹窗提醒，可选择删除缓存
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [self.readerModel deleteRead];
        [[USReaderAudioPlayer sharedPlayer] stop];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [[USReaderAudioPlayer sharedPlayer] stop];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [controller addAction:deleteAction];
    [controller addAction:cancelAction];
    [self presentViewController:controller animated:YES completion:nil];
}

/// 点击书签
- (void)readMenuClickMark:(USReaderMenu *)readMenu topView:(USReaderTopView *)topView markButton:(UIButton *)markButton {
    
}

/// 点击目录
- (void)readMenuClickCatalogue:(USReaderMenu *)readMenu {
    USReaderCatalogViewController *catalogVC = [[USReaderCatalogViewController alloc] initWithReaderModel:self.readerModel recordModel:self.displayViewController.recordModel];
    __weak typeof(self)weakSelf = self;
    catalogVC.didSelectRow = ^(NSNumber * _Nonnull idString) {
        [weakSelf.displayViewController toChapter:idString.integerValue];
    };
    [self.navigationController pushViewController:catalogVC animated:YES];
    [self.readerMenu dismiss];
}

/// 点击切换日夜间
- (void)readMenuClickDayAndNight:(USReaderMenu *)readMenu {
    
}

/// 点击上一章
- (void)readMenuClickPreviousChapter:(USReaderMenu *)readMenu {
    [self.displayViewController lastChapter];
}

/// 点击下一章
- (void)readMenuClickNextChapter:(USReaderMenu *)readMenu {
    [self.displayViewController nextChapter];
}

/// 拖拽章节进度(分页进度)
- (void)readMenuDraggingProgress:(USReaderMenu *)readMenu toPage:(NSInteger)toPage {
    
}

/// 拖拽章节进度(总文章进度,网络文章也可以使用)
- (void)readMenuDraggingProgress:(USReaderMenu *)readMenu toChapterID:(NSNumber *)toChapterID  toPage:(NSInteger)toPage {
    
}

/// 点击切换背景颜色
- (void)readMenuClickBGColor:(USReaderMenu *)readMenu bgType:(nonnull USReaderBGType*)bgType {
    /// 改变背景图片，并且需要刷新文案颜色
    [USReaderConfigure shared].selectedBgType = bgType;
    [self.displayViewController changeToBgImage:bgType.bgImage];
    [self.displayViewController reloadData];
}

/// 点击切换字体
- (void)readMenuClickFont:(USReaderMenu *)readMenu {
    [self.displayViewController reloadData];
}

/// 点击切换字体大小
- (void)readMenuClickFontSize:(USReaderMenu *)readMenu {
    
}

/// 切换进度显示(分页 || 总进度)
- (void)readMenuClickDisplayProgress:(USReaderMenu *)readMenu {
    
}

/// 点击切换间距
- (void)readMenuClickSpacing:(USReaderMenu *)readMenu {
    
}

/// 点击切换翻页效果
- (void)readMenuClickEffect:(USReaderMenu *)readMenu {
    USReaderAnimationStyleViewController *styleVC = [[USReaderAnimationStyleViewController alloc] init];
    __weak typeof(self)weakSelf = self;
    styleVC.didSelectRow = ^(NSIndexPath * _Nonnull indexPath, USReaderEffectTypeConfigure *configure) {
        [USReaderConfigure shared].effectTypeConfigure.effectType = configure.effectType;
        [self switchToEffectType:configure.effectType];
    };
    [self.navigationController pushViewController:styleVC animated:YES];
    [self.readerMenu dismiss];
}

/// 点击设置
- (void)readMenuClickSetting:(USReaderMenu *)readMenu {
    
}

/// 点击评论
- (void)readMenuClickComment:(USReaderMenu *)readMenu {
    
}

/// 点击亮度减
- (void)readMenuClickPreviousLight:(USReaderMenu *)readMenu {
    
}

/// 点击亮度加
- (void)readMenuClickNextLight:(USReaderMenu *)readMenu {
    
}

/// 拖拽亮度
- (void)readMenuDraggingLight:(USReaderMenu *)readMenu light:(CGFloat)light {
    [[USReaderConfigure shared] changeLight:light];
    [self reloadData];
}

/// 点击切换字体大小
- (void)readMenuClickFontSizeAdd:(USReaderMenu *)readMenu {
    [[USReaderConfigure shared] fontPlus];
    [self.displayViewController reloadData];
}

/// 点击切换字体大小
- (void)readMenuClickFontSizePlus:(USReaderMenu *)readMenu {
    [[USReaderConfigure shared] fontMinus];
    [self.displayViewController reloadData];
}

@end
