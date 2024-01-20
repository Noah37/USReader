//
//  USReaderTranslationViewController.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/4.
//

#import "USReaderTranslationViewController.h"
#import "USPageViewController.h"
#import "USReaderViewController.h"
#import <Masonry/Masonry.h>
#import "UIView+Extension.h"
#import "USReaderBgViewController.h"
#import "USReaderModel.h"
#import "USReaderTextFastParser.h"
#import "USConstants.h"
#import "USReaderCoverViewController.h"

@interface USReaderTranslationViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, USPageViewControllerDelegate>

@property (nonatomic, strong) USPageViewController *pageViewController;

@property (nonatomic, strong) USReaderModel *readerModel;

@end

@implementation USReaderTranslationViewController

- (instancetype)initWithReaderModel:(USReaderModel *)readerModel {
    self = [super init];
    if (self) {
        self.readerModel = readerModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.pageViewController setViewControllers:@[[self currentReaderViewController]] direction:(UIPageViewControllerNavigationDirectionForward) animated:NO completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.pageViewController.view.superview);
    }];
}

- (USReaderRecordModel *)recordModel {
    USReaderRecordModel *recordModel;
    UIViewController *viewController = self.pageViewController.viewControllers.firstObject;
    if ([viewController isKindOfClass:[USReaderViewController class]]) {
        recordModel = ((USReaderViewController *)viewController).recordModel;
    } else if ([viewController isKindOfClass:[USReaderBgViewController class]]) {
        recordModel = ((USReaderBgViewController *)viewController).recordModel;
    }
    return recordModel;
}

- (USReaderCoverViewController *)currentReaderViewController {
    USReaderCoverViewController *coverVC = [[USReaderCoverViewController alloc] initWithRecordModel:self.readerModel.recordModel];
    return coverVC;
}

/// 获取上一个章节的阅读记录
- (USReaderRecordModel *)getBeforeChapterRecordModel:(USReaderRecordModel *)recordModel {
    if (recordModel.chapterModel == nil) {
        return nil;
    }
    USReaderRecordModel *beforeRecordModel = [recordModel copy];
    NSString *bookId = beforeRecordModel.bookID;
    NSNumber *chapterId = beforeRecordModel.chapterModel.previousChapterID;
    if (beforeRecordModel.isFirstChapter) {
        return nil;
    }
    BOOL isExist = [USReaderChapterModel isExist:bookId chapterID:chapterId];
    if (isExist) {
        [beforeRecordModel modify:chapterId toPage:0 isSave:NO];
    } else {
        [USReaderTextFastParser parser:self.readerModel chapterId:chapterId isUpdateFont:YES];
    }
    return beforeRecordModel;
}

/// 获取下一个章节的阅读记录
- (USReaderRecordModel *)getAfterChapterRecordModel:(USReaderRecordModel *)recordModel {
    if (recordModel.chapterModel == nil) {
        return nil;
    }
    USReaderRecordModel *afterRecordModel = [recordModel copy];
    NSString *bookId = afterRecordModel.bookID;
    NSNumber *chapterId = afterRecordModel.chapterModel.nextChapterID;
    if (afterRecordModel.isLastChapter) {
        return nil;
    }
    BOOL isExist = [USReaderChapterModel isExist:bookId chapterID:chapterId];
    if (isExist) {
        [afterRecordModel modify:chapterId toPage:0 isSave:NO];
    } else {
        [USReaderTextFastParser parser:self.readerModel chapterId:chapterId isUpdateFont:YES];
    }
    return afterRecordModel;
}

/// 获取指定页面的阅读记录
- (USReaderRecordModel *)getAppointPageRecordModel:(USReaderRecordModel *)recordModel withPage:(NSInteger)page {
    if (recordModel.chapterModel == nil) {
        return nil;
    }
    if (![recordModel isExistPage:page]) {
        return nil;
    }
    USReaderRecordModel *appointRecordModel = [recordModel copy];
    [appointRecordModel appointPage:page];
    return appointRecordModel;
}

/// 获取指定章节的阅读记录
- (USReaderRecordModel *)getAppointChapterRecordModel:(USReaderRecordModel *)recordModel withChapter:(NSInteger)chapter page:(NSInteger)page {
    if (recordModel.chapterModel == nil) {
        return nil;
    }
    NSString *bookId = recordModel.bookID;
    NSNumber *chapterId = [NSNumber numberWithInteger:chapter];
    USReaderRecordModel *appointRecordModel = [recordModel copy];
    BOOL isExist = [USReaderChapterModel isExist:bookId chapterID:chapterId];
    if (isExist) {
        [appointRecordModel modify:chapterId location:page isSave:NO];
    } else {
        USReaderChapterModel *chapterModel = [USReaderTextFastParser parser:self.readerModel chapterId:chapterId isUpdateFont:YES];
        if (!chapterModel) {
            return nil;
        }
        [appointRecordModel modify:chapterId location:page isSave:NO];
    }
    return appointRecordModel;
}

/// 获取上一个页面的阅读记录
- (USReaderRecordModel *)getBeforeRecordModel:(USReaderRecordModel *)recordModel {
    if (recordModel.chapterModel == nil) {
        return nil;
    }
    USReaderRecordModel *beforeRecordModel = [recordModel copy];
    NSString *bookId = beforeRecordModel.bookID;
    NSNumber *chapterId = beforeRecordModel.chapterModel.previousChapterID;
    if (beforeRecordModel.isFirstChapter && beforeRecordModel.isFirstPage) {
        return nil;
    }
    if (beforeRecordModel.isFirstPage) {
        BOOL isExist = [USReaderChapterModel isExist:bookId chapterID:chapterId];
        if (isExist) {
            [beforeRecordModel modify:chapterId toPage:-1 isSave:NO];
        } else {
            [USReaderTextFastParser parser:self.readerModel chapterId:chapterId isUpdateFont:YES];
        }
    } else {
        [beforeRecordModel previousPage];
    }
    
    return beforeRecordModel;
}

/// 获取下一个页面的阅读记录
- (USReaderRecordModel *)getAfterRecordModel:(USReaderRecordModel *)recordModel {
    if (recordModel.chapterModel == nil) {
        return nil;
    }
    USReaderRecordModel *afterRecordModel = [recordModel copy];
    NSString *bookId = afterRecordModel.bookID;
    NSNumber *chapterId = afterRecordModel.chapterModel.nextChapterID;
    if (afterRecordModel.isLastChapter && afterRecordModel.isLastPage) {
        return nil;
    }
    if (afterRecordModel.isLastPage) {
        BOOL isExist = [USReaderChapterModel isExist:bookId chapterID:chapterId];
        if (isExist) {
            [afterRecordModel modify:chapterId toPage:0 isSave:NO];
        } else {
            [USReaderTextFastParser parser:self.readerModel chapterId:chapterId isUpdateFont:YES];
        }
    } else {
        [afterRecordModel nextPage];
    }
    
    return afterRecordModel;
}

#pragma mark - USReaderProtocol
/// 翻页
- (void)nextPage {
    [self pageViewController:self.pageViewController getViewControllerAfter:self.pageViewController.viewControllers.firstObject];
}

- (void)lastPage {
    [self pageViewController:self.pageViewController getViewControllerBefore:self.pageViewController.viewControllers.firstObject];
}

- (void)toPage:(NSInteger)page {
    USReaderRecordModel *recordModel;
    UIViewController *viewController = self.pageViewController.viewControllers.firstObject;
    if ([viewController isKindOfClass:[USReaderViewController class]]) {
        recordModel = ((USReaderViewController *)viewController).recordModel;
    } else if ([viewController isKindOfClass:[USReaderCoverViewController class]]) {
        recordModel = ((USReaderCoverViewController *)viewController).recordModel;
    }
    USReaderRecordModel *appointRecordModel = [self getAppointPageRecordModel:recordModel withPage:page];
    if (!appointRecordModel) {
        return;
    }
    USReaderViewController *appointVC = [[USReaderViewController alloc] initWithRecordModel:appointRecordModel];
    [self.pageViewController setViewControllers:@[appointVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
}

/// 翻章节
- (void)nextChapter {
    USReaderRecordModel *recordModel;
    UIViewController *viewController = self.pageViewController.viewControllers.firstObject;
    if ([viewController isKindOfClass:[USReaderViewController class]]) {
        recordModel = ((USReaderViewController *)viewController).recordModel;
    } else if ([viewController isKindOfClass:[USReaderCoverViewController class]]) {
        recordModel = ((USReaderCoverViewController *)viewController).recordModel;
    }
    USReaderRecordModel *afterRecordModel = [self getAfterChapterRecordModel:recordModel];
    if (!afterRecordModel) {
        return;
    }
    USReaderViewController *afterVC = [[USReaderViewController alloc] initWithRecordModel:afterRecordModel];
    [self.pageViewController setViewControllers:@[afterVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
}

- (void)lastChapter {
    USReaderRecordModel *recordModel;
    UIViewController *viewController = self.pageViewController.viewControllers.firstObject;
    if ([viewController isKindOfClass:[USReaderViewController class]]) {
        recordModel = ((USReaderViewController *)viewController).recordModel;
    } else if ([viewController isKindOfClass:[USReaderCoverViewController class]]) {
        recordModel = ((USReaderCoverViewController *)viewController).recordModel;
    }
    USReaderRecordModel *beforeRecordModel = [self getBeforeChapterRecordModel:recordModel];
    if (!beforeRecordModel) {
        return;
    }
    USReaderCoverViewController *coverVC = [[USReaderCoverViewController alloc] initWithRecordModel:beforeRecordModel];
    USReaderViewController *beforeVC = [[USReaderViewController alloc] initWithRecordModel:beforeRecordModel];
    if (beforeRecordModel.isFirstChapter) {
        [self.pageViewController setViewControllers:@[coverVC] direction:(UIPageViewControllerNavigationDirectionReverse) animated:YES completion:nil];
    } else {
        [self.pageViewController setViewControllers:@[beforeVC] direction:(UIPageViewControllerNavigationDirectionReverse) animated:YES completion:nil];
    }
}

/// 默认翻到该章节第一页
- (void)toChapter:(NSInteger)chapter {
    [self toChapter:chapter page:0];
}

/// 指定章节与页码
- (void)toChapter:(NSInteger)chapter page:(NSInteger)page {
    USReaderRecordModel *recordModel;
    UIViewController *viewController = self.pageViewController.viewControllers.firstObject;
    if ([viewController isKindOfClass:[USReaderViewController class]]) {
        recordModel = ((USReaderViewController *)viewController).recordModel;
    } else if ([viewController isKindOfClass:[USReaderCoverViewController class]]) {
        recordModel = ((USReaderCoverViewController *)viewController).recordModel;
    }
    USReaderRecordModel *appointRecordModel = [self getAppointChapterRecordModel:recordModel withChapter:chapter page:page];
    if (!appointRecordModel) {
        return;
    }
    USReaderCoverViewController *coverVC = [[USReaderCoverViewController alloc] initWithRecordModel:appointRecordModel];
    USReaderViewController *appointVC = [[USReaderViewController alloc] initWithRecordModel:appointRecordModel];
    if (appointRecordModel.isFirstChapter) {
        [self.pageViewController setViewControllers:@[coverVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
    } else {
        [self.pageViewController setViewControllers:@[appointVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
    }
}

/// 刷新页面，可能涉及字体变更，间距变化等，需要重新计算page
- (void)reloadData {
    
}

- (void)changeToBgImage:(UIImage *)bgImage {
    
}

#pragma mark - USPageViewControllerDelegate
/// 获取上一页
- (void)pageViewController:(USPageViewController *_Nullable)pageViewController getViewControllerBefore:(UIViewController *_Nullable)viewController {
    // 获取当前页阅读记录
    USReaderRecordModel *recordModel;
    if ([viewController isKindOfClass:[USReaderViewController class]]) {
        recordModel = ((USReaderViewController *)viewController).recordModel;
    } else if ([viewController isKindOfClass:[USReaderCoverViewController class]]) {
        recordModel = ((USReaderCoverViewController *)viewController).recordModel;
    }
    USReaderRecordModel *beforeRecordModel = [self getBeforeRecordModel:recordModel];
    if (!beforeRecordModel) {
        return;
    }
    USReaderCoverViewController *coverVC = [[USReaderCoverViewController alloc] initWithRecordModel:beforeRecordModel];
    USReaderViewController *beforeVC = [[USReaderViewController alloc] initWithRecordModel:beforeRecordModel];
    if (beforeRecordModel.isFirstChapter && beforeRecordModel.isFirstPage) {
        [self.pageViewController setViewControllers:@[coverVC] direction:(UIPageViewControllerNavigationDirectionReverse) animated:YES completion:nil];
    } else {
        [self.pageViewController setViewControllers:@[beforeVC] direction:(UIPageViewControllerNavigationDirectionReverse) animated:YES completion:nil];
    }
}

/// 获取下一页
- (void)pageViewController:(USPageViewController *_Nullable)pageViewController getViewControllerAfter:(UIViewController *_Nullable)viewController {
    USReaderRecordModel *recordModel;
    if ([viewController isKindOfClass:[USReaderViewController class]]) {
        recordModel = ((USReaderViewController *)viewController).recordModel;
    } else if ([viewController isKindOfClass:[USReaderCoverViewController class]]) {
        recordModel = ((USReaderCoverViewController *)viewController).recordModel;
    }
    USReaderRecordModel *afterRecordModel = [self getAfterRecordModel:recordModel];
    if (!afterRecordModel) {
        return;
    }
    USReaderViewController *afterVC = [[USReaderViewController alloc] initWithRecordModel:afterRecordModel];
    [self.pageViewController setViewControllers:@[afterVC] direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    // 获取当前页阅读记录
    USReaderRecordModel *recordModel;
    if ([viewController isKindOfClass:[USReaderViewController class]]) {
        recordModel = ((USReaderViewController *)viewController).recordModel;
    } else if ([viewController isKindOfClass:[USReaderCoverViewController class]]) {
        recordModel = ((USReaderCoverViewController *)viewController).recordModel;
    }
    USReaderRecordModel *beforeRecordModel = [self getBeforeRecordModel:recordModel];
    USReaderCoverViewController *coverVC = [[USReaderCoverViewController alloc] initWithRecordModel:beforeRecordModel];
    USReaderViewController *beforeVC = [[USReaderViewController alloc] initWithRecordModel:beforeRecordModel];
    if (!beforeRecordModel) {
        return nil;
    }
    
    if (beforeRecordModel.isFirstChapter && beforeRecordModel.isFirstPage) {
        return coverVC;
    }
    return beforeVC;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    // 获取当前页阅读记录
    USReaderRecordModel *recordModel;
    if ([viewController isKindOfClass:[USReaderViewController class]]) {
        recordModel = ((USReaderViewController *)viewController).recordModel;
    } else if ([viewController isKindOfClass:[USReaderCoverViewController class]]) {
        recordModel = ((USReaderCoverViewController *)viewController).recordModel;
    }
    USReaderRecordModel *afterRecordModel = [self getAfterRecordModel:recordModel];
    USReaderViewController *afterVC = [[USReaderViewController alloc] initWithRecordModel:afterRecordModel];
    if (!afterRecordModel) {
        return nil;
    }
    return afterVC;
}

#pragma mark - getter
- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        NSDictionary *options = @{
            UIPageViewControllerOptionSpineLocationKey:@(UIPageViewControllerSpineLocationMin)
        };
        _pageViewController = [[USPageViewController alloc] initWithTransitionStyle:(UIPageViewControllerTransitionStyleScroll) navigationOrientation:(UIPageViewControllerNavigationOrientationHorizontal) options:options];
        _pageViewController.dataSource = self;
        _pageViewController.USDelegate = self;
        _pageViewController.delegate = self;
        _pageViewController.view.backgroundColor = [UIColor clearColor];
    }
    return _pageViewController;
}

@end
