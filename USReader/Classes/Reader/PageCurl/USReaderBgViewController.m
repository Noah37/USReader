//
//  USReaderBgViewController.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/6.
//

#import "USReaderBgViewController.h"
#import <Masonry/Masonry.h>
#import "USReaderView.h"
#import "USConstants.h"

@interface USReaderBgViewController ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) USReaderView *readerView;
@property (nonatomic, strong) USReaderRecordModel *recordModel;

@end

@implementation USReaderBgViewController

- (instancetype)initWithRecordModel:(USReaderRecordModel *)recordModel {
    self = [super init];
    if (self) {
        self.recordModel = recordModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgImageView.superview);
    }];
    
    self.readerView.transform = CGAffineTransformMakeScale(-1, 1);
    [self.view addSubview:self.readerView];
    [self.readerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(US_READER_INSETS);
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setContent:self.recordModel.contentAttributedString];
}

- (void)setContent:(NSAttributedString *)content {
    [self.readerView setContent:content];
}

- (void)changeToBgImage:(UIImage *)image {
    self.bgImageView.image = image;
}

- (USReaderView *)readerView {
    if (!_readerView) {
        _readerView = [[USReaderView alloc] init];
    }
    return _readerView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

@end
