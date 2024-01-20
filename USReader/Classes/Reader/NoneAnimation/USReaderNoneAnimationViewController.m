//
//  USReaderNoneAnimationViewController.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/4.
//

#import "USReaderNoneAnimationViewController.h"

@interface USReaderNoneAnimationViewController ()

@property (nonatomic, strong) USReaderModel *readerModel;

@end

@implementation USReaderNoneAnimationViewController

- (instancetype)initWithReaderModel:(USReaderModel *)readerModel {
    self = [super init];
    if (self) {
        self.readerModel = readerModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
