//
//  USReaderSpeaker.h
//  USReader
//
//  Created by nongyun.cao on 2024/1/6.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TTSEngineTypeIflyCloud,
    TTSEngineTypeIflyOffline,
    TTSEngineTypeHSCloud,
    TTSEngineTypeHSOffline,
} TTSEngineType;

NS_ASSUME_NONNULL_BEGIN

typedef NSString* EngineType NS_TYPED_EXTENSIBLE_ENUM;
FOUNDATION_EXPORT EngineType const EngineTypeAuto;
FOUNDATION_EXPORT EngineType const EngineTypeLocal;
FOUNDATION_EXPORT EngineType const EngineTypeCloud;

@interface USReaderSpeaker : NSObject

/// 普通话
@property (nonatomic, copy) NSString *accent;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *appid;

@property (nonatomic, copy) NSString *commonExpirationDate;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger downloads;

@property (nonatomic, copy) EngineType engineType;

@property (nonatomic, assign) NSInteger engineVersion;

@property (nonatomic, copy) NSString *ent;

@property (nonatomic, copy) NSString *experienceExpirationDate;

@property (nonatomic, copy) NSString *field;

@property (nonatomic, assign) BOOL isActive;

@property (nonatomic, assign) BOOL isDefault;

@property (nonatomic, assign) BOOL isNew;

@property (nonatomic, assign) BOOL isRecommend;

@property (nonatomic, assign) BOOL isVip;

@property (nonatomic, copy) NSString *largeIcon;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *listenPath;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) NSInteger price;

@property (nonatomic, assign) NSInteger resId;

@property (nonatomic, copy) NSString *resPath;

@property (nonatomic, assign) NSInteger resSize;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *smallIcon;

@property (nonatomic, assign) NSInteger sortId;

@property (nonatomic, assign) NSInteger speakerId;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *version;

@property (nonatomic, copy) NSString *downloadUrl;

@property (nonatomic, copy) NSString *prelisten;

@property (nonatomic, strong) NSAttributedString *engineHeaderName;

/// ============== hs engine
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *voice;
@property (nonatomic, copy) NSString *mode;
/// 引擎类型
@property (nonatomic, assign, readonly) TTSEngineType realEngineType;


- (NSString *)engineName;

- (NSString *)getCurrentAvatar;

- (NSString *)getCurrentName;

@end

NS_ASSUME_NONNULL_END

