//
//  USReaderBGItem.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import <UIKit/UIKit.h>
#import "USReaderBGType.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderBGItem : UIControl

@property (nonatomic, strong, readonly) USReaderBGType *bgType;

- (void)setBgType:(USReaderBGType *)bgType;

@end

NS_ASSUME_NONNULL_END
