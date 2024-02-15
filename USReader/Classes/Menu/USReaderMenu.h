//
//  USReaderMenu.h
//  Masonry
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <Foundation/Foundation.h>
#import "USReaderMenuDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class USReaderController, USReaderContentView;
@interface USReaderMenu : NSObject

@property (nonatomic, weak) id <USReaderMenuDelegate>delegate;

/// 菜单显示状态
@property (nonatomic, assign, readonly) BOOL isMenuShow;

- (instancetype)initWithVC:(USReaderController *)readerController delegate:(id<USReaderMenuDelegate>)delegate;

- (void)dismiss;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
