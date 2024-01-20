//
//  USReaderBaseView.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <UIKit/UIKit.h>
#import "USReaderMenu.h"
#import "USConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderBaseView : UIView

@property (nonatomic, strong, readonly) USReaderMenu *readerMenu;

- (instancetype)initWithMenu:(USReaderMenu *)menu;

- (void)setupSubviews;

- (void)afterDismiss;

@end

NS_ASSUME_NONNULL_END
