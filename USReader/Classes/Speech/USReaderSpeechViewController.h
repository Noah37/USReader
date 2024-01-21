//
//  USReaderSpeechViewController.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/6.
//

#import <UIKit/UIKit.h>
#import "USReaderRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderSpeechViewController : UIViewController

@property (nonatomic, copy) USReaderRecordModel *(^nextRecordHandler)(USReaderRecordModel *recordModel);
@property (nonatomic, copy) USReaderRecordModel *(^previousRecordHandler)(USReaderRecordModel *recordModel);

@property (nonatomic, copy) void(^playNextHandler)(USReaderRecordModel *recordModel);
@property (nonatomic, copy) void(^playPreviousHandler)(USReaderRecordModel *recordModel);

- (instancetype)initWithRecordModel:(USReaderRecordModel *)recordModel;

- (void)setCurrentRecordModel:(USReaderRecordModel *)recordModel;

- (void)reloadData;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
