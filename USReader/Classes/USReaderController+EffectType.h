//
//  USReaderController+EffectType.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/4.
//

#import "USReaderController.h"
#import "USReaderViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderController (EffectType)

/// 创建阅读视图
- (void)creatPageController:(USReaderViewController * _Nullable)displayController;

@end

NS_ASSUME_NONNULL_END
