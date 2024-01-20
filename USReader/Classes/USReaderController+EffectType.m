//
//  USReaderController+EffectType.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/4.
//

#import "USReaderController+EffectType.h"
#import "USReaderConfigure.h"
#import <Masonry/Masonry.h>
#import "USReaderTranslationViewController.h"
#import "USReaderPageCurlViewController.h"
#import "USReaderScrollViewController.h"
#import "USReaderNoneAnimationViewController.h"
#import "USReaderCoverStyleViewController.h"

@implementation USReaderController (EffectType)

/// 创建阅读视图
- (void)creatPageController:(USReaderViewController *)displayController {
    [self clearPageController];
    
    USEffectType effectType = [USReaderConfigure shared].effectTypeConfigure.effectType;
    UIViewController <USReaderProtocol>*viewController;
    if (effectType == USEffectTypeTranslation) {
        viewController = [self createTranslationViewController];
    } else if (effectType == USEffectTypeSimulation){
        viewController = [self createPageCurlViewController];
    } else if (effectType == USEffectTypeScroll) {
        viewController = [self createScrollViewController];
    } else if (effectType == USEffectTypeNone) {
        viewController = [self createNoneAnimationViewController];
    } else if (effectType == USEffectTypeCover) {
        viewController = [self createCoverViewController];
    }
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    [self.contentView insertSubview:viewController.view atIndex:0];
    [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewController.view.superview);
    }];
    [self setDisplayViewController:viewController];
}

- (UIViewController <USReaderProtocol>*)createTranslationViewController {
    USReaderTranslationViewController *viewController = [[USReaderTranslationViewController alloc] initWithReaderModel:self.readerModel];
    return viewController;
}

- (UIViewController <USReaderProtocol>*)createPageCurlViewController {
    USReaderPageCurlViewController *viewController = [[USReaderPageCurlViewController alloc] initWithReaderModel:self.readerModel];
    return viewController;
}

- (UIViewController <USReaderProtocol>*)createScrollViewController {
    USReaderScrollViewController *viewController = [[USReaderScrollViewController alloc] initWithReaderModel:self.readerModel];
    return viewController;
}

- (UIViewController <USReaderProtocol>*)createNoneAnimationViewController {
    USReaderNoneAnimationViewController *viewController = [[USReaderNoneAnimationViewController alloc] initWithReaderModel:self.readerModel];
    return viewController;
}

- (UIViewController <USReaderProtocol>*)createCoverViewController {
    USReaderCoverStyleViewController *viewController = [[USReaderCoverStyleViewController alloc] initWithReaderModel:self.readerModel];
    return viewController;
}

/// 清理所有阅读控制器
- (void)clearPageController {
    [self.displayViewController removeFromParentViewController];
    [self.displayViewController.view removeFromSuperview];
    [self setDisplayViewController:nil];
}

@end
