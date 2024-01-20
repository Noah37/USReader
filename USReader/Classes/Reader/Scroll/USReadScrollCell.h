//
//  CloudreveReadCell.h
//  CloudreveReader
//
//  Created by nongyun.cao on 2023/12/1.
//

#import <UIKit/UIKit.h>
#import "USReaderView.h"
#import "USReaderPageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface USReadScrollCell : UITableViewCell

@property (nonatomic, strong) USReaderPageModel *pageModel;

+ (USReadScrollCell *)cellFor:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
