//
//  USReaderSpeakersViewController.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/7.
//

#import "USReaderSpeakersViewController.h"
#import "USReaderSpeechConfig.h"
#import "USConstants.h"
#import "USReaderSpeakersCell.h"
#import <Masonry/Masonry.h>
#import "USReaderTopSheetBar.h"
#import "USReaderSpeakersHeaderView.h"

@interface USReaderSpeakersViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) USReaderTopSheetBar *sheetBar;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation USReaderSpeakersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.sheetBar];
    [self.sheetBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.sheetBar.superview);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.inset(16);
        make.top.equalTo(self.sheetBar.mas_bottom).offset(10);
    }];
}

#pragma mark - collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return [USReaderSpeechConfig sharedConfig].cloudSpeakers.count;
    }
    return [USReaderSpeechConfig sharedConfig].offlineSpeakers.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    USReaderSpeakersCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([USReaderSpeakersCell class]) forIndexPath:indexPath];
    USReaderSpeaker *currentSpeaker = [[USReaderSpeechConfig sharedConfig] currentSpeaker];
    if (indexPath.section == 0) {
        USReaderSpeaker *speaker = [USReaderSpeechConfig sharedConfig].cloudSpeakers[indexPath.item];
        [cell setSpeaker:speaker];
        [cell setCellSelected:[currentSpeaker.name isEqualToString:speaker.name]];
    } else {
        USReaderSpeaker *speaker = [USReaderSpeechConfig sharedConfig].offlineSpeakers[indexPath.item];
        [cell setSpeaker:speaker];
        [cell setCellSelected:[currentSpeaker.name isEqualToString:speaker.name]];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        USReaderSpeakersHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([USReaderSpeakersHeaderView class]) forIndexPath:indexPath];
        if (indexPath.section == 0) {
            USReaderSpeaker *speaker = [USReaderSpeechConfig sharedConfig].cloudSpeakers[indexPath.item];
            headerView.titleLabel.attributedText = speaker.engineHeaderName;
        } else {
            USReaderSpeaker *speaker = [USReaderSpeechConfig sharedConfig].offlineSpeakers[indexPath.item];
            headerView.titleLabel.attributedText = speaker.engineHeaderName;
        }
        return headerView;
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
        return footerView;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:nil];
    USReaderSpeaker *speaker;
    if (indexPath.section == 0) {
        speaker = [USReaderSpeechConfig sharedConfig].cloudSpeakers[indexPath.item];
    } else {
        speaker = [USReaderSpeechConfig sharedConfig].offlineSpeakers[indexPath.item];
    }
    if (self.speakerChanged) {
        self.speakerChanged(speaker);
    }
}

#pragma mark - getter
- (USReaderTopSheetBar *)sheetBar {
    if (!_sheetBar) {
        _sheetBar = [[USReaderTopSheetBar alloc] init];
    }
    return _sheetBar;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((kScreenWidth - 16*3)/2, 50);
        flowLayout.minimumInteritemSpacing = 16;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth - 32, 40);
        flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth - 32, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[USReaderSpeakersCell class] forCellWithReuseIdentifier:NSStringFromClass([USReaderSpeakersCell class])];
        [_collectionView registerClass:[USReaderSpeakersHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([USReaderSpeakersHeaderView class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];

        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

@end
