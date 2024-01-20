//
//  USReaderCatalogViewController.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import <UIKit/UIKit.h>
#import "USReaderModel.h"
#import "USReaderRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderCatalogViewController : UIViewController

@property (nonatomic, copy) void(^didSelectRow)(NSNumber *idString);

- (instancetype)initWithReaderModel:(USReaderModel *)readerModel recordModel:(USReaderRecordModel *)recordModel;

@end

NS_ASSUME_NONNULL_END
