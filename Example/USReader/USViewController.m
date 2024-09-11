//
//  USViewController.m
//  USReader
//
//  Created by nongyun.cao on 12/03/2023.
//  Copyright (c) 2023 nongyun.cao. All rights reserved.
//

#import "USViewController.h"
#import "USReaderController.h"
#import <USReader/USReaderTextFastParser.h>
#import <USReader/USReaderModel.h>
#import <USReader/USReaderSpeech.h>

@interface USViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blackTechTitleLabel;

@end

@implementation USViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"第1章出战.txt" ofType:nil];
    NSString *blackTechPath = [[NSBundle mainBundle] pathForResource:@"学霸的黑科技系统" ofType:nil];
    if (path.length > 0) {
        self.titleLabel.text = path.lastPathComponent;
    }
    if (blackTechPath.length > 0) {
        self.blackTechTitleLabel.text = blackTechPath.lastPathComponent;
    }
}

- (USReaderModel *)parse {
    NSString *path = [[NSBundle mainBundle] pathForResource:self.titleLabel.text ofType:nil];
    USReaderModel * readerModel = [USReaderTextFastParser parserNovelURL:[NSURL fileURLWithPath:path]];
    return readerModel;
}

- (USReaderModel *)parseBlackTech {
    NSString *path = [[NSBundle mainBundle] pathForResource:self.blackTechTitleLabel.text ofType:nil];
    USReaderModel * readerModel = [USReaderTextFastParser parserNovelURL:[NSURL fileURLWithPath:path]];
    return readerModel;
}

static NSInteger count = 0;
- (IBAction)push:(id)sender {
    USReaderController *vc = [[USReaderController alloc] initWithReaderModel:[self parse]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)pushBlackTech:(id)sender {
    USReaderController *vc = [[USReaderController alloc] initWithReaderModel:[self parseBlackTech]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
