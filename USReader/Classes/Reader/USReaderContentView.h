//
//  USReaderContentView.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class USReaderContentView;
@protocol USReaderContentViewDelegate <NSObject>

- (void)contentViewClickCover:(USReaderContentView *)contentView;

@end

@interface USReaderContentView : UIView

@property (nonatomic, weak) id <USReaderContentViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
