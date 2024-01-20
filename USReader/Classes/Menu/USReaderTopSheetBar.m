//
//  USReaderTopSheetBar.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/7.
//

#import "USReaderTopSheetBar.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>

@implementation USReaderTopSheetBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _indicatorView = [[UIView alloc] init];
        [self addSubview:_indicatorView];
        _indicatorView.backgroundColor = [UIColor colorWithHexString:@"0xBDBDBD"];
        _indicatorView.layer.cornerRadius = 1.5;
        [_indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(3);
            make.width.mas_equalTo(31);
            make.top.inset(6);
            make.bottom.inset(3);
            make.centerX.mas_offset(0);
        }];
    }
    return self;
}

@end
