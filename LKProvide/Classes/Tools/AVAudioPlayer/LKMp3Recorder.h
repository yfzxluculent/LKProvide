//
//  LKMp3Recorder.h
//  LiemsMobileEnterprise
//
//  Created by WZheng on 2019/11/5.
//  Copyright © 2019 luculent. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LKMp3RecorderDelegate <NSObject>
- (void)failRecord;
- (void)beginConvert;
- (void)endConvertWithMP3FileName:(NSString *)fileName;
@end

@interface LKMp3Recorder : NSObject

@property (nonatomic, weak) id<LKMp3RecorderDelegate> delegate;
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioRecorder *recorder;

- (id)initWithDelegate:(id<LKMp3RecorderDelegate>)delegate;
- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;
@end


