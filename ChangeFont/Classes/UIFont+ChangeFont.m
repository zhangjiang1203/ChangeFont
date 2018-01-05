//
//  UIFont+ChangeFont.m
//  ChangeFontTest
//
//  Created by Sljr on 2018/1/4.
//  Copyright © 2018年 Sljr. All rights reserved.
//

#import "UIFont+ChangeFont.h"
#import <objc/runtime.h>

#ifndef kScale
#define kScale MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) / 375
#endif
@implementation UIFont (ChangeFont)

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //修改添加的方法fontWithSize
        SEL orignalSel = @selector(fontWithSize:);
        Method orignalMet = class_getInstanceMethod(class, orignalSel);

        SEL swizzledSel = @selector(zj_fontWithSize:);
        Method swizzledMet = class_getInstanceMethod(class, swizzledSel);
        //添加方法
        BOOL didAddMethod = class_addMethod(class, orignalSel, method_getImplementation(swizzledMet), method_getTypeEncoding(swizzledMet));
        //交换方法
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSel, method_getImplementation(orignalMet), method_getTypeEncoding(orignalMet));
        }else{
            method_exchangeImplementations(orignalMet, swizzledMet);
        }
        
        //修改添加的方法ZJSystemFontOfSize
        //系统方法
        Method orignalM1 = class_getClassMethod(class, @selector(systemFontOfSize:));
        Method orignalM2 = class_getClassMethod(class, @selector(systemFontOfSize:weight:));
        Method orignalM3 = class_getClassMethod(class, @selector(fontWithName:size:));
        //交换方法
        Method swizzledM1 = class_getClassMethod(class, @selector(zj_systemFontOfSize:));
        Method swizzledM2 = class_getClassMethod(class, @selector(zj_systemFontOfSize:weight:));
        Method swizzledM3 = class_getClassMethod(class, @selector(zj_fontWithName:size:));
        
        method_exchangeImplementations(orignalM1, swizzledM1);
        method_exchangeImplementations(orignalM2, swizzledM2);
        method_exchangeImplementations(orignalM3, swizzledM3);
    });
}

+ (UIFont *)zj_systemFontOfSize:(CGFloat)fontSize{
    return [UIFont zj_systemFontOfSize:fontSize * kScale];
}

+ (UIFont *)zj_systemFontOfSize:(CGFloat)fontSize weight:(CGFloat)weight{
    return [UIFont zj_systemFontOfSize:fontSize * kScale weight:weight];
}

+(UIFont*)zj_fontWithName:(NSString*)fontName size:(CGFloat)fontSize{
    return [self zj_fontWithName:fontName size:fontSize * kScale];
}

-(UIFont*)zj_fontWithSize:(CGFloat)pointSize{
    return [self zj_fontWithSize:pointSize*kScale];
}

@end
