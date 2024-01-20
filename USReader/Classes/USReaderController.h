//
//  USReaderController.h
//  Pods-USReader_Example
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <UIKit/UIKit.h>
#import "USReaderContentView.h"
#import "USReaderProtocol.h"
#import "USReaderModel.h"
#import "USReaderMenu.h"
#import "USReaderEffectTypeConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderController : UIViewController

@property (nonatomic, strong) USReaderContentView *contentView;

@property (nonatomic, strong, readonly) UIViewController <USReaderProtocol> *displayViewController;

@property (nonatomic, strong) USReaderModel *readerModel;

@property (nonatomic, strong, readonly) USReaderMenu *readerMenu;

- (void)setDisplayViewController:(nullable UIViewController<USReaderProtocol> *)displayViewController;

- (instancetype)initWithReaderModel:(USReaderModel *)readerModel;

- (void)switchToEffectType:(USEffectType)effectType;

- (void)reloadData;

- (USReaderRecordModel *)currentRecordModel;

@end

NS_ASSUME_NONNULL_END
