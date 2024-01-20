//
//  USReaderAudioPlay.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/7.
//

#import "USReaderAudioPlay.h"
#import "USReaderSpeech.h"

@interface USReaderAudioPlay ()

@property (nonatomic, strong) USReaderRecordModel *recordModel;

@end

@implementation USReaderAudioPlay

+ (instancetype)sharedPlay {
    static dispatch_once_t onceToken;
    static USReaderAudioPlay *play;
    dispatch_once(&onceToken, ^{
        play = [[USReaderAudioPlay alloc] init];
    });
    return play;
}

- (void)playRecord:(USReaderRecordModel *)record {
    _recordModel = record;
    for (USReaderPageModel *pageModel in record.chapterModel.pageModels) {
        /// 每一个页面生成一个音频文件，一个章节计算总时长
        NSString *pageContent = pageModel.showContent.string;
        NSString *path = [NSString stringWithFormat:@"%@/Documents/%@/%@/%@.mp3", NSHomeDirectory(), record.bookID, record.chapterModel.idString, pageModel.page];
        [[USReaderSpeech sharedSpeech] saveUriWithText:pageContent path:path];
    }
}

@end
