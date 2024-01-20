//
//  USReaderViewController.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderViewController.h"
#import "USReaderView.h"
#import <Masonry/Masonry.h>
#import "USConstants.h"
#import "USReaderConfigure.h"
#import "USReaderBottomProgressView.h"

@interface USReaderViewController ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) USReaderView *readerView;

@property (nonatomic, strong) USReaderRecordModel *recordModel;

@property (nonatomic, strong) USReaderBottomProgressView *bottomView;

@end

@implementation USReaderViewController

- (instancetype)initWithRecordModel:(USReaderRecordModel *)recordModel {
    self = [super init];
    if (self) {
        self.recordModel = recordModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgImageView.superview);
    }];
    
    [self.view addSubview:self.readerView];
    [self.readerView mas_makeConstraints:^(MASConstraintMaker *make) {
        [USConstants safeAreaInsets];
        make.edges.insets(US_READER_INSETS);
    }];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.readerView.mas_bottom);
    }];
    
    [self setContent:self.recordModel.contentAttributedString];
}

- (void)setContent:(NSAttributedString *)content {
    [self.readerView setContent:content];
}

- (void)changeToBgImage:(UIImage *)image {
    self.bgImageView.image = image;
}

#pragma mark - getter
- (USReaderView *)readerView {
    if (!_readerView) {
        _readerView = [[USReaderView alloc] init];
    }
    return _readerView;
}

- (USReaderBottomProgressView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[USReaderBottomProgressView alloc] initWithRecordModel:self.recordModel];
    }
    return _bottomView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

@end
