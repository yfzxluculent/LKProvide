//
//  LKChatAVAudioPlayer.h
//  LiemsMobile70
//
//  Created by WZheng on 2020/4/6.
//  Copyright © 2020 Luculent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKChatAVAudioPlayer : NSObject

@property (nonatomic, copy, nullable) NSString *URLString;
/**
 *  identifier -> 主要作用是提供记录,用来控制对应的tableViewCell的状态
 */
@property (nonatomic, copy, nullable) NSString *identifier;


/**
 *  当前播放器播放的状态,当tableView滚动时,匹配index来设置对应的audioPlayerState
 */
@property (nonatomic, assign) LKChatVoiceMessageState audioPlayerState;

+ (instancetype)sharePlayer;

- (void)playAudioWithURLString:(NSString *)URLString identifier:(NSString *)identifier;

- (void)stopAudioPlayer;

- (void)cleanAudioCache;


@end

NS_ASSUME_NONNULL_END
