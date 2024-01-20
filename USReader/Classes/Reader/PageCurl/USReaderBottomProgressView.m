//
//  USReaderBottomProgressView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import "USReaderBottomProgressView.h"
#import "USReaderConfigure.h"
#import <Masonry/Masonry.h>
#import "USConstants.h"

@interface USReaderBottomProgressView ()

@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) USReaderRecordModel *recordModel;


@end

@implementation USReaderBottomProgressView

- (instancetype)initWithRecordModel:(USReaderRecordModel *)recordModel {
    self = [super init];
    if (self) {
        self.recordModel = recordModel;
        [self addSubview:self.pageLabel];
        [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.pageLabel.superview);
        }];
        self.pageLabel.text = [NSString stringWithFormat:@"%@/%@", self.recordModel.showPageNum, self.recordModel.chapterModel.pageCount];
    }
    return self;
}

- (void)reloadData:(USReaderRecordModel *)recordModel {
    self.pageLabel.text = [NSString stringWithFormat:@"%@/%@", self.recordModel.showPageNum, self.recordModel.chapterModel.pageCount];
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] init];
        _pageLabel.font = [UIFont systemFontOfSize:13];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.textColor = [USReaderConfigure shared].textColor;
        _pageLabel.text = @"-/-";
    }
    return _pageLabel;
}

@end
