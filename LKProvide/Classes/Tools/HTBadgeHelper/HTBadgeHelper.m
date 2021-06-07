#import "HTBadgeHelper.h"


@interface HTBadgeHelper() {
    NSMutableDictionary *_everyCountDic;
}

@end

@implementation HTBadgeHelper

+ (HTBadgeHelper *)sharedHTBadgeHelper
{ 
    static HTBadgeHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HTBadgeHelper alloc] init];
        [_sharedInstance initEveryCount];
    });
    
    return _sharedInstance;
}

-(void)initEveryCount{
    _everyCountDic = [NSMutableDictionary dictionary];
}

-(NSInteger)getTotalCount{
    
    NSInteger total = 0;
    for (NSString *key in _everyCountDic.allKeys) {
        total = total + [_everyCountDic[key] integerValue];
    }
    return total;
}

-(void)setCount:(NSInteger)count forKey:(NSString *)key{
    
    if (key) {
        
        count = count>0?count:0;
        [_everyCountDic setObject:@(count).description forKey:key];
    }

    [self refreshApplicationBadge];
}

-(NSInteger)getCountForKey:(NSString*)key{
    return [_everyCountDic[key] integerValue];
}

-(void)refreshApplicationBadge{

    NSInteger num = [self getTotalCount];
    [UIApplication sharedApplication].applicationIconBadgeNumber = num;
}

-(void)clearApplicationBadge{
    
    for (NSString *key in _everyCountDic.allKeys) {
        _everyCountDic[key] = @"0";
    }
    
    [self refreshApplicationBadge];
}

@end
