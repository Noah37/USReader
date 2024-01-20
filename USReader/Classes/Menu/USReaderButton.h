//
//  USReaderButton.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface USReaderButton : UIControl

@property(nonatomic,strong) UIColor *tintColor;

+ (instancetype)buttonWithType:(UIButtonType)buttonType;

- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state;
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state;                      

@end

NS_ASSUME_NONNULL_END
