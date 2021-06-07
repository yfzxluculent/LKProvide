//
//  LKNibConvention.m
//  testXibBridge
//
//  Created by YY on 2018/7/13.
//  Copyright © 2018年 luculent. All rights reserved.
//

#import "LKNibConvention.h"

@implementation UIView (LKNibConvention)

+ (NSString *)nibid {
    return NSStringFromClass(self);
}

+ (UINib *)nib {
    return [UINib nibWithNibName:self.nibid bundle:nil];
}

+ (id)lk_instantiateFromNib {
    return [self lk_instantiateFromNibInBundle:nil owner:nil];
}

+ (id)lk_instantiateFromNibInBundle:(NSBundle *)bundle owner:(id)owner {
    NSArray *views = [self.nib instantiateWithOwner:owner options:nil];
    for (UIView *view in views) {
        if ([view isMemberOfClass:self.class]) {
            return view;
        }
    }
    NSAssert(NO, @"Expect file: %@.xib", self.nibid);
    return nil;
}

@end

@implementation UIViewController (LKNibConvention)

+ (NSString *)nibid {
    return NSStringFromClass(self);
}

+ (UINib *)nib {
    return [UINib nibWithNibName:self.nibid bundle:nil];
}

+ (id)lk_instantiateFromStoryboardNamed:(NSString *)name {
    NSParameterAssert(name.length);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    NSAssert(storyboard, @"Expect file: %@.storyboard",name);
    return [storyboard instantiateViewControllerWithIdentifier:self.nibid];
}

@end
