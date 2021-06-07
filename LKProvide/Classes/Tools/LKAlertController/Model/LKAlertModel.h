//
//  LKAlertModel.h
//  LKAlertController-Demo
//
//  Created by Luculent on 2021/5/10.
//  Copyright © 2021 Luculent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKAlertModel : NSObject

@property (copy, nonatomic) NSString *label; /**<名称*/
@property (copy, nonatomic) NSString *value; /**<主键*/
@property (assign, nonatomic, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
