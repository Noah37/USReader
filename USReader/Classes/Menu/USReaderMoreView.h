//
//  USReaderMoreView.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderBaseView.h"
#import "USReaderLightView.h"
#import "USReaderFontSizeView.h"
#import "USReaderBGView.h"
#import "USReaderSettingView.h"

NS_ASSUME_NONNULL_BEGIN

#define kReaderMoreHeight (kReaderSettingHeight + kReaderBGHeight + kReaderFontSizeHeight + kReaderLightHeight + 30*4)

@interface USReaderMoreView : USReaderBaseView

@end

NS_ASSUME_NONNULL_END
