
#import <Foundation/Foundation.h>
#import "TTNetworkDefine.h"


@interface TTRequestModel : NSObject


@property(nonatomic, strong) NSString * _host;


@property(nonatomic, strong) NSString * _uri;


@property(nonatomic, strong) NSString * _method;


@property(nonatomic, copy) NSDictionary * _params;


@property(nonatomic, strong) NSString * _response;


@property(nonatomic, copy) TTConstructingBodyBlock _bodyBlock;


@property(nonatomic, assign) BOOL _isNoNeedCommonParams;


@property(nonatomic, strong) NSDictionary * _additionGetParams;


- (NSString *)_requestURIStr;


- (NSURL *)_requestURL;


- (NSDictionary *)_requestParams;


- (NSString *)_requestMethod;

@end


