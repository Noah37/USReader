//
//  USReaderController.m
//  Pods-USReader_Example
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderController.h"
#import <Masonry/Masonry.h>
#import "USReaderController+ReaderMenu.h"
#import "USReaderController+EffectType.h"
#import "USPageViewController.h"
#import "USReaderConfigure.h"
#import "USReaderAudioPlayer.h"

@interface USReaderController ()<USReaderContentViewDelegate>

@property (nonatomic, strong) USReaderMenu *readerMenu;

@property (nonatomic, strong) CALayer *brightnessLayer;

@property (nonatomic, strong) UIViewController <USReaderProtocol> *displayViewController;

@end

@implementation USReaderController

- (instancetype)initWithReaderModel:(USReaderModel *)readerModel {
    self = [super init];
    if (self) {
        self.readerModel  = readerModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView.superview);
    }];
    
    self.brightnessLayer.frame = CGRectMake(0, 0, ScreenWidth, [UIScreen mainScreen].bounds.size.height);
    [self.view.layer addSublayer:self.brightnessLayer];
    [self reloadData];
    
    self.readerMenu;
    [self creatPageController:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[USReaderAudioPlayer sharedPlayer] stop];
}

- (void)setDisplayViewController:(UIViewController<USReaderProtocol> *)displayViewController {
    _displayViewController = displayViewController;
}

- (void)switchToEffectType:(USEffectType)effectType {
    [[USReaderConfigure shared] save];
    [self creatPageController:nil];
}

- (void)reloadData {
    CGFloat light = [USReaderConfigure shared].light.doubleValue;
    self.brightnessLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1-light].CGColor;
}

- (USReaderRecordModel *)currentRecordModel {
    return [self.displayViewController recordModel];
}

#pragma mark - Status
- (BOOL)prefersStatusBarHidden {
    return !self.readerMenu.isMenuShow;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.readerMenu.isMenuShow ? UIStatusBarStyleLightContent:UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - USReaderContentViewDelegate
- (void)contentViewClickCover:(USReaderContentView *)contentView {
    
}

#pragma mark - getter
- (USReaderContentView *)contentView {
    if (!_contentView) {
        _contentView = [[USReaderContentView alloc] init];
        _contentView.delegate = self;
    }
    return _contentView;
}

- (USReaderMenu *)readerMenu {
    if (!_readerMenu) {
        _readerMenu = [[USReaderMenu alloc] initWithVC:self delegate:self];
    }
    return _readerMenu;
}

- (CALayer *)brightnessLayer {
    if (!_brightnessLayer) {
        _brightnessLayer = [[CALayer alloc] init];
    }
    return _brightnessLayer;
}

@end
