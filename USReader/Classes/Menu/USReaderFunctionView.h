//
//  USReaderFunctionView.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <UIKit/UIKit.h>
#import "USReaderBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class USReaderFunctionView;
@protocol USReaderFunctionViewDelegate <NSObject>

- (void)functionViewClickMore:(USReaderFunctionView *)functionView;

@end

@class USReaderMenu;
@interface USReaderFunctionView : USReaderBaseView

@property (nonatomic, weak) id <USReaderFunctionViewDelegate>delegate;

- (instancetype)initWithMenu:(USReaderMenu *)menu;

@end

NS_ASSUME_NONNULL_END
