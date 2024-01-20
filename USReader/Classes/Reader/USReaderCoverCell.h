//
//  USReaderCoverCell.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import <UIKit/UIKit.h>
#import "USReaderCoverView.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderCoverCell : UITableViewCell

@property (nonatomic, strong, readonly) USReaderCoverView *coverView;

@end

NS_ASSUME_NONNULL_END
