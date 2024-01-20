//
//  USReaderSpeakersCell.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/7.
//

#import <UIKit/UIKit.h>
#import "USReaderSpeaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReaderSpeakersCell : UICollectionViewCell

- (void)setCellSelected:(BOOL)selected;

- (void)setSpeaker:(USReaderSpeaker *)speaker;

@end

NS_ASSUME_NONNULL_END
