//
//  USReaderSpeaker.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/6.
//

#import "USReaderSpeaker.h"

EngineType const EngineTypeAuto = @"auto";
EngineType const EngineTypeLocal = @"local";
EngineType const EngineTypeCloud = @"cloud";

@implementation USReaderSpeaker

- (NSString *)getCurrentAvatar {
    if (_avatar.length > 0) {
        return _avatar;
    }
    return _smallIcon;
}

- (NSString *)getCurrentName {
    if (_nickname.length > 0) {
        return _nickname;
    }
    return _name;
}

- (NSString *)engineName {
    if (self.mode.length > 0) {
        if ([self.mode isEqualToString:@"online"]) {
            return @"在线";
        }
        return @"离线";
    }
    if ([self.engineType isEqualToString:EngineTypeLocal]) {
        return @"离线";
    }
    return @"在线";
}

- (TTSEngineType)realEngineType {
    if (self.avatar.length > 0) {
        if ([self.mode isEqualToString:@"online"]) {
            return TTSEngineTypeHSCloud;
        }
        return TTSEngineTypeHSOffline;
    } else {
        if ([self.engineType isEqualToString:EngineTypeCloud]) {
            return TTSEngineTypeIflyCloud;
        } else {
            return TTSEngineTypeIflyOffline;
        }
    }
    
}

- (NSAttributedString *)engineHeaderName {
    if (!_engineHeaderName) {
        if ([self.engineType isEqualToString:EngineTypeLocal]) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"离线音色 | 播放免流量" attributes:@{
                NSFontAttributeName:[UIFont boldSystemFontOfSize:18],
                NSForegroundColorAttributeName:[UIColor blackColor]
            }];
            [attr addAttributes:@{
                        NSFontAttributeName:[UIFont systemFontOfSize:13],
                        NSForegroundColorAttributeName:[UIColor grayColor]
            } range:NSMakeRange(4, 8)];
            return attr;
        }
        return [[NSAttributedString alloc] initWithString:@"在线"];
    }
    return _engineHeaderName;
}

@end
