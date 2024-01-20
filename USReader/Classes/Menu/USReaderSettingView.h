//
//  USReaderSettingView.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <UIKit/UIKit.h>
#import "USReaderBaseView.h"

NS_ASSUME_NONNULL_BEGIN

#define KTabBarHeight 49
#define KBottomSafeAreaHeight [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom
#define kReaderSettingHeight (KTabBarHeight + KBottomSafeAreaHeight)

@interface USReaderSettingView : USReaderBaseView

@end

NS_ASSUME_NONNULL_END
