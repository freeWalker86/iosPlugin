//
//  FWTestStaticFramework.m
//  FWStaticFramework
//
//  Created by lv on 14-3-6.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import "FWTestStaticFramework.h"

@implementation FWTestStaticFramework
+ (void)staticFrameworkClassMethodSayHello{
    NSLog(@">>>FWTestStaticFramework  ClassMethodSayHello");
}

- (void)staticFrameworkIntanceMethodSayHello{
    NSLog(@">>>FWTestStaticFramework  IntanceMethodSayHello");
}
@end
