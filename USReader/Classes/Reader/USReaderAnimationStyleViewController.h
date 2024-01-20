//
//  USReaderAnimationStyleViewController.h
//  USReader
//
//  Created by nongyun.cao on 2023/12/9.
//

#import <UIKit/UIKit.h>
#import "USReaderEffectTypeConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderAnimationStyleViewController : UIViewController

@property (nonatomic, copy) void(^didSelectRow)(NSIndexPath *indexPath, USReaderEffectTypeConfigure *configure);

@end

NS_ASSUME_NONNULL_END
