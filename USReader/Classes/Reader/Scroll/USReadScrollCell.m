//
//  CloudreveReadCell.m
//  CloudreveReader
//
//  Created by nongyun.cao on 2023/12/1.
//

#import "USReadScrollCell.h"
#import "USConstants.h"
#import <Masonry/Masonry.h>

@interface USReadScrollCell ()

@property (nonatomic, strong) USReaderView *readView;

@end

@implementation USReadScrollCell
  
- (void)setPageModel:(USReaderPageModel *)pageModel {
    _pageModel = pageModel;
    [self.readView setContent:pageModel.showContent];
    [self.readView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.readView.superview);
        make.top.inset(pageModel.headTypeHeight);
    }];
}

+ (USReadScrollCell *)cellFor:(UITableView *)tableView {
    USReadScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USReadScrollCell"];
    if (cell == nil) {
        cell = [[USReadScrollCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"USReadScrollCell"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
    }
    return self;
}
  
- (void)setupSubviews {
    self.readView = [[USReaderView alloc] init];
    [self.contentView addSubview:self.readView];
//    [self.readView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.readView.superview);
//    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat y = self.pageModel.headTypeHeight;
    CGFloat H = self.pageModel.contentSize.height;
    
    self.readView.frame = CGRectMake(0, 0, US_READERRECT.size.width, H);
}

@end
