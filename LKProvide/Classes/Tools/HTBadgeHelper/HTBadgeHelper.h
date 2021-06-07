#import <UIKit/UIKit.h>

#define HTBADGEHELPER [HTBadgeHelper sharedHTBadgeHelper]


/**
 角标助手类
 */
@interface HTBadgeHelper : NSObject

/**
 获取单例
 */
+ (HTBadgeHelper *)sharedHTBadgeHelper;

/**
 设置指定key的角标数

 @param count 角标数
 @param key 指定的关键字
 */
-(void)setCount:(NSInteger)count forKey:(NSString *)key;

/**
 根据指定关键字，获取角标数

 @param key 指定的关键字
 @return 角标数
 */
-(NSInteger)getCountForKey:(NSString*)key;

/**
 获取总的角标数

 @return 总角标数
 */
-(NSInteger)getTotalCount;

/**
 刷新app的角标数
 */
-(void)refreshApplicationBadge;

/**
 清空app的角标数
 */
-(void)clearApplicationBadge;

@end

