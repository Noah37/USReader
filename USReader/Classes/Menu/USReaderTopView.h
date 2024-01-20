//
//  USReaderTopView.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define KNavigationHeight 44
#define KTopSafeAreaHeight [UIApplication sharedApplication].keyWindow.safeAreaInsets.top
#define KTopBarHeight ([UIApplication sharedApplication].keyWindow.safeAreaInsets.top + KNavigationHeight)

@class USReaderTopView;
@protocol USReaderTopViewDelegate <NSObject>

- (void)readerTopViewClickBack:(USReaderTopView *)readerTopView;
- (void)readerTopViewClickMore:(USReaderTopView *)readerTopView;

@end

@interface USReaderTopView : UIView

@property (nonatomic, weak) id <USReaderTopViewDelegate>delegate;

- (void)setTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
