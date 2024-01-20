//
//  USReaderViewController.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <UIKit/UIKit.h>
#import "USReaderRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 实际用来展示每页阅读数据的控制器
@interface USReaderViewController : UIViewController

@property (nonatomic, strong, readonly) USReaderRecordModel *recordModel;

- (instancetype)initWithRecordModel:(USReaderRecordModel *)recordModel;

- (void)changeToBgImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
