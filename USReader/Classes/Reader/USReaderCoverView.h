//
//  USReaderCoverView.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface USReaderCoverView : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *authorLabel;
@property (nonatomic, strong, readonly) UILabel *catalogLabel;
@property (nonatomic, strong, readonly) UILabel *descLabel;

@property (nonatomic, strong, readonly) UIImageView *avatarView;

@end

NS_ASSUME_NONNULL_END
