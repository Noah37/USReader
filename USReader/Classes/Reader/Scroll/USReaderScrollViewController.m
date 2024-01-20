//
//  USReaderScrollViewController.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/4.
//

#import "USReaderScrollViewController.h"
#import <Masonry/Masonry.h>
#import "USConstants.h"
#import "USReadScrollCell.h"
#import "USReaderTextFastParser.h"
#import "USReaderCoverCell.h"
#import "USReaderBottomProgressView.h"

@interface USReaderScrollViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) USReaderModel *readerModel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) USReaderBottomProgressView *bottomView;

@property (nonatomic, strong) NSMutableArray <NSNumber *>*chapterIds;
@property (nonatomic, strong) NSMutableArray <NSNumber *>*loadChapterIds;

@property (nonatomic, strong) NSMutableDictionary <NSString *, USReaderChapterModel *>*chapterModels;

@property (nonatomic, assign) BOOL isScrollUp;

@property (nonatomic, assign) CGPoint scrollPoint;

@end

@implementation USReaderScrollViewController

- (instancetype)initWithReaderModel:(USReaderModel *)readerModel {
    self = [super init];
    if (self) {
        self.readerModel = readerModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.chapterIds addObject:self.readerModel.recordModel.chapterModel.idString];
    [self preloadingNext:self.readerModel.recordModel.chapterModel];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(US_READER_INSETS);
    }];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(0);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.tableView.mas_bottom);
    }];
}

/// 获取章节内容模型
- (USReaderChapterModel *)GetChapterModel:(NSNumber *)chapterId {
    USReaderChapterModel *chapterModel;
    if ([self.chapterModels.allKeys containsObject:chapterId.stringValue]) {
        chapterModel = self.chapterModels[chapterId.stringValue];
    } else {
        BOOL isExist = [USReaderChapterModel isExist:self.readerModel.bookID chapterID:chapterId];
        if (!isExist) {
            chapterModel = [USReaderTextFastParser parser:self.readerModel chapterId:chapterId isUpdateFont:YES];
        } else {
            chapterModel = [USReaderChapterModel model:self.readerModel.bookID chapterId:chapterId isUpdateFont:YES];
        }
        self.chapterModels[chapterId.stringValue] = chapterModel;
    }
    return chapterModel;
}

// MARK: 预加载数据
- (void)preloadingPrevious:(USReaderChapterModel *)chapterModel {
    NSNumber *chapterId = chapterModel.previousChapterID;
    if (chapterModel == nil || chapterModel.isFirstChapter || [self.loadChapterIds containsObject:chapterId] || [self.chapterIds containsObject:chapterId] || chapterId == nil) {
        return;
    }
    [self.loadChapterIds addObject:chapterId];
    NSString *bookId = chapterModel.bookID;
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        BOOL isExist = [USReaderChapterModel isExist:bookId chapterID:chapterId];
        USReaderChapterModel *tempChapterModel;
        if (isExist) {
            tempChapterModel = [USReaderChapterModel model:bookId chapterId:chapterId isUpdateFont:YES];
        } else {
            tempChapterModel = [USReaderTextFastParser parser:self.readerModel chapterId:chapterId isUpdateFont:YES];
        }
        self.chapterModels[chapterId.stringValue] = tempChapterModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger currentIndex = [self.chapterIds indexOfObject:chapterModel.idString];
            NSInteger previousIndex = MAX(0, currentIndex - 1);
            NSInteger loadIndex = [self.loadChapterIds indexOfObject:chapterId];
            [self.chapterIds insertObject:chapterId atIndex:previousIndex];

            [self.loadChapterIds removeObjectAtIndex:loadIndex];
            
            [self.tableView reloadData];
            
            self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + tempChapterModel.pageTotalHeight);
        });
    });
}

/// 预加载下一个章节
- (void)preloadingNext:(USReaderChapterModel *)chapterModel {
    NSNumber *chapterId = chapterModel.nextChapterID;
    if (chapterModel == nil || chapterModel.isLastChapter || [self.loadChapterIds containsObject:chapterId] || [self.chapterIds containsObject:chapterId] || chapterId == nil) {
        return;
    }
    [self.loadChapterIds addObject:chapterId];
    NSString *bookId = chapterModel.bookID;
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        BOOL isExist = [USReaderChapterModel isExist:bookId chapterID:chapterId];
        USReaderChapterModel *tempChapterModel;
        if (isExist) {
            tempChapterModel = [USReaderChapterModel model:bookId chapterId:chapterId isUpdateFont:YES];
        } else {
            tempChapterModel = [USReaderTextFastParser parser:self.readerModel chapterId:chapterId isUpdateFont:YES];
        }
        self.chapterModels[chapterId.stringValue] = tempChapterModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger nextIndex = MAX(0, [self.chapterIds indexOfObject:chapterModel.idString] + 1);
            NSInteger loadIndex = [self.loadChapterIds indexOfObject:chapterId];
            
            [self.chapterIds insertObject:chapterId atIndex:nextIndex];
            
            [self.loadChapterIds removeObjectAtIndex:loadIndex];
            
            [self.tableView reloadData];
            
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:nextIndex] withRowAnimation:(UITableViewRowAnimationNone)];
        });
    });
}


#pragma mark - USReaderProtocol
- (USReaderRecordModel *)recordModel {
    USReaderRecordModel *recordModel = self.readerModel.recordModel;
    return recordModel;
}

/// 翻页
- (void)nextPage {
    
}

- (void)lastPage {
    
}

- (void)toPage:(NSInteger)page {
    
}

/// 翻章节
- (void)nextChapter {
    NSString *bookId = self.recordModel.bookID;
    NSNumber *chapterId = self.recordModel.chapterModel.idString;
    NSNumber *nextChapterId = self.recordModel.chapterModel.nextChapterID;
    if (self.recordModel.isLastChapter) {
        return;
    }
    BOOL isExist = [USReaderChapterModel isExist:bookId chapterID:nextChapterId];
    if (isExist) {
        [self.recordModel modify:nextChapterId toPage:0 isSave:NO];
        if (![self.chapterIds containsObject:nextChapterId]) {
            self.chapterModels[nextChapterId.stringValue] = self.recordModel.chapterModel;
            NSInteger nextIndex = MAX(0, [self.chapterIds indexOfObject:chapterId] + 1);
            [self.chapterIds insertObject:nextChapterId atIndex:nextIndex];
            [self.tableView reloadData];
            
            self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + self.recordModel.chapterModel.pageTotalHeight);
        } else {
            self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + self.recordModel.chapterModel.pageTotalHeight);
        }
    } else {
        USReaderChapterModel *tempChapterModel = [USReaderTextFastParser parser:self.readerModel chapterId:nextChapterId isUpdateFont:YES];
        if (tempChapterModel) {
            [self.recordModel modify:nextChapterId toPage:0 isSave:NO];
            if (![self.chapterIds containsObject:nextChapterId]) {
                self.chapterModels[nextChapterId.stringValue] = self.recordModel.chapterModel;
                NSInteger nextIndex = MAX(0, [self.chapterIds indexOfObject:chapterId] + 1);
                [self.chapterIds insertObject:nextChapterId atIndex:nextIndex];
                [self.tableView reloadData];
                
                self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + self.recordModel.chapterModel.pageTotalHeight);
            } else {
                self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + self.recordModel.chapterModel.pageTotalHeight);
            }
        }
    }
}

- (void)lastChapter {
    NSString *bookId = self.recordModel.bookID;
    NSNumber *chapterId = self.recordModel.chapterModel.idString;
    NSNumber *previousChapterId = self.recordModel.chapterModel.previousChapterID;
    if (self.recordModel.isLastChapter && !previousChapterId) {
        return;
    }
    BOOL isExist = [USReaderChapterModel isExist:bookId chapterID:previousChapterId];
    if (isExist) {
        [self.recordModel modify:previousChapterId toPage:0 isSave:NO];
        if (![self.chapterIds containsObject:previousChapterId]) {
            self.chapterModels[previousChapterId.stringValue] = self.recordModel.chapterModel;
            NSInteger previousIndex = MAX(0, [self.chapterIds indexOfObject:chapterId] - 1);
            NSInteger loadIndex = [self.loadChapterIds indexOfObject:previousChapterId];
            [self.chapterIds insertObject:previousChapterId atIndex:previousIndex];
            [self.tableView reloadData];
            
            self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + self.recordModel.chapterModel.pageTotalHeight);
        } else {
            self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + self.recordModel.chapterModel.pageTotalHeight);
        }
    } else {
        USReaderChapterModel *tempChapterModel = [USReaderTextFastParser parser:self.readerModel chapterId:previousChapterId isUpdateFont:YES];
        if (tempChapterModel) {
            [self.recordModel modify:previousChapterId toPage:0 isSave:NO];
            if (![self.chapterIds containsObject:previousChapterId]) {
                self.chapterModels[previousChapterId.stringValue] = self.recordModel.chapterModel;
                NSInteger previousIndex = MAX(0, [self.chapterIds indexOfObject:chapterId] - 1);
                [self.chapterIds insertObject:previousChapterId atIndex:previousIndex];
                [self.tableView reloadData];
                
                self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + self.recordModel.chapterModel.pageTotalHeight);
            } else {
                self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y + self.recordModel.chapterModel.pageTotalHeight);
            }
        }
    }
}

/// 默认翻到该章节第一页
- (void)toChapter:(NSInteger)chapter {

}

/// 指定章节与页码
- (void)toChapter:(NSInteger)chapter page:(NSInteger)page {
    
}

/// 刷新页面，可能涉及字体变更，间距变化等，需要重新计算page
- (void)reloadData {
    
}

- (void)changeToBgImage:(UIImage *)bgImage {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.chapterIds.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSNumber *chapterId = self.chapterIds[section];
    
    USReaderChapterModel *chapterModel = [self GetChapterModel:chapterId];
    
    return chapterModel.pageCount.integerValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *chapterId = self.chapterIds[indexPath.section];
    
    USReaderChapterModel *chapterModel = [self GetChapterModel:chapterId];
    if (chapterModel.isFirstChapter) {
        USReaderCoverCell *coverCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USReaderCoverCell class]) forIndexPath:indexPath];
        coverCell.coverView.avatarView.image = chapterModel.avatar;
        coverCell.coverView.titleLabel.text = chapterModel.name;
        coverCell.coverView.authorLabel.text = chapterModel.author;
        coverCell.coverView.catalogLabel.text = chapterModel.catalog;
        coverCell.coverView.descLabel.text = chapterModel.bookDesc;
        return coverCell;
    }
    USReadScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([USReadScrollCell class]) forIndexPath:indexPath];

    USReaderPageModel *pageModel = chapterModel.pageModels[indexPath.row];
    
    cell.pageModel = pageModel;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *chapterId = self.chapterIds[indexPath.section];
    
    USReaderChapterModel *chapterModel = [self GetChapterModel:chapterId];
    if (chapterModel.isFirstChapter) {
        return US_READERRECT.size.height;
    }
    
    return chapterModel.pageModels[indexPath.row].contentSize.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    USReaderChapterModel *chapterModel = self.chapterModels[self.chapterIds[section].stringValue];
    [self preloadingPrevious:chapterModel];
    [self preloadingNext:chapterModel];
}

/// 书籍首页将要出现
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        return;
    }
    NSNumber *chapterId = self.chapterIds[indexPath.section];
    USReaderChapterModel *chapterModel = [self GetChapterModel:chapterId];
    USReaderPageModel *pageModel = chapterModel.pageModels[indexPath.row];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isScrollUp = YES;
    self.scrollPoint = CGPointZero;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self updateReadRecord:self.isScrollUp];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self updateReadRecord:self.isScrollUp];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateReadRecord:self.isScrollUp];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (CGPointEqualToPoint(self.scrollPoint, CGPointZero)) {
        return;
    }
    CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView];
    if (point.y < self.scrollPoint.y) { // 上滚
        self.isScrollUp = YES;
    } else if (point.y > self.scrollPoint.y) { //下滚
        self.isScrollUp = NO;
    }
    self.scrollPoint = point;
}

- (void)updateReadRecord:(BOOL)isRollingUp {
    NSArray<NSIndexPath *> *indexPaths = [self.tableView indexPathsForVisibleRows];
    
    // 异步更新(推荐使用异步)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (indexPaths == nil || indexPaths.count == 0) {
            return;
        }
        NSIndexPath *indexPath = self.isScrollUp ? indexPaths.lastObject:indexPaths.firstObject;
        NSNumber *chapterId = self.chapterIds[indexPath.section];
        USReaderChapterModel *chapterModel = [self GetChapterModel:chapterId];
        [self.readerModel.recordModel modify:chapterModel page:indexPath.row isSave:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /// 设置chapter的标题
            [self reloadProgress];
        });
    });
}

/// 刷新阅读进度显示
- (void)reloadProgress {
    [self.bottomView reloadData:self.readerModel.recordModel];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_tableView registerClass:[USReadScrollCell class] forCellReuseIdentifier:NSStringFromClass([USReadScrollCell class])];
        [_tableView registerClass:[USReaderCoverCell class] forCellReuseIdentifier:NSStringFromClass([USReaderCoverCell class])];
    }
    return _tableView;
}

- (USReaderBottomProgressView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[USReaderBottomProgressView alloc] initWithRecordModel:self.recordModel];
    }
    return _bottomView;
}

- (NSMutableArray<NSNumber *> *)chapterIds {
    if (!_chapterIds) {
        _chapterIds = [NSMutableArray array];
    }
    return _chapterIds;
}

- (NSMutableArray<NSNumber *> *)loadChapterIds {
    if (!_loadChapterIds) {
        _loadChapterIds = [NSMutableArray array];
    }
    return _loadChapterIds;
}

- (NSMutableDictionary<NSString *,USReaderChapterModel *> *)chapterModels {
    if (!_chapterModels) {
        _chapterModels = [NSMutableDictionary dictionary];
    }
    return _chapterModels;
}

@end
