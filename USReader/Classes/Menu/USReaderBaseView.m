//
//  USReaderBaseView.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/3.
//

#import "USReaderBaseView.h"
#import "USReaderMenu.h"
#import <Masonry/Masonry.h>

@interface USReaderBaseView ()

@property (nonatomic, strong) USReaderMenu *readerMenu;

@end

@implementation USReaderBaseView

- (instancetype)initWithMenu:(USReaderMenu *)menu {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _readerMenu = menu;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    
}

- (void)afterDismiss {
    
}

@end
