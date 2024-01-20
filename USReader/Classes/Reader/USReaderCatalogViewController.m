//
//  USReaderCatalogViewController.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import "USReaderCatalogViewController.h"
#import <Masonry/Masonry.h>
#import "USConstants.h"

@interface USReaderCatalogViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) USReaderModel *readerModel;

@property (nonatomic, strong) USReaderRecordModel *recordModel;

@end

@implementation USReaderCatalogViewController

- (instancetype)initWithReaderModel:(USReaderModel *)readerModel recordModel:(USReaderRecordModel *)recordModel {
    self = [super init];
    if (self) {
        self.readerModel = readerModel;
        self.recordModel = recordModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.readerModel.bookName;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.tableView.superview);
        make.top.inset(97);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [self selectedIndexPath];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
}

- (NSIndexPath *)selectedIndexPath {
    NSIndexPath *indexPath = nil;
    for (USReaderChapterListModel *chapterListModel in self.readerModel.showChapterListModels) {
        if ([chapterListModel.idString isEqual:self.recordModel.chapterModel.idString]) {
            indexPath = [NSIndexPath indexPathForRow:[self.readerModel.chapterListModels indexOfObject:chapterListModel] inSection:0];
            break;
        }
    }
    return indexPath;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.readerModel.showChapterListModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    USReaderChapterListModel *chapterListModel = self.readerModel.showChapterListModels[indexPath.row];
    cell.textLabel.text = [chapterListModel showName];
    if ([chapterListModel.idString isEqual:self.recordModel.chapterModel.idString]) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.textLabel.textColor = [UIColor grayColor];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    USReaderChapterListModel *chapterListModel = self.readerModel.showChapterListModels[indexPath.row];
    if (self.didSelectRow) {
        self.didSelectRow(chapterListModel.idString);
    }
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}


@end
