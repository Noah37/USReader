//
//  USReaderAnimationStyleViewController.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import "USReaderAnimationStyleViewController.h"
#import <Masonry/Masonry.h>
#import "USConstants.h"
#import "USReaderConfigure.h"

@interface USReaderAnimationStyleViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary<NSNumber*, USReaderEffectTypeConfigure *> *effectTypes;

@end

@implementation USReaderAnimationStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.effectTypes = [USReaderEffectTypeConfigure effectTypes];
    self.title = @"翻页方式";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.tableView.superview);
        make.top.inset(US_NAVIGATIONBAR_HEIGHT);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.effectTypes.allValues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    USReaderEffectTypeConfigure *configure = self.effectTypes.allValues[indexPath.row];
    cell.textLabel.text = configure.effectString;
    if ([USReaderConfigure.shared.effectTypeConfigure.effectTypeIndex isEqual:configure.effectTypeIndex]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    USReaderEffectTypeConfigure *configure = self.effectTypes.allValues[indexPath.row];
    if (self.didSelectRow) {
        self.didSelectRow(indexPath, configure);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
