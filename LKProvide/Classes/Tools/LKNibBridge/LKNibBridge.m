//
//  LKNibBridge.m
//  testXibBridge
//
//  Created by YY on 2018/7/13.
//  Copyright © 2018年 luculent. All rights reserved.
//

#import "LKNibBridge.h"
#import <objc/runtime.h>

@interface LKNibBridge : NSObject

- (id)hackedAwakeAfterUsingCoder:(NSCoder *)decoder NS_REPLACES_RECEIVER;

@end

@implementation LKNibBridge

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(awakeAfterUsingCoder:);
        SEL swizzledSelector = @selector(hackedAwakeAfterUsingCoder:);
        
        Method originalMethod = class_getInstanceMethod(UIView.class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
        if (class_addMethod(UIView.class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
            class_replaceMethod(UIView.class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (id)hackedAwakeAfterUsingCoder:(NSCoder *)decoder {
    if ([self.class conformsToProtocol:@protocol(LKNibBridge)] && !((UIView *)self).subviews.count) {
        return [LKNibBridge instantiateRealViewFromPlaceholder:(UIView *)self];
    }
    
    return self;
}

+ (UIView *)instantiateRealViewFromPlaceholder:(UIView *)placeholderView {
    UIView *realView = [[placeholderView class] lk_instantiateFromNib];
    
    realView.tag = placeholderView.tag;
    realView.frame = placeholderView.frame;
    realView.bounds = placeholderView.bounds;
    realView.hidden = placeholderView.hidden;
    realView.clipsToBounds = placeholderView.clipsToBounds;
    realView.autoresizingMask = placeholderView.autoresizingMask;
    realView.userInteractionEnabled = placeholderView.userInteractionEnabled;
    realView.translatesAutoresizingMaskIntoConstraints = placeholderView.translatesAutoresizingMaskIntoConstraints;
    
    // Copy autolayout constrains.
    if (placeholderView.constraints.count) {
        
        // We only need to copy "self" constraints (like width/height constraints)
        // from placeholder to real view
        for (NSLayoutConstraint *constraint in placeholderView.constraints) {
            NSLayoutConstraint *newConstraint;
            
            // "Height" or "Width" constraint
            // "self" as its first item, no second item
            if (!constraint.secondItem) {
                newConstraint = [NSLayoutConstraint constraintWithItem:realView attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:nil attribute:constraint.secondAttribute multiplier:constraint.multiplier constant:constraint.constant];
            }
            // "Aspect ratio" constraint
            // "self" as its first AND second item
            else if ([constraint.firstItem isEqual:constraint.secondItem]) {
                newConstraint = [NSLayoutConstraint constraintWithItem:realView
                                                             attribute:constraint.firstAttribute
                                                             relatedBy:constraint.relation
                                                                toItem:realView
                                                             attribute:constraint.secondAttribute
                                                            multiplier:constraint.multiplier
                                                              constant:constraint.constant];
            }
            
            // Copy properties to new constraint
            if (newConstraint) {
                newConstraint.shouldBeArchived = constraint.shouldBeArchived;
                newConstraint.priority = constraint.priority;
                newConstraint.identifier = constraint.identifier;
                
                [realView addConstraint:newConstraint];
            }
        }
    }
    
    return realView;
}

@end
