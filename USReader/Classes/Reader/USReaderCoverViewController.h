//
//  USReaderCoverViewController.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import <UIKit/UIKit.h>
#import "USReaderRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderCoverViewController : UIViewController

@property (nonatomic, strong, readonly) USReaderRecordModel *recordModel;

- (instancetype)initWithRecordModel:(USReaderRecordModel *)recordModel;

- (void)changeToBgImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
