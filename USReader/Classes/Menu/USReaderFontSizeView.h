//
//  USReaderFontSizeView.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <UIKit/UIKit.h>
#import "USReaderBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class USReaderFontSizeView;
@protocol USReaderFontSizeViewDelegate <NSObject>

@optional
- (void)fontSizeViewClickPrevious:(USReaderFontSizeView *)fontSizeView;
- (void)fontSizeViewClickNext:(USReaderFontSizeView *)fontSizeView;
- (void)fontSizeViewClickSystem:(USReaderFontSizeView *)fontSizeView;

@end

#define kReaderFontSizeHeight 30

@interface USReaderFontSizeView : USReaderBaseView

@property (nonatomic, weak) id <USReaderFontSizeViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
