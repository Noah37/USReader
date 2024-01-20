//
//  UIView+USTools.m
//  USReader
//
//  Created by nongyun.cao on 2024/1/5.
//

#import "UIView+USTools.h"
#import <objc/runtime.h>
#import "USReaderConfigure.h"

void class_swizzleInstanceMethod(Class class, SEL originalSEL, SEL replacementSEL)
{
    //class_getInstanceMethod()，如果子类没有实现相应的方法，则会返回父类的方法。
    Method originMethod = class_getInstanceMethod(class, originalSEL);
    Method replaceMethod = class_getInstanceMethod(class, replacementSEL);
    
    //class_addMethod() 判断originalSEL是否在子类中实现，如果只是继承了父类的方法，没有重写，那么直接调用method_exchangeImplementations，则会交换父类中的方法和当前的实现方法。此时如果用父类调用originalSEL，因为方法已经与子类中调换，所以父类中找不到相应的实现，会抛出异常unrecognized selector.
    //当class_addMethod() 返回YES时，说明子类未实现此方法(根据SEL判断)，此时class_addMethod会添加（名字为originalSEL，实现为replaceMethod）的方法。此时在将replacementSEL的实现替换为originMethod的实现即可。
    //当class_addMethod() 返回NO时，说明子类中有该实现方法，此时直接调用method_exchangeImplementations交换两个方法的实现即可。
    //注：如果在子类中实现此方法了，即使只是单纯的调用super，一样算重写了父类的方法，所以class_addMethod() 会返回NO。
    
    //可用BaseClass实验
    if(class_addMethod(class, originalSEL, method_getImplementation(replaceMethod),method_getTypeEncoding(replaceMethod)))
    {
        class_replaceMethod(class,replacementSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }else {
        method_exchangeImplementations(originMethod, replaceMethod);
    }
}


@implementation UIView (USTools)


+ (void)load {
    class_swizzleInstanceMethod([self class], @selector(setBackgroundColor:), @selector(us_setBackgroundColor:));
}

- (void)us_setBackgroundColor:(UIColor *)backgroundColor {
//    CGFloat alpha = [USReaderConfigure shared].light.integerValue;
//    CGFloat backgroundAlpha = 1;
//    [backgroundColor getWhite:nil alpha:&backgroundAlpha];
//    if (backgroundAlpha > 0) {
//        UIColor *us_bgColor = [backgroundColor colorWithAlphaComponent:alpha];
//        [self us_setBackgroundColor:us_bgColor];
//    } else {
        [self us_setBackgroundColor:backgroundColor];
//    }
}

@end
