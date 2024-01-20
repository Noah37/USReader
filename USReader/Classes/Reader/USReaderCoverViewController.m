//
//  USReaderCoverViewController.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import "USReaderCoverViewController.h"
#import <Masonry/Masonry.h>
#import "USReaderConfigure.h"
#import "USConstants.h"
#import "USReaderCoverView.h"

@interface USReaderCoverViewController ()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) USReaderCoverView *coverView;

@property (nonatomic, strong) USReaderChapterModel *chapterModel;

@property (nonatomic, strong) USReaderRecordModel *recordModel;

@end

@implementation USReaderCoverViewController

- (instancetype)initWithRecordModel:(USReaderRecordModel *)recordModel {
    self = [super init];
    if (self) {
        self.recordModel = recordModel;
        self.chapterModel = recordModel.chapterModel;
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
    
    [self.view addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.coverView.superview);
    }];
    
    self.coverView.avatarView.image = self.chapterModel.avatar;
    self.coverView.titleLabel.text = self.chapterModel.name;
    self.coverView.authorLabel.text = self.chapterModel.author;
    self.coverView.catalogLabel.text = self.chapterModel.catalog;
    self.coverView.descLabel.text = self.chapterModel.bookDesc;

}

- (void)changeToBgImage:(UIImage *)image {
    self.bgImageView.image = image;
}

- (USReaderCoverView *)coverView {
    if (!_coverView) {
        _coverView = [[USReaderCoverView alloc] init];
    }
    return _coverView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

@end
