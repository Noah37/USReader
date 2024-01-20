//
//  USReaderSystemFontView.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/5.
//

#import "USReaderSystemFontView.h"
#import <Masonry/Masonry.h>
#import "USConstants.h"
#import "USReaderConfigure.h"

@interface USReaderSystemFontCell : UITableViewCell


@end

@implementation USReaderSystemFontCell


@end

@interface USReaderSystemFontView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray <USReaderFontFile *>* customFonts;

@end

@implementation USReaderSystemFontView

- (void)setupSubviews {
    [super setupSubviews];
    self.customFonts = [USReaderConfigure shared].customFontFiles;
    self.backgroundColor = [UIColor blackColor];
    self.tableView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.tableView.superview);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customFonts.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    USReaderSystemFontCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USReaderSystemFontCell class]) forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    USReaderFontFile *customFont = [USReaderConfigure shared].customFont;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"系统字体";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        if (!customFont) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        USReaderFontFile *file = self.customFonts[indexPath.row - 1];
        if (customFont && [file.name isEqualToString:customFont.name]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.font = [UIFont fontWithName:file.fontName size:15];
        cell.textLabel.text = file.name;
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [USReaderConfigure shared].customFont = nil;
    } else {
        USReaderFontFile *file = self.customFonts[indexPath.row - 1];
        [USReaderConfigure shared].customFont = file;
    }
    [self.tableView reloadData];
    if ([self.delegate respondsToSelector:@selector(systemFontViewClickCustomFont:)]) {
        [self.delegate systemFontViewClickCustomFont:self];
    }
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_tableView registerClass:[USReaderSystemFontCell class] forCellReuseIdentifier:NSStringFromClass([USReaderSystemFontCell class])];
    }
    return _tableView;
}


@end
