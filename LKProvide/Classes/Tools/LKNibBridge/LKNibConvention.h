//
//  LKNibConvention.h
//  testXibBridge
//
//  Created by YY on 2018/7/13.
//  Copyright © 2018年 luculent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LKNibConvention <NSObject>

+ (NSString *)nibid;

+ (UINib *)nib;

@end

@interface UIView (LKNibConvention) <LKNibConvention>

+ (id)lk_instantiateFromNib;

+ (id)lk_instantiateFromNibInBundle:(NSBundle *)bundle owner:(id)owner;

@end

@interface UIViewController (LKNibConvention) <LKNibConvention>

+ (id)lk_instantiateFromStoryboardNamed:(NSString *)name;

@end
