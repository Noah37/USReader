//
//  USReaderCoverCell.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import "USReaderCoverCell.h"
#import <Masonry/Masonry.h>

@interface USReaderCoverCell ()

@property (nonatomic, strong) USReaderCoverView *coverView;

@end

@implementation USReaderCoverCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.coverView];
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.coverView.superview);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (USReaderCoverView *)coverView {
    if (!_coverView) {
        _coverView = [[USReaderCoverView alloc] init];
    }
    return _coverView;
}

@end
