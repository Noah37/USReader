//
//  USReaderSystemFontView.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/5.
//

#import <UIKit/UIKit.h>
#import "USReaderBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class USReaderSystemFontView;
@protocol USReaderSystemFontViewDelegate <NSObject>

@optional
- (void)systemFontViewClickCustomFont:(USReaderSystemFontView *)fontSizeView;

@end

@interface USReaderSystemFontView : USReaderBaseView

@property (nonatomic, weak) id <USReaderSystemFontViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
