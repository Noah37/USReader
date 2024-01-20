//
//  USReaderBottomProgressView.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import <UIKit/UIKit.h>
#import "USReaderRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderBottomProgressView : UIView

- (instancetype)initWithRecordModel:(USReaderRecordModel *)recordModel;

- (void)reloadData:(USReaderRecordModel *)recordModel;

@end

NS_ASSUME_NONNULL_END
